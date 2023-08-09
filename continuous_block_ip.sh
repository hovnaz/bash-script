#!/bin/bash

# # Set the threshold for failed login attempts
# THRESHOLD=3

# # Function to block an IP address
# block_ip() {
#     local ip_address="$1"
#     if ! iptables -C INPUT -s "$ip_address" -j DROP &> /dev/null; then
#         iptables -A INPUT -s "$ip_address" -j DROP
#         echo "Blocked IP address $ip_address"
#     fi
# }

# # Parse the auth.log file to find IP addresses with failed attempts exceeding the threshold
# grep "Failed password for" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | while read co>    if [ "$count" -ge "$THRESHOLD" ]; then
#         block_ip "$ip_address"
#     fi
# done

#_____________________________________

# #!/bin/bash

# # Set the threshold for failed login attempts
# THRESHOLD=3

# # Function to block an IP address
# block_ip() {
#     local ip_address="$1"
#     if ! iptables -C INPUT -s "$ip_address" -j DROP &> /dev/null; then
#         iptables -A INPUT -s "$ip_address" -j DROP
#         echo "Blocked IP address $ip_address"
#     fi
# }

# # Continuously monitor the auth.log file for incoming SSH failed login attempts
# tail -n0 -F /var/log/auth.log | while read line; do
#     if [[ "$line" == *"Failed password for"* ]]; then
#         ip_address=$(echo "$line" | awk '{print $(NF-3)}')
#         if [ -n "$ip_address" ]; then
#             failed_attempts=$(grep -c "Failed password for" /var/log/auth.log | grep "$ip_address")
#             if [ "$failed_attempts" -ge "$THRESHOLD" ]; then
#                 block_ip "$ip_address"
#             fi
#         fi
#     fi
# done



#__________________________




#!/bin/bash

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

# Continuously monitor the auth.log file for incoming SSH failed login attempts
tail -n0 -F /var/log/auth.log | while read -r line; do
    if [[ "$line" == *"Failed password for"* ]]; then
        ip_address=$(echo "$line" | awk '{print $(NF-3)}')
        if [ -n "$ip_address" ]; then
            failed_attempts=$(grep -c "$ip_address" /var/log/auth.log)
            if [ "$failed_attempts" -ge "$THRESHOLD" ]; then
                block_ip "$ip_address"
            fi
        fi
    fi
done
