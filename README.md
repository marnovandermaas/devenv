# Development environment

Some files for my own development environment, for example [nix][] flakes.

[nix]: https://zero-to-nix.com/start/install

## Nix: getting started

If you see the following error (`unshare: write failed /proc/self/uid_map: Operation not permitted`) you may need to disable apparmor:

```sh
sysctl -w kernel.apparmor_restrict_unprivileged_unconfined=0
sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
```

Then enter your shell like this:
```sh
nix develop .#opentitan
```
