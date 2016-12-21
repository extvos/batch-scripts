#!/bin/bash
/sbin/lvs -a | grep -E '\[cache\]'| head -n 1 | awk '{ print $5 }'
/sbin/lvs -o cache_read_hits,cache_read_misses,cache_write_hits,cache_write_misses | grep -E '[0-9]+' | xargs -n 1 echo
