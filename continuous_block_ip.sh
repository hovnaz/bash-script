  GNU nano 6.2                            continuous_block_ip.sh                                      #!/bin/bash

# Set the threshold for failed login attempts
THRESHOLD=3

# Function to block an IP address
block_ip() {
    local ip_address="$1"
    if ! iptables -C INPUT -s "$ip_address" -j DROP &> /dev/null; then
        iptables -A INPUT -s "$ip_address" -j DROP
        echo "Blocked IP address $ip_address"
    fi
}

# Parse the auth.log file to find IP addresses with failed attempts exceeding the threshold
grep "Failed password for" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | while read co>    if [ "$count" -ge "$THRESHOLD" ]; then
        block_ip "$ip_address"
    fi
done
