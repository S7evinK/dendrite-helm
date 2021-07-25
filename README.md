# Dendrite Helm Chart

Status: NOT PRODUCTION READY

## About

This is a first try for a Helm Chart for the [Matrix](https://matrix.org) Homeserver [Dendrite](https://github.com/matrix-org/dendrite)

This chart creates a polylith, where every component is in its own deployment and requires a Postgres server aswell as a Kafka server.

## Usage with appservices

Create a folder `appservices` and place your configurations in there.  The configurations will be read and placed in a secret `dendrite-appservices-conf`.

## Todo

- [x] Cleanup personal stuff (mainly mounts)
- [ ] ~~Allow SQLite (?)~~
- Add configs for
  - [x] ReCAPTCHA
  - [x] TURN
  - [x] Rate limiting
  - [x] Tracing
  - [x] Appservices
- [x] Generate matrix_key on installation
- [ ] Add dependencies
