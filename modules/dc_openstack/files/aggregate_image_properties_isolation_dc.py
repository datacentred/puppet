# pylint: disable=F0401
"""
AggregateImagePropertiesIsolation filter module.
"""
from oslo_config import cfg
from oslo_log import log as logging

from nova.scheduler import filters
from nova.scheduler.filters import utils

OPTS = [
    cfg.StrOpt('aggregate_image_properties_isolation_namespace',
               help='Force the filter to consider only keys matching '
               'the given namespace.'),
    cfg.StrOpt('aggregate_image_properties_isolation_separator',
               default=".",
               help='The separator used between the namespace and keys'),
]
CONF = cfg.CONF
CONF.register_opts(OPTS)

LOG = logging.getLogger(__name__)


class AggregateImagePropertiesIsolationDC(filters.BaseHostFilter):
    """AggregateImagePropertiesIsolation works with image properties.
    This version introduces a new implementation of the filter.
    """
    # pylint: disable=too-few-public-methods

    # Aggregate data and instance type does not change within a request
    run_filter_once_per_request = True

    @classmethod
    def host_passes(cls, host_state, filter_properties):
        """Checks a host in an aggregate that metadata key/value match
        with image properties.
        """
        cfg_namespace = CONF.aggregate_image_properties_isolation_namespace
        cfg_separator = CONF.aggregate_image_properties_isolation_separator

        spec = filter_properties.get('request_spec', {})
        image_props = spec.get('image', {}).get('properties', {})
        metadata = utils.aggregate_metadata_get_by_host(host_state)

        # First assume the host should not pass the filter.
        # This will weed out hosts without any metadata
        # straight away.
        shall_pass = False

        # Images without metadata should be allowed to use
        # any host, so let them pass.
        if not image_props:
            return True

        for key, options in metadata.iteritems():
            if (cfg_namespace and
                    not key.startswith(cfg_namespace + cfg_separator)):
                continue

            prop = image_props.get(key)
            if prop:
                if str(prop) in options:
                    # Success: we have found a matching value,
                    # so this host can pass.
                    shall_pass = True
                    # Also, why bother checking consecutive parameters?
                    break
                else:
                    LOG.debug("%(host_state)s fails image aggregate properties "
                              "requirements. Property %(prop)s does not "
                              "match %(options)s.",
                              {'host_state': host_state,
                               'prop': prop,
                               'options': options})
            else:
                # If the metadata key doesn't have an equivalent
                # among image properties, just move on to the next one.
                # This also takes care of 'get' returning an empty object.
                LOG.warning("Host '%(host)s' has a metadata key '%(key)s' "
                            "that is not present in the image metadata.",
                            {"host": host_state.host, "key": key})

        return shall_pass
