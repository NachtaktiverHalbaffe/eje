FROM ghcr.io/instrumentisto/flutter:3

RUN apt-get update \
  && apt-get install --yes --no-install-recommends\ 
  curl unzip sed git bash xz-utils libglvnd0 ssh\ 
  xauth x11-xserver-utils libpulse0 libxcomposite1  sudo \
  cmake ninja-build clang build-essential pkg-config libgtk-3-dev liblzma-dev lcov\
  && rm -rf /var/lib/{apt,dpkg,cache,log}

ENV ANDROID_VERSION="33"
ENV ANDROID_ARCHITECTURE="x86_64"

RUN  yes "y" | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
  && yes "y" | sdkmanager "platforms;android-$ANDROID_VERSION" \
  && yes "y" | sdkmanager "platform-tools" \
  && yes "y" | sdkmanager "emulator" \
  && yes "y" | sdkmanager "system-images;android-$ANDROID_VERSION;google_apis_playstore;$ANDROID_ARCHITECTURE" 

RUN flutter config --enable-android \
                   --enable-linux-desktop \
                   --enable-web \
                   --enable-ios  \
        && flutter emulators --create \
        && flutter update-packages 

# Setup environment variables for running emulators etc
ENV FLUTTER_EMULATOR_NAME="flutter_emulator"
ENV FLUTTER_DEBUG_PORT="42000"

#
RUN echo 'alias launch-emulator="flutter emulators --launch flutter_emulator"' >>  /etc/bash.bashrc

