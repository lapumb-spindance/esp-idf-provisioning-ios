#!/bin/bash

USAGE="
Description:
    Generate a swift file based on .proto definition

Output:
    File in the form of: proto_file_name.pb.swift

Usage:
    bash $0 <.proto file>
"

# get arguments
PROTO_FILE="$1"

# Make sure the required var is defined
if [ -z "$PROTO_FILE" ]; then
    echo "ERROR: You must specify a file"
    echo "$USAGE"
    exit 1
fi

# Exit if any vars undefined after this point
set -u

# Exit on first error
set -e

protoc --swift_out=. $PROTO_FILE

FILE_PREFIX=$(echo $PROTO_FILE | cut -f1 -d.)
echo "Success! Generated $FILE_PREFIX.pb.swift"