# Compile-time wifi configuration

Goal of the compile-time configuration is that the target is connected or can be connected to 
out of the box.

There are three possible configurations:
- Client mode (target is connected to a host network)
  - w/ static IP
  - using DCHP
- Access point mode (target provides a wifi network to connect to)

# Necessary configuration steps

- Adding wifi capabilities to the rootfs (in `local.conf`)
- Appending to the `systemd` configuration for general network adapter setup:
  - Supplying proper `network` unit files for `systemd` for all supported interfaces
  - Setting DHCP or static IP
- Appending to the `wpa-supplicant` configuration for wifi connections

# Problems that might occur

- [`rfkill list` indicates wifi is soft-blocked](https://askubuntu.com/questions/673950/i-have-to-issue-rfkill-unblock-wifi-at-every-boot)