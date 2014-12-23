ip -f inet addr show | grep 'state UP' -A1 | grep -o -e '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+/[0-9]\+'
