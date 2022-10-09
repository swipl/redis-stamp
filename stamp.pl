:- autoload(library(redis), [redis/3]).
:- autoload(library(redis_streams), [xstream_set/3, xadd/4]).
:- use_module(library(settings), [setting/2, setting/4]).

:- setting(stamp_key, atom,
           env('STAMP_KEY', stamp), 'Key of stamp stream').
:- setting(stamp_max_len, nonneg,
           env('STAMP_MAX_LEN', 60), 'Maximum length of stamp stream').

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Converts the Redis time, a Unix time counter in microseconds, to a
stream of stamp event entries, one every second. The single field is the
stamp in seconds and fractions of seconds.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

:- initialization(main, main).

main :-
    setting(stamp_key, Key),
    setting(stamp_max_len, MaxLen),
    xstream_set(default, Key, maxlen(MaxLen)),
    repeat,
    redis(default, time, [Seconds, Microseconds]),
    Microseconds_ is Microseconds / 1e6,
    Seconds_ is Seconds + Microseconds_,
    xadd(default, Key, _, _{stamp:Seconds_}),
    Delay is 1 - Microseconds_,
    sleep(Delay),
    fail.
