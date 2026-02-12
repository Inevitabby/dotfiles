#!/usr/bin/env bash
# Small script that runs Baloo indexing for 30 minutes every 4 hours

# Grace period (on login)
balooctl6 suspend
sleep 5m

# Index loop
while true; do
	balooctl6 resume
	balooctl6 check
	sleep 30m
	balooctl6 suspend
	sleep 4h
done
