#!/usr/bin/env bash

# This script tests the Mako notification-daemon configuration by sending
# notifications with different urgency levels and styles.

# A 3-second pause between notifications to allow for observation.
PAUSE=3

echo "--- Testing Low Urgency Notification ---"
notify-send -u low "Low Urgency" "This should have a blue-green border and a short timeout (5s)."
sleep $PAUSE

echo "--- Testing Normal Urgency Notification ---"
notify-send -u normal "Normal Urgency" "This is the default. It should have a white-ish border and a 10s timeout."
sleep $PAUSE

echo "--- Testing Actionable Notification ---"
# We add actions with the -a flag. This will trigger the [actionable] style rule.
# The format is -a "ID:Label".
notify-send \
  -u normal \
  -a "open:Open Link" \
  -a "reply:Reply" \
  "Actionable Notification" \
  "This should have a distinct blue border because it has buttons."
sleep $PAUSE

echo "--- Testing Critical Urgency Notification ---"
# This one should look different and persist on screen.
notify-send -u critical "CRITICAL URGENCY" "This should have a bold red border, bold font, and *not* time out. You will need to dismiss it manually."

echo "--- Test complete! ---"
