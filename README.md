# swipl/redis-stamp

The stamps have a single `stamp` field whose value is the Redis Unix time in seconds. Read the stamp stream as follows, as an example.
```prolog
 ?- redis(default, xread(count, 1, streams, stamp, 0), A).
A = [[stamp, [['1665318168011-0', [stamp, 1665318168.00719]]]]].
```
It reads the first entry. Notice that the stream identifier closely matches the stamp value, albeit in milliseconds rather than seconds for the latter. The stream trims at around 60 entries by default. The first entry does not remain the first indefinitely. Automatic trimming removes the oldest entries periodically.

## Only One

There should be only one stamp generator on the same key otherwise the stream will generate multiple event entries for the same clock transition.
