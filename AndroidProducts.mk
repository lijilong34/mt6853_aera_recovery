#
# AERA Recovery device tree for mt6853
#
# 不用 $(LOCAL_DIR)：AOSP16 下该变量在 AndroidProducts.mk 被 include 时可能未设置，
# 会导致 PRODUCT_MAKEFILES 指向不存在的路径 -> "Don't have a product spec"
#

PRODUCT_MAKEFILES := \
    device/oppo/mt6853/twrp_mt6853.mk

COMMON_LUNCH_CHOICES := \
    twrp_mt6853-user \
    twrp_mt6853-userdebug \
    twrp_mt6853-eng
