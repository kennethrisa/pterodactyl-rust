#!/bin/bash
sleep 2

cd /home/container

# Check if wipe.sh file exist for wipe.
file="wipe.sh"
if [ -f "$file" ]
then
    echo "Wipe detected"
    chmod a+x $file
    /bin/bash /home/container/$file
    echo "Wipe finish."
else
    echo "Wipe not detected, skipping wipe"
fi

# Send msg to discord using webhook (example server starting)
if [ -f DISCORD_FLAG ] || [ "${DISCORD}" = 1 ]; then
    echo "Sending msg to discord"
    curl -X POST --data '{ "embeds": [{"title": "Rust-Monitor", "description": "Server starting"}] }' -H "Content-Type: application/json" ${DISCORDURL}
fi

# Update Rust Server
./steam/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update 258550 +quit

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

if [ -f OXIDE_FLAG ] || [ "${OXIDE}" = 1 ]; then
    echo "Updating OxideMod..."
    oxide=$(curl -s https://api.github.com/repos/OxideMod/Oxide.Rust/releases/latest | jq -r ".assets[] | select(.name | test(\"${spruce_type}\")) | .browser_download_url")
    curl -sSL $oxide > oxide.zip
    unzip -o -q oxide.zip
    rm oxide.zip
    echo "Done updating OxideMod!"
fi

# Fix for Rust not starting
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)

# Run the Server
node /wrapper.js "${MODIFIED_STARTUP}"
