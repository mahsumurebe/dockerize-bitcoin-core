#!/bin/bash
LOG_FILE="/data/logs/notification.log"
LOG_DIR=$(dirname "$LOG_FILE")
RESULT=$(curl -k -X POST "http://${NOTIFIER_APP_HOST}:${NOTIFIER_APP_PORT}/processTransaction" -H "Content-Type: application/json" -d "{\"txId\":\"$1\"}")

if [ -z "$RESULT" ] || test -z "$RESULT"; then
        RESULT="{\"status\":\"error\",\"message\":\"No transaction was found for us.\",\"error\":{}}"
fi

if [ ! -d "$LOG_DIR" ]; then
  mkdir -p "$LOG_DIR"
fi

if [ ! -f "$LOG_FILE" ]; then
  echo "|************DATE*************|******************************TXID******************************|*******************RESULT******************|" > LOG_FILE;
fi

STATUS=$(echo "$RESULT"|jq .status)
if [ "$STATUS" == "error" ]; then
  RESULT=$("$RESULT"|jq .message)
fi

echo "|$(date)|$1|$RESULT" >> $LOG_FILE
