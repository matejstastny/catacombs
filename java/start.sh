#!/bin/sh

./gradlew installDist -q && ./app/build/install/app/bin/app
