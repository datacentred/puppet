#!/usr/bin/env python
"""
Returns the metrics from llama as standard output to be ingested by telegraf.
"""

import json
import urllib

import requests

URL = "http://localhost:5000/latency"
FLAGPOLE_URL = "http://localhost:5000/status"

def main():
    """
    Polls server to check its state, grabs metrics and outputs in telegraf format
    """

    llama_status = requests.get(FLAGPOLE_URL, timeout=3)
    if llama_status.status_code == 200 and llama_status.text == "ok":
        response = urllib.urlopen(URL)
        collection = json.loads(response.read())
        for entry in collection:
            src_host = entry["tags"]["src_host"]
            dst_host = entry["tags"]["dst_host"]
            loss_value = entry["data"][0][1]
            rtt_value = entry["data"][1][1]
            print 'llama,src_host={},domain=datacentred.io,dst_host={} loss={},rtt={}'.\
                  format(src_host, dst_host, loss_value, rtt_value)

if __name__ == '__main__':
    main()

# vi:ts=4 et:
