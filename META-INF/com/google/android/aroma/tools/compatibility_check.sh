#!/sbin/sh

configfile=/tmp/aroma/compatible.prop
device_supported=0

# Setup Busybox
cp /tmp/aroma/busybox /tmp/busybox
chmod 777 /tmp/busybox

append_to_file() {
    local content="$1"
    echo "$content" >>"$configfile"
}
is_substring() {
    local substring=$1
    local string=$2

    case "$string" in
    *"$substring"*) return 0 ;;
    *) return 1 ;;
    esac
}

rm -f $configfile
touch $configfile

bootloader=$(getprop ro.boot.bootloader)

# Space Checks
system_size=$(blockdev --getsize64 /dev/block/mapper/system)
vendor_size=$(blockdev --getsize64 /dev/block/mapper/vendor)
product_size=$(blockdev --getsize64 /dev/block/mapper/product)

system_size_mb=$(echo $system_size | cut -c1-7)
system_size_mb=$(($system_size_mb / 1024))
vendor_size_mb=$(($vendor_size / 1024 / 1024))
product_size_mb=$(($product_size / 1024 / 1024))

append_to_file "system_size=$system_size"
append_to_file "vendor_size=$vendor_size"
append_to_file "product_size=$product_size"

echo "<b>COMPUTING SPACE REQUIREMENTS :-</b>"
echo "    -> System : $system_size_mb MB"
echo "    -> Vendor : $vendor_size_mb MB"
echo "    -> Product : $product_size_mb MB"

if [ "$vendor_size" -ge 650000000 ]; then
    append_to_file "vendor_compatible=1"
else
    append_to_file "vendor_compatible=0"
    echo "    -> <#ff0000>Vendor is Insufficient</#>"
    exit 55
fi
if [ "$product_size" -ge 559715200 ]; then
    append_to_file "product_compatible=1"
else
    append_to_file "product_compatible=0"
    echo "    -> <#ff0000>Product is Insufficient</#>"
    exit 55
fi

if [ "$system_size" -ge 4820133120 ]; then
    append_to_file "auxy_to_system=1"
    echo "    -> <#00ff00>System is 4.5GB+</#>"
else
    append_to_file "auxy_to_system=0"
fi
# 400mb size 419430400
if [ "$product_size" -ge 1024000000 ]; then
    append_to_file "auxy_to_product=1"
    echo "    -> <#00ff00>Product is 1GB+</#>"
else
    append_to_file "auxy_to_product=0"
fi

echo " "
echo "<b>DETECTING DEVICE :-</b>"
# Device Checks
if [ -z "$bootloader" ]; then
    echo "Installer: Employing Alternative Detection Methods"
    bootloader=$(/tmp/busybox sed -n 's/.*androidboot.bootloader=\([^[:space:]]*\).*/\1/p' /proc/cmdline)
fi

device="M315"
device_alt="m31"
if is_substring "$device" "$bootloader"; then
    echo "    -> Bootloader  : $bootloader"
    echo "    -> <#00ff00>Detected as : Galaxy $device </#>"
    append_to_file "device_id=$device"
    append_to_file "device_id_alt=$device_alt"
    append_to_file "is_7904=0"
    device_supported="1"
    exit 1
fi

device="M215"
device_alt="m21"
if is_substring "$device" "$bootloader"; then
    echo "    -> Bootloader  : $bootloader"
    echo "    -> <#00ff00>Detected as : Galaxy $device </#>"
    append_to_file "device_id=$device"
    append_to_file "device_id_alt=$device_alt"
    device_supported="1"
    exit 1
fi

device="M317F"
device_alt="m31s"
if is_substring "$device" "$bootloader"; then
    echo "    -> Bootloader  : $bootloader"
    echo "    -> <#00ff00>Detected as : Galaxy $device </#>"
    append_to_file "device_id=$device"
    append_to_file "device_id_alt=$device_alt"
    device_supported="1"
    exit 1
fi
device="A515"
device_alt="a51"
if is_substring "$device" "$bootloader"; then
    echo "    -> Bootloader  : $bootloader"
    echo "    -> <#00ff00>Detected as : Galaxy $device </#>"
    append_to_file "device_id=$device"
    append_to_file "device_id_alt=$device_alt"
    device_supported="1"
    exit 1
fi

device="F415"
device_alt="f41"
if is_substring "$device" "$bootloader"; then
    echo "    -> Bootloader  : $bootloader"
    echo "    -> <#00ff00>Detected as : Galaxy $device </#>"
    append_to_file "device_id=$device"
    append_to_file "device_id_alt=$device_alt"
    device_supported="1"
    exit 1
fi

device="A505"
device_alt="a50"
if is_substring "$device" "$bootloader"; then
    echo "    -> Bootloader  : $bootloader"
    echo "    -> <#00ff00>Detected as : Galaxy $device </#>"
    append_to_file "device_id=$device"
    append_to_file "device_id_alt=$device_alt"
    device_supported="1"
    exit 1
fi

if [ "$device_supported" == "0" ]; then
    echo "    -> Bootloader  : $bootloader"
    echo "    -> <#ff0000>UNKNOWN DEVICE</#>"
    exit 55
fi
exit 1
