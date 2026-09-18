#!/bin/bash

mkdir -p \
    engine \
    connectors \
    drivers \
    capabilities \
    tests

touch engine/__init__.py
touch connectors/__init__.py
touch drivers/__init__.py
touch capabilities/__init__.py
touch tests/__init__.py

echo "Python packages initialised"
