#!/bin/sh
# Moving files for rust wipe
now=$(date +"%Y-%m-%d")
# Path to Oxide data
OxideDir="/home/container/server/rust/oxide/data"
# Path to rust-server dir where storage.db is
server="/home/container/server/rust"

# Custom for oxide plugins
mkdir $OxideDir/old
mv $OxideDir/Kits_Data.json $OxideDir/old/$now.Kits_Data.json
mv $OxideDir/NTeleportationHome.json $OxideDir/old/$now.NTeleportationHome.json

# Blueprint etc
rm -r $server/storage/
rm -r $server/user/

# Map / Save files
rm -r $server/*.map
rm -r $server/*.sav

echo "Wipe success!"