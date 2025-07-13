#!/bin/bash

# cc_test Organization Setup Script
# Creates tmux session with hierarchical pane structure based on config.yml

CONFIG_FILE="/workspaces/cc_test/orgs/config.yml"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file not found at $CONFIG_FILE"
    exit 1
fi

# Read SESSION_NAME from YAML file
SESSION_NAME=$(yq eval '.organization.session_name' "$CONFIG_FILE")

# Count the number of roles
ROLES_COUNT=$(yq eval '.organization.roles | length' "$CONFIG_FILE")

echo "Session name: $SESSION_NAME"
echo "Number of roles: $ROLES_COUNT"

# Determine number of columns based on roles count
if [ "$ROLES_COUNT" -le 9 ]; then
    COLUMNS=3
elif [ "$ROLES_COUNT" -le 20 ]; then
    COLUMNS=4
else
    COLUMNS=5
fi

echo "Using $COLUMNS columns layout"

# Kill existing session if it exists
tmux kill-session -t "$SESSION_NAME" 2>/dev/null

# Create new tmux session
tmux new-session -d -s "$SESSION_NAME"

# Calculate layout
ROWS=$(( (ROLES_COUNT + COLUMNS - 1) / COLUMNS ))

# Create panes for each role
for ((i=1; i<ROLES_COUNT; i++)); do
    # Determine split direction
    if [ $((i % COLUMNS)) -eq 0 ] && [ $i -lt $((ROWS * COLUMNS - COLUMNS)) ]; then
        # Split horizontally at the end of each row (except last row)
        tmux split-window -t "$SESSION_NAME" -v
        tmux select-layout -t "$SESSION_NAME" tiled
    else
        # Split vertically within the row
        tmux split-window -t "$SESSION_NAME" -h
        tmux select-layout -t "$SESSION_NAME" tiled
    fi
done

# Apply tiled layout to arrange panes evenly
tmux select-layout -t "$SESSION_NAME" tiled

# Execute claude command in pane 0
tmux send-keys -t "$SESSION_NAME:0.0" "claude --dangerously-skip-permissions" C-m

echo "Tmux session '$SESSION_NAME' created with $ROLES_COUNT panes in $COLUMNS columns"
echo "Claude started in pane 0"

# Attach to the tmux session
tmux attach-session -t "$SESSION_NAME"
