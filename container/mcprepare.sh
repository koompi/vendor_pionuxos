#!/system/bin/sh

#
# Copyright KOOMPI Co., LTD.
# Copyright 2016 The PIONUX OS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# set -x # debug

# -----------------------------------------------------------------------------
# Important paths

PIONUX_SYSTEM_DIR="/system/pionux"
PIONUX_DATA_DIR="/data/pionux"

SRC_DIR="$PIONUX_SYSTEM_DIR/containers/default"
DST_DIR="$PIONUX_DATA_DIR/containers/default"
ROOTFS="$SRC_DIR/rootfs.tar.gz"

# -----------------------------------------------------------------------------
# Installation states

STATE_COMPLETE="COMPLETE"
STATE_INCOMPLETE="INCOMPLETE"

# a breadcrumb to indicate an installation is in progress
LOCK_FILE="${PIONUX_DATA_DIR}/.lock"

# -----------------------------------------------------------------------------
# Utilities

die () {
    echo "$@" >&2
    echo "$@" >> "$LOCK_FILE"
    exit 1
}

success () {
    echo "$@"
    exit 0
}

get_state () {
    if [ -f "$LOCK_FILE" ] ; then
        # A lingering lock file indicates that the previous installation failed
        # prematurely.
        state="$STATE_INCOMPLETE"
    elif [ -z "$(busybox ls -A "$PIONUX_DATA_DIR")" ] ; then
        # An empty $PIONUX_DATA_DIR indicates that the container has not been set
        # up, and it is very likely that this is the first boot of PIONUX if
        # there is no lock file present.
        # Note: simply checking if $PIONUX_DATA_DIR exists won't work since it is
        # created in init.pionux.rc during boot.
        state="$STATE_INCOMPLETE"
    else
        # If none of the error cases above are true, the installation must be
        # complete.
        state="$STATE_COMPLETE"
    fi
    echo "$state"
}

# -----------------------------------------------------------------------------
# main

case $(get_state) in
    $STATE_COMPLETE)
        success "Detected a complete installation - nothing to be done."
        ;;
    $STATE_INCOMPLETE)
        echo "Detected an incomplete installation - starting a fresh install..."
        ;;
    *)
        die "Unknown installation state - aborting!"
        ;;
esac

busybox touch "$LOCK_FILE"

echo "Copying pionux files to /data..."
if ! busybox cp -r "$PIONUX_SYSTEM_DIR/." "$PIONUX_DATA_DIR/" ; then
    die "Failed to copy pionux files!"
fi

# not needed since we read rootfs from /system
busybox rm "$DST_DIR/rootfs.tar.gz"

echo "Extracting $ROOTFS to $DST_DIR..."
if ! busybox tar xzf "$ROOTFS" -C "$DST_DIR" ; then
    die "Failed to extract rootfs!"
fi

busybox rm -f "$LOCK_FILE"

success "All tasks completed successfully."
