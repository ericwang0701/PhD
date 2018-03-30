#!/usr/bin/env bash
cd SalientPosesReference && python3 -m pytest && cd ..
cd SalientPosesPerformance && ./run-tests.sh && cd ..

