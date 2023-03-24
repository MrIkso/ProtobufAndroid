#!/usr/bin/env bash

if [[ -z "$ANDROID_NDK" ]]; then
  echo "Please specify the Android NDK environment variable \"NDK\"."
  exit 1
fi

cd $ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/bin
ln -s aarch64-linux-android27-clang++ aarch64-linux-android-clang++
ln -s aarch64-linux-android27-clang aarch64-linux-android-clang

mkdir $HOME/google
cd $HOME/google

git clone https://github.com/google/protobuf.git
cd protobuf
./autogen.sh

mkdir x86_build
cd x86_build
../configure --prefix=$HOME/google/x86_pb_install
make install -j16
cd ..

mkdir arm64_build
cd arm64_build

CC=aarch64-linux-android-clang \
CXX=aarch64-linux-android-clang++ \
CFLAGS="-fPIE -fPIC" \
LDFLAGS="-llog -lz -lc++_static" \
../configure --host=aarch64-linux-android \
--prefix=$HOME/google/arm64_pb_install \
--enable-cross-compile \
--with-protoc=$HOME/google/x86_pb_install/bin/protoc

make install -j16

pwd
cd ..