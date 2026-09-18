#!/bin/bash

set -e

echo "==========================================="
echo " IoT Edge Platform Python Environment Setup"
echo "==========================================="

echo ""
echo "Updating packages..."
sudo apt update

echo ""
echo "Installing Python toolchain..."

sudo apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    git

echo ""
echo "Creating virtual environment..."

python3 -m venv .venv

source .venv/bin/activate

echo ""
echo "Installing Python packages..."

pip install --upgrade pip

pip install \
    fastapi \
    uvicorn \
    bleak \
    pydantic \
    jinja2 \
    aiofiles \
    pyyaml

pip freeze > requirements.txt

echo ""
echo "Creating BLE test script..."

cat > test_ble.py << 'EOF'
import asyncio
from bleak import BleakScanner


async def main():

    print("Scanning for BLE devices...")
    print()

    devices = await BleakScanner.discover(
        timeout=15
    )

    if not devices:
        print("No devices found")
        return

    for device in devices:
        print(device)


asyncio.run(main())
EOF

echo ""
echo "==========================================="
echo " Setup Complete"
echo "==========================================="
echo ""
echo "Activate environment:"
echo ""
echo "source .venv/bin/activate"
echo ""
echo "Run BLE scan:"
echo ""
echo "python test_ble.py"
echo ""
