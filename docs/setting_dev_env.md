# Setting up the development environment

The following instructions outline how to set up your development environment for starting development on Lichess mobile.

If you get stuck during the installation process the most suitable place to seek help is the `#lichess-dev-onboarding` channel on Discord (https://discord.gg/lichess).

## Installing Flutter

This project uses Flutter.

1. Follow [the flutter install guide](https://docs.flutter.dev/get-started/install).
   This project is meant to run on iOS and Android, so you need to follow the "Platform setup" section of that guide to
   install the iOS and/or Android platform.

> [!WARNING]
> Installing on Linux using `snapd` might cause some [problems](https://github.com/lichess-org/mobile/issues/123) building stockfish.
> Installing flutter manually is a known workaround.

2. Ensure Flutter is correctly configured by running `flutter doctor`

Note that this application is not meant to be run on web platform.

### Flutter Version Management

If you want to use FVM to manage your Flutter versions effectively, please consult the [FVM (Flutter Version Management) guide](https://fvm.app/documentation/getting-started/installation) for comprehensive instructions on installing Flutter on your specific operating system.

This project is currently using FVM 3.x.

**Pro Tip:** Remember to prepend the 'flutter' prefix when using FVM commands, like this: `fvm flutter [command]`.

## Lila Server

By default, the app will target the [Lichess dev server](https://lichess.dev/),
so you can start developing without setting up a local server.

During development, you may need a local [lila](https://github.com/lichess-org/lila) (lichess server scala app)
instance to work on this project.

If you work with a local lila, you will also need to setup [lila-ws](https://github.com/lichess-org/lila-ws) (websocket server).

### lila-gitpod

The fastest and most straight-forward way to run your own lila is [lila-gitpod](https://github.com/lichess-org/lila-gitpod).

### lila-docker

If you have Docker installed on your system, you will probably prefer to use [lila-docker](https://github.com/lichess-org/lila-docker).

### Local lila server (manual installation)

Instructions to install both `lila` and `lila-ws` locally can be found in [the lila wiki](https://github.com/lichess-org/lila/wiki/Lichess-Development-Onboarding).

## Setting up a device

### Real device

#### Android

To use a real device you will need to [enable developer options](https://developer.android.com/studio/debug/dev-options) on it and have [adb](https://developer.android.com/tools/adb) installed on your computer.

Once that done, you can [connect your device](https://developer.android.com/studio/run/device) either with USB or with Wi-Fi.

##### Connect with USB

Enable USB debugging and connect your phone with USB.

Run `adb devices` to check that your device is connected.

##### Connect with Wi-Fi

On your Android phone:

1. Connect your phone to the same wifi network as your host machine
2. In Developer Options, toggle Wireless Debugging to ON
3. Tap "Wireless Debugging" to enter its menu
4. Select **Pair device with pairing code**

On your computer:

1. Pair your phone with `adb pair [phone_ip_address]:[pair_port] [pairing_code]`.
2. Connect your phone with `adb connect [phone_ip_address]:[connection_port]`.
   Your phone IP address and connection port should be written on the wireless debugging menu.
3. Check that your device is connected with `adb devices`

### Emulators

#### iOS

Simply follow the instructions in the flutter guide to install Xcode and the iOS
simulator.

#### Android

##### Troubleshooting

- If Chrome crashes, it is likely you need to disable Vulkan in emulator settings:

  ```bash
  $ emulator -avd <YourAVD> -feature -Vulkan
  ```

  You can read more about this issue [here](https://issuetracker.google.com/issues/277651135).

- If you cannot access internet you can try launching the emulator with a DNS address:

  ```bash
  $ emulator -avd <YourAVD> -dns-server 1.1.1.1
  ```

  If you are on Linux it seems that the emulator will try to read `/etc/resolv.conf` to find DNS servers.
  You might want to check that your `/etc/resolv.conf` is configured properly rather than using the emulator `dns-server` flag first.
  If you use systemd-resolved, the recommended mode of handling `/etc/resolv.conf` is to symlink `/etc/resolv.conf` to `/run/systemd/resolve/stub-resolv.conf`.

- If you experience high lags or freezes, check the memory settings and be sure to enable hardware acceleration (`-gpu host`).

  Also disabling the snapshot storage may help:

  ```bash
  $ emulator -avd <YourAVD> -no-snapshot-load -no-snapstorage -no-snapshot -no-snapshot-save
  ```

- If you use Wayland, the emulator will not work. You can try to use Xwayland instead. The issue is tracked [here](https://issuetracker.google.com/issues/378421876).

## Code generation

This project uses code generation to generate data classes with [freezed](https://pub.dev/packages/freezed) among other things.

We don't commit generated code to the repository, so you need to run it before anything else otherwise the project won't
compile:

```bash
flutter pub get
dart run build_runner build
```

While developing you can use the watch command:

```bash
dart run build_runner watch
```

## Static analysis

Flutter comes with an `analyze` command to run static analysis. While developing you can run:

```bash
flutter analyze --watch
```

It will run analysis continuously, watching the filesystem for changes. It is important to always check for analysis errors.

## Run

Use the `flutter run` command to run the app on an emulator or a real device. If you need to change the lichess host you can do it like so:

```bash
flutter run \
  --dart-define=LICHESS_HOST=lichess.org \
  --dart-define=LICHESS_WS_HOST=socket.lichess.org
```

> [!WARNING]
> Do not use any scheme (https:// or ws://) in url in host, since it's already handled by URI helper method

> [!NOTE]
> If you use the production server, note that you will not be able to log in.

### Android

#### When using lila-gitpod

To access the lila instance from your device, you will need to make the port 8080 public. You can do so by running this command in your Gitpod workspace:

```bash
./lila-docker public
```

Then you can run the application with:

```bash
flutter run \
  --dart-define=LICHESS_HOST=[lila_gitpod_host] \
  --dart-define=LICHESS_WS_HOST=[lila_gitpod_host]
```

To find the host of your lila Gitpod instance, use the command `gp url 8080`. Just be careful to not include the full url in the hosts variables, you need to remove the https:// from the url.

#### When using lila-docker

When using [lila-docker](https://github.com/lichess-org/lila-docker), the easiest solution is to use the adb reverse command:

```bash
adb reverse tcp:8080 tcp:8080
```

You can then run the app with the following hosts:

```bash
flutter run \
  --dart-define=LICHESS_HOST=localhost:8080 \
  --dart-define=LICHESS_WS_HOST=localhost:8080
```

Another option is to use the `./lila-docker hostname` command and select your computer's IP address.

You can then run the app with the following hosts:

```bash
flutter run \
  --dart-define=LICHESS_HOST=[your_computer_ip]:8080 \
  --dart-define=LICHESS_WS_HOST=[your_computer_ip]:8080
```

#### When using a manually installed lila server

If you are working with a local `lila` server, you need to map some ports from the remote device to the local lila server.
Once your device is available, you can do this by running the following command (you can check if your device is available with `adb devices`):

```bash
adb reverse tcp:9663 tcp:9663
adb reverse tcp:9664 tcp:9664
```

This will allow the app to communicate with the local server. 9663 is for `http`
and 9664 is for `websocket`.

To run the application with the local server, you can use the following command:

```bash
flutter run \
  --dart-define=LICHESS_HOST=localhost:9663 \
  --dart-define=LICHESS_WS_HOST=localhost:9664
```

> [!NOTE]
> The ports above are the default ones for lila, if you have changed them, you
will need to adjust the commands accordingly.

### Logging

```bash
dart devtools
```

Then run the app with the `flutter run` command above, and a link to the logging page will be printed in the console.
