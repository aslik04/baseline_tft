#!/bin/bash
clear
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║             TFT Hyperparameter Search Monitor                  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Job status
echo "┌─ JOB STATUS ─────────────────────────────────────────────────┐"
squeue -u $USER -o "  %.8i │ %.15j │ %.8T │ %.8M │ %R" 2>/dev/null | head -8 || echo "  No jobs running"
echo "└──────────────────────────────────────────────────────────────┘"
echo ""

# Trial progress
echo "┌─ TRIAL PROGRESS (1000 trials each) ─────────────────────────┐"
models=("Price Only" "Price+Prod" "Price+Stor" "Price+USD" "Price+Weath" "Price+All")
for i in {0..5}; do
  file="joboutput_1225504_${i}.err"
  if [ -f "$file" ]; then
    trials=$(grep -c "Trial.*finished" "$file" 2>/dev/null)
    best=$(grep "Best is trial" "$file" 2>/dev/null | tail -1 | grep -o "value: [0-9.]*" | cut -d: -f2 | xargs)
    [ -z "$best" ] && best="N/A"
    [ -z "$trials" ] && trials="0"
    
    printf "  Job %d %-12s │ %4d/1000 │ Best val: %-8s\n" "$i" "${models[$i]}" "$trials" "$best"
  fi
done
echo "└──────────────────────────────────────────────────────────────┘"
echo ""

# Latest activity
echo "┌─ LATEST ACTIVITY ────────────────────────────────────────────┐"
for i in {0..2}; do
  file="joboutput_1225504_${i}.err"
  if [ -f "$file" ]; then
    latest=$(grep "Trial.*finished" "$file" 2>/dev/null | tail -1 | sed 's/\[I 20.*\] //' | sed 's/ and parameters.*//' | cut -c1-58)
    if [ -n "$latest" ]; then
      printf "  Job %d: %s\n" "$i" "$latest"
    fi
  fi
done
echo "└──────────────────────────────────────────────────────────────┘"
echo ""
echo "Press Ctrl+C to stop monitoring | Refreshes every 15 seconds"
