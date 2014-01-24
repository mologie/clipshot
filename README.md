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

## Known issues
* Activator's screenshot action does not function correctly after installing ClipShot. A flash is displayed, but no menu appears. ClipShot's activator actions work as expected.
* Incompatibilities with CallBar? The description in the bug report was unclear. Apparently, taking a screenshot locks the phone regardless of which default action is choosen while a call it active.
* "Always copy to clipboard" only works while the default action is set to "Ask"

## License
This tweak is licensed under the GPLv3.
