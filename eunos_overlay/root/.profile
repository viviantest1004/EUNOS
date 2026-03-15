#!/bin/sh
# EunOS root profile

# Load profile.d
for f in /etc/profile.d/*.sh; do
    [ -r "$f" ] && . "$f"
done

# Display MOTD
if [ -f /etc/motd ]; then
    cat /etc/motd
fi

# Simple system info
echo "  Date: $(date '+%Y-%m-%d %H:%M:%S')"
MEM_TOTAL=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}')
MEM_FREE=$(grep MemFree /proc/meminfo 2>/dev/null | awk '{print $2}')
if [ -n "$MEM_TOTAL" ]; then
    MEM_USED=$((MEM_TOTAL - MEM_FREE))
    MEM_PCT=$((MEM_USED * 100 / MEM_TOTAL))
    echo "  Memory: ${MEM_PCT}% in use"
fi
echo ""

# Auto internet connect
printf "  Connecting to network..."
for iface in eth0 eth1 ens3 ens4 enp0s3; do
    if ip link show "$iface" 2>/dev/null | grep -q "state"; then
        ip link set "$iface" up 2>/dev/null
        if udhcpc -i "$iface" -q -n -t 3 2>/dev/null; then
            IP=$(ip addr show "$iface" 2>/dev/null | grep "inet " | awk '{print $2}')
            printf " Connected ($iface $IP)\n"
            break
        fi
    fi
done 2>/dev/null || printf " Not available\n"

echo ""
echo "  Type 'help' to see the list of EunOS commands."
echo ""
