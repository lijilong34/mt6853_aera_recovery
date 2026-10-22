#
# Copyright (C) 2025 The Android Open Source Project
# Copyright (C) 2024-2025 The OrangeFox Recovery Project
# SPDX-License-Identifier: Apache-2.0
#
# AERA/OFP device tree for OPPO/OnePlus mt6853 (oplus/ossi, PLQ110, Find X8)
# Kernel: Oplus MTK BSP android-12 @ 4.14.186 (mt6853_defconfig)
# Layout mirrors AERA-Recovery/android_device_oppo_lighthouse-AERA (aera-16.0)
# and i-am-wolfi/aera_recovery_marble.
#

DEVICE_PATH := device/oppo/mt6853

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Shipping API level (stock: A16 / API 36)
BOARD_SHIPPING_API_LEVEL := 36
PRODUCT_SHIPPING_API_LEVEL := 36
PRODUCT_TARGET_VNDK_VERSION := 36

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a76

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi

# Power
ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# Bootloader / platform
PRODUCT_PLATFORM := mt6853
TARGET_BOARD_PLATFORM := mt6853
TARGET_BOARD_PLATFORM_GPU := mtk-mali
QCOM_BOARD_PLATFORMS += mt6853
TARGET_BOOTLOADER_BOARD_NAME := $(PRODUCT_RELEASE_NAME)
TARGET_NO_BOOTLOADER := true

# Kernel / Ramdisk
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_PAGESIZE := 4096
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
BOARD_RAMDISK_USE_LZ4 := true
# Kernel: out/arch/arm64/boot/Image from
#   git clone -b android-12 https://github.com/lijilong34/android_kernel_oppo_mt6853
#   make O=out ARCH=arm64 mt6853_defconfig && make -j$(nproc) Image
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := \
    boot \
    init_boot \
    vendor_boot \
    dtbo \
    odm \
    product \
    system \
    system_ext \
    system_dlkm \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor \
    vendor_dlkm

# AB partitions for oplus
AB_OTA_PARTITIONS += \
    my_bigball \
    my_carrier \
    my_company \
    my_engineering \
    my_heytap \
    my_manifest \
    my_preload \
    my_product \
    my_region \
    my_stock

PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

# Partitions (stock dump values; verify with fastboot oplus flash-info)
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_SUPER_PARTITION_SIZE := 20132659200
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 20128563712
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system system_ext product vendor vendor_dlkm odm
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST += \
    my_bigball my_carrier my_company my_engineering my_heytap my_manifest my_preload my_product my_region my_stock
BOARD_PARTITION_LIST := $(call to-upper, $(BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := erofs))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4

# File systems
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_FLASH_BLOCK_SIZE := 262144

# Crypto
BOARD_USES_METADATA_PARTITION := true
BOARD_USES_QCOM_FBE_DECRYPTION := true
AERA_INCLUDE_CRYPTO := true
AERA_INCLUDE_CRYPTO_FBE := true
AERA_INCLUDE_FBE_METADATA_DECRYPT := true
AERA_USE_FSCRYPT_POLICY := 2

# Recovery
TARGET_OTA_ASSERT_DEVICE := mt6853
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USES_MKE2FS := true
AERA_INCLUDE_FASTBOOTD := true
AERA_SKIP_ADDITIONAL_FSTAB := true
AERA_UI_ADAPTIVE_RESOLUTION := true

# Tool
AERA_INCLUDE_LIBRESETPROP := true
AERA_INCLUDE_LPDUMP := true
AERA_INCLUDE_LPTOOLS := true
AERA_INCLUDE_REPACKTOOLS := true
AERA_INCLUDE_RESETPROP := true

# Debug
TARGET_USES_LOGD := true
AERA_INCLUDE_LOGCAT := true
TARGET_RECOVERY_DEVICE_MODULES += debuggerd
TARGET_RECOVERY_DEVICE_MODULES += strace
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/debuggerd
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/strace

# AERA display (Find X8 panel 1264x2800 LTPO)
AERA_SCREEN_H := 2800
AERA_STATUS_H := 141
AERA_HIDE_NOTCH := 1
AERA_STATUS_INDENT_LEFT := 90
AERA_STATUS_INDENT_RIGHT := 90
AERA_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
AERA_DEFAULT_BRIGHTNESS := 2047
AERA_FRAMERATE := 120
AERA_MAX_BRIGHTNESS := 4094
AERA_NO_SCREEN_BLANK := true
AERA_SCREEN_BLANK_ON_BOOT := true
AERA_THEME := portrait_hdpi
TARGET_USES_VULKAN := true

# AERA file system
RECOVERY_SDCARD_ON_DATA := true
AERA_ENABLE_FS_COMPRESSION := true
AERA_INCLUDE_FUSE_EXFAT := true
AERA_INCLUDE_FUSE_NTFS := true
AERA_INCLUDE_NTFS_3G := true
AERA_NO_EXFAT_FUSE := true

# Version
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
AERA_DEVICE_VERSION := Oppo_Find_X8

# Vibrator
AERA_SUPPORT_INPUT_AIDL_HAPTICS := true

# AERA options
AERA_ENABLE_ALL_PARTITION_TOOLS := 1
AERA_WORKAROUND_BACKUP_BUG := 1
AERA_USE_AIDL_BOOT_CONTROL := 1
AERA_FORCE_DATA_FORMAT_F2FS := 1
AERA_UNBIND_SDCARD_F2FS := 1
AERA_WIPE_METADATA_AFTER_DATAFORMAT := 1
AERA_DYNAMIC_FULL_SIZE := 20132659200
AERA_DISPLAY_FORMAT_FILESYSTEMS_DEBUG_INFO := 1
AERA_FORCE_PREBUILT_KERNEL := 1
AERA_NO_RELOAD_AFTER_DECRYPTION := 1
AERA_NO_TREBLE_COMPATIBILITY_CHECK := 1
AERA_AB_DEVICE_WITH_RECOVERY_PARTITION := 1
AERA_ENABLE_ABL_PRESERVATION := 1
AERA_ENABLE_FRP_WIPE := 1
AERA_USE_LZ4_COMPRESSION := 1
AERA_ENABLE_WLAN := 1

# Touch: Oplus MT6853 vendor touch modules (fill in from vendor_dlkm dump)
# MTK oplus BSP touch driver set; update AERA_LOAD_VENDOR_MODULES with the
# exact .ko names found under /vendor_dlkm/lib/modules after a stock dump.
AERA_LOAD_VENDOR_MODULES := "oplus_bsp_tp_focal_common.ko oplus_bsp_tp_ft3518.ko oplus_bsp_tp_ft3658u_spi.ko oplus_bsp_tp_ft3681.ko oplus_bsp_tp_ft3683g.ko oplus_bsp_tp_ft8057p.ko oplus_bsp_tp_goodix_comnon.ko oplus_bsp_tp_gt9916.ko oplus_bsp_tp_gt9966.ko oplus_bsp_tp_ilitek7807s.ko oplus_bsp_tp_ilitek_common.ko oplus_bsp_tp_notify.ko oplus_bsp_tp_novatek_common.ko oplus_bsp_tp_nt36528_noflash.ko oplus_bsp_tp_nt36532_noflash.ko oplus_bsp_tp_nt36672c_noflash.ko oplus_bsp_tp_syna_common.ko oplus_bsp_tp_tcm_S3908.ko oplus_bsp_tp_tcm_S3910.ko oplus_bsp_tp_td4377_noflash.ko"
AERA_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true
AERA_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
AERA_USE_TOOLBOX := true

# Extras
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop
