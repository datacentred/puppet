#!/usr/bin/env python
"""
Collectd Ceph Module
"""
#
# vim: tabstop=4 shiftwidth=4

# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; only version 2 of the License is applicable.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
#
# Authors:
#   Ricardo Rocha <ricardo@catalyst.net.nz>
#
# About this plugin:
#   Helper object for all plugins.
#
# collectd:
#   http://collectd.org
# collectd-python:
#   http://collectd.org/documentation/manpages/collectd-python.5.shtml
#

import collectd
import datetime
import traceback

class Base(object):
    """
    Base class for Ceph module
    """

    def __init__(self):
        self.verbose = False
        self.debug = False
        self.prefix = ''
        self.cluster = 'ceph'
        self.testpool = 'test'
        self.rbd_pool_stats = []
        self.interval = 60.0

    def config_callback(self, conf):
        """Takes a collectd conf object and fills in the local config."""
        for node in conf.children:
            if node.key == "Verbose":
                if node.values[0] in ['True', 'true']:
                    self.verbose = True
            elif node.key == "Debug":
                if node.values[0] in ['True', 'true']:
                    self.debug = True
            elif node.key == "Prefix":
                self.prefix = node.values[0]
            elif node.key == 'RBDPoolStats':
                self.rbd_pool_stats = node.values[0].split(',')
            elif node.key == 'Cluster':
                self.cluster = node.values[0]
            elif node.key == 'TestPool':
                self.testpool = node.values[0]
            elif node.key == 'Interval':
                self.interval = float(node.values[0])
            else:
                collectd.warning("%s: unknown config key: %s"
                                 % (self.prefix, node.key))

    def dispatch(self, stats):
        """
        Dispatches the given stats.
        """
        if not stats:
            collectd.error("%s: failed to retrieve stats" % self.prefix)
            return

        self.logdebug("dispatching %d new stats :: %s" % (len(stats), stats))
        try:
            for plugin in stats.keys():
                for plugin_instance in stats[plugin].keys():
                    for _type in stats[plugin][plugin_instance].keys():
                        type_value = stats[plugin][plugin_instance][_type]
                        if not isinstance(type_value, dict):
                            self.dispatch_value(plugin,
                                                plugin_instance,
                                                _type,
                                                None,
                                                type_value)
                        else:
                            for type_instance in stats[plugin][plugin_instance]\
                                    [_type].keys():
                                self.dispatch_value(plugin,
                                                    plugin_instance,
                                                    _type,
                                                    type_instance,
                                                    stats[plugin]\
                                                    [plugin_instance]\
                                                    [_type][type_instance])
        except Exception as exc:
            collectd.error("%s: failed to dispatch values :: %s :: %s"
                           % (self.prefix, exc, traceback.format_exc()))

    def dispatch_value(self, plugin, plugin_instance,
                       _type, type_instance, value):
        """
        Looks for the given stat in stats, and dispatches it
        """
        self.logdebug("dispatching value %s.%s.%s.%s=%s"
                      % (plugin, plugin_instance, _type, type_instance, value))

        val = collectd.Values(type='gauge')
        val.plugin = plugin
        val.plugin_instance = plugin_instance
        if type_instance is not None:
            val.type_instance = "%s-%s" % (_type, type_instance)
        else:
            val.type_instance = _type
        val.values = [value]
        val.interval = self.interval
        val.dispatch()
        self.logdebug("sent metric %s.%s.%s.%s.%s"
                      % (plugin, plugin_instance, _type, type_instance, value))

    def read_callback(self):
        """
        Callback
        """
        try:
            start = datetime.datetime.now()
            stats = self.get_stats()
            self.logverbose("collectd new data from service :: took %d seconds"
                            % (datetime.datetime.now() - start).seconds)
        except Exception as exc:
            collectd.error("%s: failed to get stats :: %s :: %s"
                           % (self.prefix, exc, traceback.format_exc()))
        self.dispatch(stats)

    def get_stats(self):
        """
        Get stats not implemented
        """
        collectd.error('Not implemented, should be subclassed')

    def logverbose(self, msg):
        """
        Verbose logging
        """
        if self.verbose:
            collectd.info("%s: %s" % (self.prefix, msg))

    def logdebug(self, msg):
        """
        Debug logging
        """
        if self.debug:
            collectd.info("%s: %s" % (self.prefix, msg))

