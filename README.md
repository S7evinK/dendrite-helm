# dendrite

![Version: 0.6.0](https://img.shields.io/badge/Version-0.6.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.6.0](https://img.shields.io/badge/AppVersion-0.6.0-informational?style=flat-square)
Dendrite Matrix Homeserver

Status: **NOT PRODUCTION READY**

## About

This is a first try for a Helm Chart for the [Matrix](https://matrix.org) Homeserver [Dendrite](https://github.com/matrix-org/dendrite)

This chart creates a polylith, where every component is in its own deployment and requires a Postgres server aswell as a NATS JetStream server.

## Manual database creation

You'll need to create the following databases before starting Dendrite (see [install.md](https://github.com/matrix-org/dendrite/blob/master/docs/INSTALL.md#configuration)):

```postgres
create database dendrite_federationapi;
create database dendrite_mediaapi;
create database dendrite_roomserver;
create database dendrite_userapi_accounts;
create database dendrite_keyserver;
create database dendrite_userapi_devices;
create database dendrite_syncapi;
```

or

```bash
for i in mediaapi syncapi roomserver federationapi appservice keyserver userapi_accounts userapi_devices; do
    sudo -u postgres createdb -O dendrite dendrite_$i
done
```

## Usage with appservices

Create a folder `appservices` and place your configurations in there.  The configurations will be read and placed in a secret `dendrite-appservices-conf`.

## Source Code

* <https://github.com/matrix-org/dendrite>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| components.appservice.connect | string | `"appservice:7777"` | Connect is the address for other components to connect to |
| components.appservice.listen_int | int | `7777` | listen_int is the port for the internal api connection |
| components.clientapi.connect | string | `"clientapi:7771"` | Connect is the address for other components to connect to |
| components.clientapi.listen_ext | int | `8071` | listen_ext is the port for external connections |
| components.clientapi.listen_int | int | `7771` | listen_int is the port for the internal api connection |
| components.clientapi.registration.disabled | bool | `true` |  |
| components.clientapi.registration.enable_registration_captcha | bool | `false` |  |
| components.clientapi.registration.recaptcha_bypass_secret | string | `""` |  |
| components.clientapi.registration.recaptcha_private_key | string | `""` |  |
| components.clientapi.registration.recaptcha_public_key | string | `""` |  |
| components.clientapi.registration.recaptcha_siteverify_api | string | `""` |  |
| components.clientapi.registration.shared_secret | string | `""` |  |
| components.eduserver.connect | string | `"eduserver:7778"` | Connect is the address for other components to connect to |
| components.eduserver.listen_int | int | `7778` | listen_int is the port for the internal api connection |
| components.federationapi.connect | string | `"federationapi:7772"` | Connect is the address for other components to connect to |
| components.federationapi.disable_tls_validation | bool | `false` | Disable TLS validation |
| components.federationapi.listen_ext | int | `8072` | listen_ext is the port for external connections |
| components.federationapi.listen_int | int | `7772` | listen_int is the port for the internal api connection |
| components.federationapi.prefer_direct_fetch | bool | `false` |  |
| components.federationapi.send_max_retries | int | `16` |  |
| components.keyserver.connect | string | `"keyserver:7779"` | Connect is the address for other components to connect to |
| components.keyserver.listen_int | int | `7779` | listen_int is the port for the internal api connection |
| components.mediaapi.connect | string | `"mediaapi:7774"` | Connect is the address for other components to connect to |
| components.mediaapi.dynamic_thumbnails | bool | `false` |  |
| components.mediaapi.listen_ext | int | `8074` | listen_ext is the port for external connections |
| components.mediaapi.listen_int | int | `7774` | listen_int is the port for the internal api connection |
| components.mediaapi.max_file_size_bytes | string | `"10485760"` | The max file size for uploaded media files |
| components.mediaapi.max_thumbnail_generators | int | `10` | The maximum number of simultaneous thumbnail generators to run. |
| components.mediaapi.thumbnail_sizes | list | `[{"height":32,"method":"crop","width":32},{"height":96,"method":"crop","width":96},{"height":480,"method":"scale","width":640}]` | A list of thumbnail sizes to be generated for media content. |
| components.roomserver.connect | string | `"roomserver:7770"` | Connect is the address for other components to connect to |
| components.roomserver.listen_int | int | `7770` | listen_int is the port for the internal api connection |
| components.syncapi.connect | string | `"syncapi:7773"` | Connect is the address for other components to connect to |
| components.syncapi.listen_ext | int | `8073` | listen_ext is the port for external connections |
| components.syncapi.listen_int | int | `7773` | listen_int is the port for the internal api connection |
| components.syncapi.real_ip_header | string | `"X-Real-IP"` | This option controls which HTTP header to inspect to find the real remote IP address of the client. This is likely required if Dendrite is running behind a reverse proxy server. |
| components.userapi.connect | string | `"userapi:7781"` | Connect is the address for other components to connect to |
| components.userapi.listen_int | int | `7781` | listen_int is the port for the internal api connection |
| configuration.database.conn_max_lifetime | int | `-1` | Default database maximum lifetime |
| configuration.database.host | string | `""` | Default database host |
| configuration.database.max_idle_conns | int | `2` | Default database maximum idle connections |
| configuration.database.max_open_conns | int | `100` | Default database maximum open connections |
| configuration.database.password | string | `""` | Default database password |
| configuration.database.user | string | `""` | Default database user |
| configuration.disable_federation | bool | `false` | Disable federation. Dendrite will not be able to make any outbound HTTP requests to other servers and the federation API will not be exposed. |
| configuration.dns_cache.cache_lifetime | string | `"10m"` | Duration for how long DNS cache items should be considered valid ([see time.ParseDuration](https://pkg.go.dev/time#ParseDuration) for more) |
| configuration.dns_cache.cache_size | int | `256` | Maximum number of entries to hold in the DNS cache |
| configuration.dns_cache.enabled | bool | `false` | Whether or not the DNS cache is enabled. |
| configuration.jetstream.addresses | list | `[]` | List of NATS addresses to connect to. If empty, an in-process NATS server is used. |
| configuration.jetstream.in_memory | bool | `false` | Keep all storage in memory. This is mostly useful for unit tests. |
| configuration.jetstream.storage_path | string | `"./"` | Persistent directory to store JetStream streams in. (only relevant if not using external NATS) |
| configuration.jetstream.topic_prefix | string | `"Dendrite"` | The prefix to use for NATS topic names for this homeserver. Change this only if you are running more than one Dendrite homeserver on the same NATS deployment. |
| configuration.key_validity_period | string | `"168h0m0s"` |  |
| configuration.logging | list | `[{"level":"error","params":{"path":"/var/log/dendrite"},"type":"file"}]` | Default logging configuration |
| configuration.metrics.basic_auth.password | string | `"metrics"` | HTTP basic authentication password |
| configuration.metrics.basic_auth.user | string | `"metrics"` | HTTP basic authentication username |
| configuration.metrics.enabled | bool | `false` | Whether or not Prometheus metrics are enabled. |
| configuration.mscs | list | `[]` | Configuration for experimental MSC's. (Valid values are: msc2836 and msc2946) |
| configuration.outbound_proxy | object | `{"enabled":false,"host":"localhost","port":8080,"protocol":"http"}` | Outbound proxy settings for federation api |
| configuration.profiling.enabled | bool | `false` | Enable pprof |
| configuration.profiling.port | int | `65432` | pprof port, if enabled |
| configuration.rate_limiting | object | `{"cooloff_ms":500,"enabled":true,"threshold":5}` | Settings for rate-limited endpoints. Rate limiting will kick in after the threshold number of "slots" have been taken by requests from a specific host. Each "slot" will be released after the cooloff time in milliseconds. |
| configuration.servername | string | `""` | Servername for this Dendrite deployment |
| configuration.signing_key.create | bool | `true` | Create a new signing key, if not exists |
| configuration.signing_key.existingSecret | string | `""` | Use an existing secret |
| configuration.tracing | object | `{"enabled":false,"jaeger":{"baggage_restrictions":null,"disabled":false,"headers":null,"reporter":null,"rpc_metrics":false,"sampler":null,"serviceName":"","tags":[],"throttler":null}}` | Default traing configuration |
| configuration.trusted_third_party_id_servers | list | `["matrix.org","vector.im"]` | Lists of domains that the server will trust as identity servers to verify third party identifiers such as phone numbers and email addresses. |
| configuration.turn.turn_password | string | `""` | The TURN password |
| configuration.turn.turn_shared_secret | string | `""` |  |
| configuration.turn.turn_uris | list | `[]` |  |
| configuration.turn.turn_user_lifetime | string | `""` |  |
| configuration.turn.turn_username | string | `""` | The TURN username |
| configuration.version | int | `2` | Dendrite config version |
| configuration.well_known_server_name | string | `""` | The server name to delegate server-server communications to, with optional port e.g. localhost:443 |
| image.name | string | `"matrixdotorg/dendrite-polylith:v0.6.0"` | Docker repository/image to use |
| image.pullPolicy | string | `"IfNotPresent"` | Kubernetes pullPolicy |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` | Create an ingress for a monolith deployment |
| ingress.hosts | list | `[]` |  |
| ingress.tls | list | `[]` |  |
| nats.enabled | bool | `false` | Deploy NATS JetStream dependency |
| nats.nats.jetstream.enabled | bool | `true` | Enable NATS JetStream (required in polylith mode) |
| persistence.logs.capacity | string | `"10Gi"` |  |
| persistence.logs.existingClaim | string | `""` |  |
| persistence.media.capacity | string | `"10Gi"` |  |
| persistence.media.existingClaim | string | `""` |  |
| persistence.storageClass | string | `"local-path"` |  |
| polylith | bool | `true` | Whether or not to deploy a polylith |
| postgresql.enabled | bool | `false` | Deploy PostgreSQL dependency |
| postgresql.global.postgresql.existingSecret | string | `""` |  |
| postgresql.global.postgresql.postgresqlDatabase | string | `""` |  |
| postgresql.global.postgresql.postgresqlPassword | string | `""` |  |
| postgresql.global.postgresql.postgresqlUsername | string | `""` |  |
| postgresql.global.postgresql.replicationPassword | string | `""` |  |
| postgresql.global.postgresql.servicePort | string | `""` |  |
| postgresql.global.storageClass | string | `""` |  |
| postgresql.initdbScripts."create_db.sh" | string | `"#!/bin/sh\nfor db in userapi_accounts userapi_devices mediaapi syncapi roomserver keyserver federationapi appservice mscs; do\n    createdb -U dendrite -O dendrite dendrite_$db\ndone\n"` | Create databases when first creating a PostgreSQL Server |
| postgresql.persistence.enabled | bool | `false` |  |
| resources | object | `{"limits":{"cpu":"240m","memory":"256Mi"},"requests":{"cpu":"80m","memory":"64Mi"}}` | Default resource requests/limits This can be set individually for each component, see mediaapi |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)