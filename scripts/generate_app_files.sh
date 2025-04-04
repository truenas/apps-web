#!/bin/bash

# Determine the script's root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HUGO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Paths to the directories
TRAINS_DIR="$HUGO_ROOT/Apps_Temp/trains"
CATALOG_DIR="$HUGO_ROOT/content/catalog"
LOG_FILE="$SCRIPT_DIR/review_log.txt"

# Train directories
TRAINS=("community" "enterprise" "stable")

# Clear or create the log file
echo "Review Log - $(date)" > "$LOG_FILE"
echo "======================" >> "$LOG_FILE"

# Function to check for unmatched subdirectories and create .md files
check_unmatched_subdirs() {
  local train="$1"
  local train_dir="$TRAINS_DIR/$train"
  local unmatched=()

  # Ensure the train directory exists
  if [[ ! -d "$train_dir" ]]; then
    echo "Train directory $train_dir does not exist. Skipping..." >> "$LOG_FILE"
    return
  fi

  # Get the list of subdirectory names in the train directory
  subdirs=($(find "$train_dir" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;))

  # Get the list of .md file names in the catalog directory (excluding _index.md)
  md_files=($(find "$CATALOG_DIR" -type f -name "*.md" ! -name "_index.md" -exec basename {} .md \;))

  # Check each subdirectory against the .md files
  for subdir in "${subdirs[@]}"; do
    match_found=false

    for md_file in "${md_files[@]}"; do
      # Check if the .md file matches the subdirectory name and train name
      if [[ "$md_file" == "$subdir" || "$md_file" == *"_${train}" ]]; then
        match_found=true
        break
      fi
    done

    # If no match is found, add the subdirectory to the unmatched list
    if [[ "$match_found" == false ]]; then
      unmatched+=("$subdir")
    fi
  done

  # Write unmatched subdirectories to the log file and create .md files
  if [[ ${#unmatched[@]} -gt 0 ]]; then
    echo "Unmatched subdirectories in $train:" >> "$LOG_FILE"
    for subdir in "${unmatched[@]}"; do
      echo "- $subdir" >> "$LOG_FILE"

      # Path to the app_versions.json file
      json_file="$train_dir/$subdir/app_versions.json"

      # Check if the JSON file exists
      if [[ ! -f "$json_file" ]]; then
        echo "  - Missing app_versions.json for $subdir. Skipping..." >> "$LOG_FILE"
        continue
      fi

      # Extract values from the JSON file
      title=$(jq -r '.[].app_metadata.title' "$json_file" | head -n 1)
      description=$(jq -r '.[].app_metadata.description' "$json_file" | head -n 1)
      icon=$(jq -r '.[].app_metadata.icon' "$json_file" | head -n 1)

      # Determine the include file based on the train
      if [[ "$train" == "community" ]]; then
        include_file="CommunityApp"
        expand_include="{{< include file=\"/static/includes/apps/CommunityPleaseExpand.md\" >}}"
      elif [[ "$train" == "stable" ]]; then
        include_file="StableApp"
        expand_include="{{< include file=\"/static/includes/apps/CommunityPleaseExpand.md\" >}}"
      else
        include_file="EnterpriseApps"
        expand_include=""
      fi

      # Create the .md file in the catalog directory
      md_file_path="$CATALOG_DIR/$subdir.md"
      if [[ ! -f "$md_file_path" ]]; then
        # Generate the content for the .md file
        cat <<EOF > "$md_file_path"
---
title: "$title"
description: "Description and resources for the TrueNAS $train application called $title."
train: "$train"
icon: "$icon"
---

{{< github-content 
    path="trains/$train/$subdir/app_versions.json"
	includeFile="/static/includes/apps/Apps-Understanding-Versions.md"
>}}

## Resources

{{< include file="/static/includes/apps/$include_file.md" >}}

$expand_include
EOF
        echo "Created $md_file_path" >> "$LOG_FILE"
      else
        echo "$md_file_path already exists. Skipping creation." >> "$LOG_FILE"
      fi
    done
    echo "" >> "$LOG_FILE"
  else
    echo "All subdirectories in $train have matching .md files." >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
  fi
}

# Iterate through each train and check for unmatched subdirectories
for train in "${TRAINS[@]}"; do
  check_unmatched_subdirs "$train"
done

# Notify the user where the log file is located
echo "Review log has been generated at: $LOG_FILE"