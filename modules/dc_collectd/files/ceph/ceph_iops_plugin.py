"""Collectd plugin for collecting IOP/s using 'ceph -s' aka ceph summary"""
import collectd
import subprocess
import json
import ceph.base as base
class CephIopsPlugin(base.Base):
    """Collect I/O ops per second """
    def __init__(self):
        base.Base.__init__(self)
        self.prefix = 'ceph'
    def get_stats(self):
        """retrieve IOP stat data"""
        ceph_cluster = "%s-%s" % (self.prefix, self.cluster)
        data = {ceph_cluster:{'health': {'iops':0}}}
        try:
            output = subprocess.check_output('ceph -s --format json',
                shell=True
                    )
        except subprocess.CalledProcessError as exc:
            collectd.error(
            "ceph-iops: failed to ceph -s :: Output is %s :: error code %i"
                    % (exc.output, exc.returncode)
                    )
            return
        try:
            json_data = json.loads(output)
        except ValueError:
            collectd.error("ceph-iops: output parse failure")
            return
        json_data = json.loads(output)
        data[ceph_cluster]['health']['iops'] = json_data['pgmap']['op_per_sec']
        return data
plugin = CephIopsPlugin()
def configure_callback(conf):
    """Received configuration information"""
    plugin.config_callback(conf)
def read_callback():
    """Callback triggerred by collectd on read"""
    plugin.read_callback()
collectd.register_config(configure_callback)
collectd.register_read(read_callback, plugin.interval)
