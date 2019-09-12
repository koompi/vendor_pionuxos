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

# early build definitions for pionux
include $(LOCAL_PATH)/pionux_build.mk

# init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.pionux.rc:root/init.pionux.rc

# container
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilts/desktop-rootfs.tar.gz:system/pionux/containers/default/rootfs.tar.gz \
    $(LOCAL_PATH)/container/default/config:system/pionux/containers/default/config \
    $(LOCAL_PATH)/container/default/fstab:system/pionux/containers/default/fstab \
    $(LOCAL_PATH)/container/mcprepare.sh:system/bin/mcprepare

# LXC
PRODUCT_PACKAGES += \
	liblxc \
	lxc-start \
	lxc-stop \
	lxc-attach \
	lxc-rootfs-mnt-README

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/container/lxc.conf:system/pionux/lxc/etc/lxc/lxc.conf

# PerspectiveService
PRODUCT_PACKAGES += \
    libperspective \
    perspectived

# mflinger
PRODUCT_PACKAGES += \
    libpionux \
    mflinger

PRODUCT_PACKAGES += \
	mlogwrapper \
	busybox

# Replace LineageOS packages
PRODUCT_PACKAGES += \
	LineagePackageRemovals \
	Launcher3 \
	Provision

PRODUCT_PACKAGE_OVERLAYS += \
	vendor/pionuxos/overlay

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.pionux.version=$(PIONUX_BUILD_VERSION)

# fix usb debugging auth on user builds
ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.adb.secure=1
endif

# -----------------------------------------------------------------------------
# Lineage OS hooks

WITHOUT_CHECK_API := true

TARGET_BOOTANIMATION := $(LOCAL_PATH)/prebuilts/mbootanim.zip
