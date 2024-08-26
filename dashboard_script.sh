#!/bin/bash

cd &
sudo systemctl stop mosquitto &

echo "Starting the Mosquitto Client with web socket"
echo "-------------------------------------------------------------------------------------"
sleep 1
mosquitto -c /etc/mosquitto/mosquitto.conf &
MOSQUITTO_PID=$!  # Capture the PID of the Mosquitto process

# Start Node.js server

echo "Changing Directory..."
echo "Starting Node Server..."
echo "-------------------------------------------------------------------------------------"
sleep 1
cd $HOME/Sensor-dashboard/Health-monitor-dashboard 
node --no-warnings server.js &
NODE_PID=$!  # Capture the PID of the Node.js server process

# Start Python script
echo "Executing python Script..."
echo "-------------------------------------------------------------------------------------"
sleep 1
python3 sensor_run.py &
PYTHON_PID=$!  # Capture the PID of the Python script

# Open Chromium browser with your dashboard
echo "Opening browser..."
echo "-------------------------------------------------------------------------------------"
sleep 1
chromium-browser http://localhost:3000 --start &
CHROMIUM_PID=$!  # Capture the PID of the Chromium browser

# Wait for Chromium to close
wait $CHROMIUM_PID

# When Chromium closes, stop all other processes
echo "Chromium closed, stopping all other processes..."
kill $MOSQUITTO_PID $NODE_PID $PYTHON_PID

wait 1
echo "All processes have been stopped."
echo "-------------------------------------------------------------------------------------"
