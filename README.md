ClipShot
========

This tweak replaces SpringBoard's screenshot feature on iOS 6 and later in order to provide the option to save screenshots to the clipboard.

## Compilation
```sh
git clone https://github.com/mologie/clipshot
cd clipshot
./bootstrap.sh
make
make package
```

## Testing
In order to create a debug build of ClipShot and install it on your device, run `./install-on-device.sh device-hostname`. OpenSSH is required. For your own sanity, please setup keyless authentication first.

## License
This tweak is licensed under the GPLv3.
