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
_net_ok=0
for iface in eth0 eth1 ens3 ens4 enp0s3; do
    if ip link show "$iface" 2>/dev/null | grep -q "state"; then
        ip link set "$iface" up 2>/dev/null
        ip addr add 10.0.2.15/24 dev "$iface" 2>/dev/null
        ip route add default via 10.0.2.2 2>/dev/null
        echo "nameserver 8.8.8.8" > /etc/resolv.conf
        printf " Connected ($iface)\n"
        _net_ok=1
        break
    fi
done
[ "$_net_ok" = "0" ] && printf " Not available\n"

echo ""
echo "  Type 'help' to see the list of EunOS commands."
echo ""
