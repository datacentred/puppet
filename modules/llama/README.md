# llama 

#### Table Of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup - The basics of getting started with llama](#setup)
    * [Setup Requirements](#setup-requirements)
4. [Usage](#usage)
5. [Limitations](#limitations)

## Overview

Installs Dropbox/llama latency and loss monitoring 

https://github.com/dropbox/llama

## Module Description

Clones the Dropbox/llama repo, builds the llama python module and  
installs it along with the required pre-requisites. 

Python module dependencies that will be required/installed via easy_install:

 PyYAML==3.12
 influxdb==3.0.0
 humanfriendly==2.2
 futures==3.0.5
 Flask==0.11.1
 docopt==0.6.2
 APScheduler==3.3.0
 six==1.10.0
 requests==2.2.1
 pytz==2016.7
 python-dateutil==2.6.0
 click==6.6
 itsdangerous==0.24
 Jinja2==2.8
 Werkzeug==0.11.11
 funcsigs==1.0.2
 tzlocal==1.3
 setuptools==30.2.0
 MarkupSafe==0.23

## Setup

### Setup Requirements

The following modules are required:

* http://github.com/puppetlabs/puppetlabs-stdlib
* http://github.com/puppetlabs/puppetlabs-vcsrepo

## Usage

By default a basic llama reflector can be deployed by simply including the llama module.

```puppet
include ::llama
```

To deploy a llama collector and reflector on the same box via hiera

```yaml
llama::llama_is_collector: true
llama::llama_collector_use_udp: true
llama::llama_collector_config:
  llama-collector.vagrant.test:
    rack: 01
    datacenter: dc01
```

## Limitations

* Only tested on Ubuntu Xenial 16.04
