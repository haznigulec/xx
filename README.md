# piapiri_v2


## IOS Crashes
Window -> Organizer -> Crashes

## Protobuf Install
To use Protobuf(https://protobuf.dev) we need to install binary of Protobuf first, then we should activate `protoc_plugin`(https://pub.dev/packages/protoc_plugin)

* To install Protobuf, please visit the [link](https://protobuf.dev/downloads/) and follow instructions
* `protoc_plugin` is our code generator. To install, visit [pub page](https://pub.dev/packages/protoc_plugin) and follow instructions.

### Usage
Before starting to development, create a file named `gen` under `lib/core` and generate our `proto` files with the command below;
```
protoc --proto_path=lib/core/proto --dart_out=lib/core/gen lib/core/proto/Symbol/Symbol.proto lib/core/proto/DepthStats/DepthStats.proto lib/core/proto/Derivative/Derivative.proto lib/core/proto/Trade/Trade.proto lib/core/proto/News/news.proto lib/core/proto/DepthTable/DepthTable.proto lib/core/proto/Messenger/Messenger.proto lib/core/proto/Ranker/Ranker.proto lib/core/proto/Timestamp/Timestamp.proto lib/core/proto/ComputedValues/ComputedValues.proto lib/core/proto/Booklet/TopOfTheBook.proto lib/core/proto/RankedSymbols/RankedSymbols.proto
```

## Development
After merges, some developers could struggle to work on iOS side. To prevent and handle those errors you can use `prep_ios.sh`.

Before working with it you may need to give some permissions with:
```
chmod +x prep_ios.sh
```

You can use it like:
```
./prep_ios.sh
```

## AutoRoute
AutoRoute is our routing solution. To build project you need to create routes wit following command;
```
flutter packages pub run build_runner build
```

After that you can start development.

## Firebase CLI
To use firebase we need to active `firebase_cli` globally with given line:

```
dart pub global activate flutterfire_cli 1.0.1-dev.4
```

## Relese
To release app, we need to use `app_build.sh`. With the file, we can build package for both Android and iOS. Before using it you may need to give some permissions to the file with:

```
chmod +x app_build.sh
```

After giving permissions you need to specify entry point.
You can get help by executing `./app_build.sh --help`

Create AAB and IPA for the app

usage: ./app_build.sh --env string --target string

  --env string            env to which to deploy
                          default: prod
                          options: dev | qa | prod
  --target string         target operating system
                          default: both
                          options: ios | android

### Usage
#### Production

```
./app_build.sh lib/main_prod.dart
```

#### Test Flight

```
./app_build.sh qa
```