#!/usr/bin/env sh

cd ../
nimble release -d:noConfig -d:release &&
cd benchmarking &&
hyperfine ./maxfetch ../trayfetch --shell=none --warmup 1000
