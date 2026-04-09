#! /bin/sh

# Start CUPS
cupsd

# Add printer
lpadmin -p myPrinter -v $PRINTER_URI -m everywhere
cupsaccept myPrinter
cupsenable myPrinter
lpoptions -d myPrinter

# Build cron schedule from environment variables
# PRINT_INTERVAL: days between prints (default: 2)
# PRINT_TIME: time to print in HH:MM 24h format (default: 08:00)
INTERVAL=${PRINT_INTERVAL:-2}
TIME=${PRINT_TIME:-08:00}

HOUR=$(echo "$TIME" | cut -d: -f1)
MINUTE=$(echo "$TIME" | cut -d: -f2)

if [ "$INTERVAL" -eq 1 ]; then
  DAY_PART="* * *"
else
  DAY_PART="*/$INTERVAL * *"
fi

SCHEDULE="$MINUTE $HOUR $DAY_PART"

echo "$SCHEDULE root /app/autoPrint >> /var/log/cron.log 2>&1" > /etc/cron.d/schedule
chmod 0644 /etc/cron.d/schedule

echo "Cron schedule set: $SCHEDULE"

# Run Cron
/usr/sbin/cron -f
