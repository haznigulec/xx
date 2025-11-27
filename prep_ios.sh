#!/bin/bash
echo "iOS preparation starting"

# Clean iOS build
rm -rf ios/Pods

# Clean symlinks
rm -rf ios/.symlinks

# Remove podfile.lock
rm -rf ios/Podfile.lock

# Clean Flutter
flutter clean

# Get all the dependencies
flutter pub get

# Get iOS dependencies
cd ios
pod repo update
pod install
cd ..

# Run the routes
flutter packages pub run build_runner build