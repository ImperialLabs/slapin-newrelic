# slapin-newrelic

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [slapin-newrelic](#slapin-newrelic)
- [Info](#info)
- [Status](#status)
- [Config](#config)
- [Commands/Usage](#commandsusage)
	- [Apps](#apps)
	- [Servers](#servers)

<!-- /TOC -->

# Info

SLAPI Plugin for New Relic

# Status

Currently in Beta

Basic Support for APM and Servers Services from New Relic

# Config

-   Get an integration API Key: <https://docs.newrelic.com/docs/apis/rest-api-v2/requirements/api-keys#viewing>
-   Set the NR_TOKEN in the config below or you can use the example file [newrelic.example.yml](newrelic.example.yml)
-   Place configured file at ``./slapi/config/plugins/newrelic.yml`
-   Start bot or just run `@bot reload` from chat
-   Profit

```yaml
plugin:
  type: api
  managed: true
  build: false
  build_force: false
  build_stream: false
  api_config:
    url: 'http://localhost:4700'
    endpoint: '/command'
  config:
    Image: 'slapi/slapin-newrelic'
    Env:
      - NR_TOKEN='00000000000CHANGEME'
    HostConfig:
      PortBindings:
        4700/tcp:
          -
            HostIp: '0.0.0.0'
            HostPort: '4700'
    Tty: true
    RestartPolicy:
     Name: on-failure
     MaximumRetryCount: 2
```

# Commands/Usage

Primary commands are broken down by New Relic Services, then expanded on from there.

## Apps

Main Level command lists all Apps (APM) in New Relic and their current status

`@bot apps`

![apps command](https://github.com/ImperialLabs/slapin-newrelic/raw/master/img/apps_nr_cmd.png)

## Servers

Main Level command lists all servers reporting to New Relic and their current status

`@bot servers`

![apps command](https://github.com/ImperialLabs/slapin-newrelic/raw/master/img/servers_nr_cmd.png)
