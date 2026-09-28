#!/usr/bin/env bash
set -u

run_test() {
  local label="$1"
  local memory="$2"
  local spill="$3"
  local ratio="$4"

  echo "Running $label..."
  docker exec distinct-lab clickhouse-client --time --query "
    SELECT DISTINCT number
    FROM numbers_mt(100000000)
    FORMAT Null
    SETTINGS
      max_memory_usage = $memory,
      max_bytes_before_external_distinct = $spill,
      max_bytes_ratio_before_external_distinct = $ratio
  " 2>&1 | tee "run-$label.txt"
}

run_test a 150000000 0 0
run_test b 150000000 25000000 0
run_test c 100000000 25000000 0
