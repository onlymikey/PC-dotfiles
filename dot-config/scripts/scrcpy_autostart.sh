#!/bin/bash

# Verifica si el dispositivo ADB está conectado
adb devices | grep -q "device$"

if [ $? -eq 0 ]; then
    # Si está conectado, ejecuta scrcpy
    scrcpy
else
    echo "No device detected"
fi
