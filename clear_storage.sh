#!/bin/bash
# Clear GetStorage data
rm -rf .dart_tool/
rm -rf build/
flutter clean
echo "Storage cleared! Silakan flutter run lagi."
