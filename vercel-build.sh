#!/bin/bash

set -e

FLUTTER_VERSION="3.44.9"

echo "Instalando Flutter $FLUTTER_VERSION..."

git clone --depth 1 --branch "$FLUTTER_VERSION" \
  https://github.com/flutter/flutter.git "$HOME/flutter"

export PATH="$HOME/flutter/bin:$PATH"

echo "Flutter version:"
flutter --version

echo "Habilitando Flutter Web..."
flutter config --enable-web

echo "Obteniendo dependencias..."
flutter pub get

echo "Construyendo Flutter Web..."
flutter build web --release

echo "Build terminado."
