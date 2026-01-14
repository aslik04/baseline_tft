#!/bin/bash
echo "=== TFT Job Monitor ==="
echo ""
for i in 0 1 2; do
  if [ -f "joboutput_1225504_${i}.err" ]; then
    trials=$(grep -c "Trial.*finished" "joboutput_1225504_${i}.err")
    best=$(grep "Best is trial" "joboutput_1225504_${i}.err" | tail -1 | grep -o "value: [0-9.]*" | cut -d: -f2)
    echo "Job $i: $trials/1000 trials | Best: ${best:-N/A}"
  fi
done
