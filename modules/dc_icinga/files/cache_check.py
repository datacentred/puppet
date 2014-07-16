#!/usr/bin/env python

import sys, os, time
import subprocess
import argparse
import hashlib
from json import loads, dumps
import logging

PARSER = argparse.ArgumentParser()
PARSER.add_argument("-c", "--command",
            help="Command",
            type=str,
            required=True)
PARSER.add_argument("-e", "--expire",
            help="Expire time for the cache in sec.",
            type=int,
            default=60)
PARSER.add_argument("-d", "--debug",
            help="Enable debug mode (log in file).",
            action='store_true')
PARSER.add_argument("-t", "--timeout",
            help="Timeout for the command in sec.",
            type=int,
            default=10)
PARSER.add_argument("-i", "--interval",
            help="Minimum interval between command in sec.",
            type=int,
            default=-1)

# Init value
OK = 0
WARNING = 1
CRITICAL = 2
UNKNOWN = 3

CACHE_DIR = '/dev/shm/cache_check'
LOG = logging.getLogger(__name__)


def _detach_process(parent_exit_code=0):
    '''Double fork way :
    Fork a second child and exit immediately to prevent zombies.  This
    causes the second child process to be orphaned, making the init
    process responsible for its cleanup.  And, since the first child is
    a session leader without a controlling terminal, it's possible for
    it to acquire one by opening a terminal in the future (System V-
    based systems).  This second fork guarantees that the child is no
    longer a session leader, preventing the daemon from ever acquiring
    a controlling terminal.'''
    try:
        pid = os.fork()
        if pid > 0:
            # exit first parent
            sys.exit(parent_exit_code)
    except OSError, e:
        sys.stderr.write("fork #1 failed: %d (%s)\n" % (e.errno, e.strerror))
        sys.exit(1)

    # do second fork
    try:
        pid = os.fork()
        if pid > 0:
            # exit from second parent
            sys.exit(0)
    except OSError, e:
        sys.stderr.write("fork #2 failed: %d (%s)\n" % (e.errno, e.strerror))
        sys.exit(1)


def _exit_and_refresh_cache(command, timeout, cache_file, exit_code):
    ''''Exit parent process, launch detached system
        commande and update cache with is output'''

    # Detach process (exit parent)
    _detach_process(parent_exit_code=exit_code)

    # Set refresh_launched true
    cache = _get_cache(cache_file)
    if cache is not None:
        cache['refresh_launched'] = True
    else:
        cache = {
            'command': command,
            'timeout': timeout,
            'stdout': '',
            'stderr': '',
            'last_runtime': 0,
            'return_code': UNKNOWN,
            'last_check': int(time.time()),
            'refresh_launched': True,
        }

    _set_cache(cache_file, cache)

    LOG.debug("%s - run command : %s" % (cache_file, command))
    # Launch command and get output
    start_time = time.time()
    (return_code, stdout, stderr) = _run_cmd(command, timeout)
    now = time.time()
    runtime = round(now - start_time, 2)

    # Refresh cache with new infos
    cache = {
        'command': command,
        'timeout': timeout,
        'last_runtime': runtime,
        'stdout': stdout,
        'stderr': stderr,
        'return_code': return_code,
        'last_check': int(now),
        'refresh_launched': False,
    }
    _set_cache(cache_file, cache)


def _run_cmd(cmd, timeout):
    "Run a system command"
    p = subprocess.Popen('timeout %s %s' % (timeout, cmd),
                         shell=True,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE)
    return_code = p.wait()
    (stdoutdata, stderrdata) = p.communicate()
    # Chomp \n on output
    return return_code, stdoutdata.rstrip('\n'), stderrdata.rstrip('\n')


def _set_cache(filename, cache):
    'Write cache in file'
    LOG.debug("%s - write cache %s" % (filename, cache))
    if not os.path.isdir(CACHE_DIR):
        try:
            os.mkdir(CACHE_DIR)
        except OSError:
            return False
    cache_path = os.path.join(CACHE_DIR, filename)
    try:
        with open(cache_path, 'w') as f:
            f.write(dumps(cache))
        return True
    except IOError:
        return False


def _get_cache(filename):
    'Load cache from file'
    try:
        cache_path = os.path.join(CACHE_DIR, filename)
        with open(cache_path, 'r') as f:
            return loads(f.read())
    except (ValueError, IOError):
        return None

def _runcmd_interval_is_respected(cache, interval):
    'Check if interval between 2 run command in respected'
    if interval == -1: return True
    now = int(time.time())
    last_time = cache.get('last_check', 0)
    if (now - last_time) > interval:
        return True
    return False

def _cache_is_expired(cache, expire):
    'Check if cache is expired'
    now = int(time.time())
    cache_time = cache.get('last_check', 0)
    if (now - cache_time) > expire:
        return True
    return False


def do_check(cache_file, expire, interval):
    'Return outputcode, outputstring, run_cmd'
    # Get cache for this check
    cache = _get_cache(cache_file)
    if cache is None or not cache:
        # try write
        if not _set_cache(cache_file, {}):
            return CRITICAL, "CRITICAL - Can't parse and write cache file %s" % cache_file, False
        else:
            return UNKNOWN, "UNKNOWN - Nothing in cache file %s" % cache_file, True

    # Run background command if this command is not running
    # And minimum time interval is respected
    if not cache.get('refresh_launched', False) \
    and _runcmd_interval_is_respected(cache, interval):
        run_cmd = True
    else:
        run_cmd = False

    LOG.debug("%s Command will be launched %s" % (cache_file, run_cmd))

    # Exit if cache is expired
    if _cache_is_expired(cache, expire):
        return CRITICAL, "CRITICAL - Cache file expired %s" % cache_file, run_cmd

    # Format output
    output = ' - '.join([cache.get('stdout', ''), cache.get('stderr', '')])
    cache_return_code = cache.get('return_code')
    if cache_return_code not in [OK, WARNING, CRITICAL, UNKNOWN]:
        return_code = UNKNOWN
        output = ('UNKNOWN return code %s for this script. %s'
                        % (cache_return_code, output))
    else:
        return_code = cache_return_code

    return return_code, output, run_cmd


def _init_log(debug):
    'Just init file loger in case of debug mode'
    log = logging.getLogger()
    log.setLevel(logging.DEBUG)
    if debug:
        hdl = logging.FileHandler('/tmp/cache_check.log')
        logformat = '%(asctime)s %(levelname)s -: %(message)s'
        formatter = logging.Formatter(logformat)
        hdl.setFormatter(formatter)
    else:
        hdl = logging.NullHandler()
    log.addHandler(hdl)


if __name__ == '__main__':

    global ARGS
    ARGS = PARSER.parse_args()
    # Init logger
    _init_log(ARGS.debug)

    # Get cache file name
    cmd_hash = hashlib.md5(ARGS.command).hexdigest()
    cache_file = 'cache_%s.json' % cmd_hash

    (output_code, output_string, run_refresh) = do_check(cache_file,
                                                         ARGS.expire,
                                                         ARGS.interval)
    LOG.warning("%s exit %s / output : %s" % (cache_file, output_code,
                                              output_string))

    print output_string
    if run_refresh:
        _exit_and_refresh_cache(ARGS.command, ARGS.timeout,
                                cache_file, exit_code=output_code)
    else:
        sys.exit(output_code)

