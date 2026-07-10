#!/bin/bash
# PostToolUse hook — logs Terraform validation and formatting commands

INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$CMD" | grep -qE "terraform fmt|terraform validate"; then
  echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Terraform command executed: $CMD" >> /c/Users/USER/Documents/DMI3/Ultimate-Agentic-DevOps-with-Claude-Code/.claude/deploy.log
fi
