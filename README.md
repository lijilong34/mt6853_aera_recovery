# AERA Recovery for mt6853 (OPPO PECM30 / ossi) — 移植

用 **AERA 官方源码**（`AERA-Recovery/android_manifest` 的 `aera-16.0` 分支）为 mt6853 构建 AERA Recovery。

## 用法

1. 仓库推到 GitHub
2. 仓库 → **Actions** → `Build AERA Recovery (mt6853)` → **Run workflow**
3. 等 90-150 分钟，下载：
   - `mt6853-kernel` — 内核（Image.gz）
   - `mt6853-aera-recovery` — AERA recovery.img

## 两个 job

### Job 1: 内核（ubuntu-20.04）
源码：https://github.com/lijilong34/android_kernel_oppo_mt6853 （android-12）

- 修 2 处源码 bug：`keyslot-manager.h:101`、`blk-crypto.h:35` 的非法 `inline` 声明（函数体在别的 .c 里）；`sensor_devinfo.c` weak 函数缺参数
- **gcc 8.4** 编译（4.14 内核兼容版本）
- 关摄像头/蓝牙/GPS/IKHEADERS，**保留 WiFi**
- `RELOCATABLE` / `RANDOMIZE_BASE` / `COMBO_WIFI` / `MODULE_PLTS` 保持 defconfig 原值 `=y`
- 产物 image_size ≈ 51.3MB（原机 51.6MB）

### Job 2: AERA Recovery（ubuntu-22.04）
- `repo init -u https://github.com/AERA-Recovery/android_manifest.git -b aera-16.0`
- `repo sync`（AOSP 16 + AERA 仓库）
- 注入本仓库设备树到 `device/oppo/mt6853`，内核放 `prebuilt/kernel`
- `lunch aera_mt6853-eng && mka recoveryimage`（**仅 AERA，无任何回退**）

## 设备树

| 文件 | 作用 |
|---|---|
| `BoardConfig.mk` | 分区表、内核参数、recovery 配置 |
| `device.mk` | 设备包内容 |
| `recovery.fstab` | 分区挂载（含 OPLUS my_* 分区） |
| `twrp_mt6853.mk` / `aera_mt6853.mk` | 产品定义（lunch 目标） |
| `recovery/root/init.recovery.*.rc` | recovery 启动脚本 |

## 推送

```bash
cd mt6853_aera_recovery
git remote add origin https://github.com/lijilong34/你的仓库名.git
git push -u origin main
```

## 注意

- 内核必须 gcc-8（gcc 9/11 报 always_inline，除非保留源码修复）
- AERA manifest 是 aera-16.0（AOSP 16），构建环境用 ubuntu-22.04 + JDK 11
- recovery 是 AOSP 16，内核是 4.14——recovery 是独立小系统，内核接口有限，可运行
- 产物是给 **MT6853** 的
