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
    append_to_file "m31vendor=1"
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
	append_to_file "m31vendor=1"
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
	    append_to_file "m31vendor=1"
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
	append_to_file "a51vendor=1"
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
	append_to_file "m31vendor=1"
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
	append_to_file "a50vendor=1"
    device_supported="1"
    exit 1
fi

if [ "$device_supported" == "0" ]; then
    echo "    -> Bootloader  : $bootloader"
    echo "    -> <#ff0000>UNKNOWN DEVICE</#>"
    exit 55
fi
exit 1
