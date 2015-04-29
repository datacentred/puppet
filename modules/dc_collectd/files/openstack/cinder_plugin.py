#!/usr/bin/env python
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
#   Xav Paice <xav@catalyst.net.nz>
#
# About this plugin:
#   This plugin collects OpenStack cinder information, including stats on
#   volumes and snapshots usage per tenant.
#
#
# collectd:
#   http://collectd.org
# OpenStack Cinder:
#   http://docs.openstack.org/developer/cinder
# collectd-python:
#   http://collectd.org/documentation/manpages/collectd-python.5.shtml
#
#

import traceback

import base

from cinderclient.client import Client as CinderClient
import collectd


class CinderPlugin(base.Base):

    def __init__(self):
        base.Base.__init__(self)
        self.prefix = 'openstack-cinder'

    def get_stats(self):
        """Retrieves stats from cinder."""
        keystone = self.get_keystone()

        tenant_list = keystone.tenants.list()

        tenants = {}
        data = {self.prefix: {}}

        if getattr(self, 'region') is None:
            client = CinderClient('2', self.username, self.password,
                                  self.tenant, self.auth_url)
        else:
            client = CinderClient('2', self.username, self.password,
                                  self.tenant, self.auth_url,
                                  region_name=self.region)
        for tenant in tenant_list:
            tenants[tenant.id] = tenant.name
            # TODO(xp) grab this list from the available volume types, rather
            # than just the totals
            data[self.prefix]["tenant-%s" % tenant.name] = {
                'gigabytes': {'in_use': 0, 'limit': 0, 'reserved': 0},
                'snapshots': {'in_use': 0, 'limit': 0, 'reserved': 0},
                'volumes': {'in_use': 0, 'limit': 0, 'reserved': 0}
            }
            data_tenant = data[self.prefix]["tenant-%s" % tenant.name]
            try:
                quotaset = client.quotas.get(tenant.id, usage=True)
            except Exception as e:
                collectd.error(e.errno, e.strerror)
                continue
            data_tenant['gigabytes'] = quotaset.gigabytes
            data_tenant['snapshots'] = quotaset.snapshots
            data_tenant['volumes'] = quotaset.volumes
            data[self.prefix]["tenant-%s" % tenant.name] = data_tenant
        return data

try:
    plugin = CinderPlugin()
except Exception as exc:
    collectd.error("openstack-cinder: failed to initialize cinder plugin :: %s :: %s"
                   % (exc, traceback.format_exc()))


def configure_callback(conf):
    """Received configuration information."""
    plugin.config_callback(conf)


def read_callback():
    """Callback triggerred by collectd on read."""
    plugin.read_callback()

collectd.register_config(configure_callback)
collectd.register_read(read_callback, plugin.interval)
