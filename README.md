# ClickHouse DISTINCT memory spill experiment

A local test of ClickHouse 26.9.5.2 using `SELECT DISTINCT` over
100 million unique values. `FORMAT Null` processes the query without
printing its output.

| Run | Memory limit | Spill threshold | Result | Query-log time |
| --- | ---: | ---: | --- | ---: |
| A | 150 MB | Disabled | Memory limit exceeded | 0.061 s |
| B | 150 MB | 25 MB | Completed | 2.381 s |
| C | 100 MB | 25 MB | Memory limit exceeded during merge | 1.533 s |

Spilling allowed B to finish under the same memory limit that caused A
to fail. C shows that merging spilled data still requires memory.

Run `bash benchmark.sh` with the `distinct-lab` ClickHouse container
running. Results vary by machine and ClickHouse version.
