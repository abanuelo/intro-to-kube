#!/bin/bash

# List of generic electronic products
products=("smartphone" "laptop" "tablet" "headphones" "smartwatch" "camera" "printer" "router" "keyboard" "mouse" "monitor" "external hard drive" "gaming console" "wireless earbuds" "e-reader" "fitness tracker" "virtual reality headset" "portable charger" "bluetooth speaker" "action camera" "digital camera" "drone" "computer processor" "graphics card" "motherboard" "RAM" "solid-state drive" "hard disk drive" "power supply unit" "computer case" "thermal paste" "printer ink" "wireless mouse" "wireless keyboard" "webcam" "microphone" "USB flash drive" "gaming mouse" "gaming keyboard" "gaming headset" "game controller" "laser printer" "inkjet printer" "smart doorbell" "smart thermostat" "smart bulb" "smart plug" "smart lock" "smart scale" "robot vacuum" "3D printer" "Bluetooth headphones" "wireless headphones" "surround sound system" "soundbar" "home theater projector" "TV wall mount" "HDMI cable" "ethernet cable" "universal remote" "USB hub" "external DVD drive" "portable SSD" "smart mirror" "video doorbell" "GPS device" "digital photo frame" "Wacom tablet" "barcode scanner" "POS system" "digital microscope" "graphing calculator" "scientific calculator" "LED sign" "RFID reader" "Arduino board" "Raspberry Pi" "GoPro camera" "voice recorder" "walkie-talkie" "microcontroller" "wireless presenter" "document camera" "e-ink display" "USB microphone" "stylus pen" "video switcher" "solar calculator" "handheld scanner" "barcode printer" "laser pointer" "power bank" "wireless charger" "USB-C dock" "HDMI splitter" "power strip" "cord organizer" "cable tester" "electronic scale" "circuit board" "soldering iron" "digital oscilloscope" "multimeter" "circuit simulator" "robot kit" "VR headset" "smart glasses" "Wearable fitness tracker" "smart ring" "wireless presenter" "robot arm" "dual monitor stand" "wireless barcode scanner" "microSD card" "3D printing pen" "VR treadmill" "voice amplifier" "RFID tag" "smart gloves" "smart belt" "USB microscope" "solar panel" "graphing tablet" "motion sensor" "colorimeter" "soldering station" "CNC machine" "thermal imaging camera" "drone charger" "LED matrix display" "wireless microphone" "GPS tracker" "SIM card reader" "barometric pressure sensor" "digital hygrometer" "signal generator" "signal analyzer" "signal oscilloscope" "robot vacuum cleaner" "robot lawn mower" "robotic arm" "robotic exoskeleton" "robotic prosthetic" "robotic toy" "robotic kit" "robotic software" "robotic controller" "robotic sensor")


while true; do
    # Generate random values
    random_product=${products[$RANDOM % ${#products[@]}]}  # Random electronic product
    random_user_id=$((1 + RANDOM % 1000))                # Random user ID between 1 and 1000
    current_utc_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")     # Current UTC time

    # Create and echo the JSON-like output
    output="{\"item\": \"$random_product\", \"user\": $random_user_id, \"date\": \"$current_utc_date\"}"
    echo "$output" >> /tmp/foo.log

    # Sleep for 3 seconds before the next iteration
    sleep 3
done