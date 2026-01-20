# regional-time

A command-line utility for macOS that, given a latitude, longitude, and a number of seconds since the Unix epoch, prints the corresponding date and time for the location's timezone in the ISO 8601 format.

```
usage: regional-time <latitude> <longitude> <epoch_seconds>
example:
    % regional-time 45.37 -75.85 1768922712
    2026-01-20T10:25:12-05:00
```
