#!/bin/sh
# More information here: https://discourse.ubuntu.com/t/ubuntu-24-04-lts-noble-numbat-release-notes/39890#p-99950-unprivileged-user-namespace-restrictions
sysctl -w kernel.apparmor_restrict_unprivileged_unconfined=0
sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
