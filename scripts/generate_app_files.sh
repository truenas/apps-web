#!/bin/bash

if [ "$1" == "send-pr" ] ; then
   SEND_PR="TRUE"
   GIT_CHANGES_PENDING="FALSE"
   timestamp=$(date +%s)
   BRANCH_NAME="apps-content-pr"
   BASE_BRANCH="main"

   # Checkout or create the branch
   git fetch origin
   git checkout ${BRANCH_NAME}
   if [ $? -ne 0 ] ; then
       echo "Creating ${BRANCH_NAME} branch"
       git checkout -b ${BRANCH_NAME}
       if [ $? -ne 0 ] ; then
           echo "Failed creating ${BRANCH_NAME} branch"
           exit 1
       fi
   fi

   # --- KEY CHANGE: Always reset branch to match main ---
   git fetch origin
   git reset --hard origin/${BASE_BRANCH}
   # ----------------------------------------------------
fi

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

which jq >/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
    echo "jq not found"
    exit 1
fi

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
      md_file_abs_path="$CATALOG_DIR/$subdir.md"
      md_file_rel_path="./content/catalog/${subdir}.md"
      if [[ ! -f "$md_file_abs_path" ]]; then
        # Generate the content for the .md file
        cat <<EOF > "$md_file_abs_path"
---
title: "$title"
description: "Description and resources for the TrueNAS $train application called $title."
train: "$train"
icon: "$icon"
---

{{< catalog-return-button >}}

{{< github-content 
    path="trains/$train/$subdir/app_versions.json"
    includeFile="/static/includes/apps/Apps-Understanding-Versions.md"
>}}

## Resources

{{< include file="/static/includes/apps/$include_file.md" >}}

$expand_include
EOF
        echo "Created $md_file_abs_path" >> "$LOG_FILE"
        echo "Created $md_file_abs_path"
        if [ -n "$SEND_PR" ] ; then
           GIT_CHANGES_PENDING="TRUE"
           echo "git add $md_file_abs_path"
           git add ${md_file_abs_path}
           if [ $? -ne 0 ] ; then
            echo "Failed adding ${md_file_abs_path} to git"
            exit 1
           fi
           echo "git commit $md_file_abs_path"
           git commit -m "Added ${md_file_rel_path}"
           if [ $? -ne 0 ] ; then
            echo "Failed committing ${md_file_abs_path} to git"
            exit 1
           fi
        fi
      else
        echo "$md_file_abs_path already exists. Skipping creation." >> "$LOG_FILE"
        echo "$md_file_abs_path already exists. Skipping creation."
      fi
    done
    echo "" >> "$LOG_FILE"
  else
    echo "All subdirectories in $train have matching .md files." >> "$LOG_FILE"
    echo "All subdirectories in $train have matching .md files."
    echo "" >> "$LOG_FILE"
  fi
}

# Function to detect removed apps and update removals tracking
detect_removed_apps() {
  local removals_file="$HUGO_ROOT/static/data/app-removals.yaml"
  local current_date=$(date +%Y-%m-%d)
  local removed_apps_found=false

  echo "" >> "$LOG_FILE"
  echo "Checking for removed apps..." >> "$LOG_FILE"
  echo "Checking for removed apps..."

  # Get list of all markdown files in catalog (excluding _index.md)
  local catalog_apps=($(find "$CATALOG_DIR" -type f -name "*.md" ! -name "_index.md" -exec basename {} .md \;))

  for app_name in "${catalog_apps[@]}"; do
    local app_exists=false
    local app_train=""
    local base_app_name="$app_name"
    local expected_train=""

    # Check if filename has a train suffix (e.g., minio_enterprise, syncthing_stable)
    if [[ "$app_name" =~ ^(.+)_(enterprise|stable|community)$ ]]; then
      base_app_name="${BASH_REMATCH[1]}"
      expected_train="${BASH_REMATCH[2]}"

      # For train-suffixed files, only check the specific train
      if [[ -d "$TRAINS_DIR/$expected_train/$base_app_name" ]]; then
        app_exists=true
        app_train="$expected_train"
      fi
    else
      # For non-suffixed files, check all trains
      for train in "${TRAINS[@]}"; do
        if [[ -d "$TRAINS_DIR/$train/$app_name" ]]; then
          app_exists=true
          app_train="$train"
          break
        fi
      done
    fi

    # If app doesn't exist in any train (or its specific train), it was removed
    if [[ "$app_exists" == false ]]; then
      # Check if already tracked in removals
      if grep -q "^${app_name}:" "$removals_file" 2>/dev/null; then
        echo "  ✓ ${app_name} already tracked as removed" >> "$LOG_FILE"
      else
        echo "  ! DETECTED REMOVAL: ${app_name}" >> "$LOG_FILE"
        echo "  ! DETECTED REMOVAL: ${app_name}"
        removed_apps_found=true

        # Extract metadata from the markdown file's frontmatter
        local md_file="$CATALOG_DIR/$app_name.md"
        local title=""
        local train=""
        local icon=""
        local description=""

        if [[ -f "$md_file" ]]; then
          # Extract frontmatter fields using awk
          title=$(awk '/^title:/ {gsub(/^title: "/, ""); gsub(/"$/, ""); print; exit}' "$md_file")
          train=$(awk '/^train:/ {gsub(/^train: "/, ""); gsub(/"$/, ""); print; exit}' "$md_file")
          icon=$(awk '/^icon:/ {gsub(/^icon: "/, ""); gsub(/"$/, ""); print; exit}' "$md_file")
          description=$(awk '/^description:/ {gsub(/^description: "/, ""); gsub(/"$/, ""); print; exit}' "$md_file")
        fi

        # If we couldn't extract from frontmatter, use defaults
        title=${title:-$app_name}
        train=${train:-unknown}
        description=${description:-No description available}
        icon=${icon:-}

        # Sanitize values - remove any stray quotes to prevent YAML corruption
        title=$(echo "$title" | sed 's/"//g')
        train=$(echo "$train" | sed 's/"//g')
        icon=$(echo "$icon" | sed 's/"//g')
        description=$(echo "$description" | sed 's/"//g')

        # Append to removals.yaml
        cat >> "$removals_file" <<EOF

$app_name:
  train: $train
  title: "$title"
  removal_detected_date: "$current_date"
  last_known_metadata:
    icon: "$icon"
    description: "$description"
    reason: "Removed from catalog"
EOF

        echo "    Added ${app_name} to removals tracking" >> "$LOG_FILE"

        # If in PR mode, stage the changes
        if [ -n "$SEND_PR" ]; then
          GIT_CHANGES_PENDING="TRUE"
        fi
      fi
    fi
  done

  if [[ "$removed_apps_found" == true ]]; then
    echo "" >> "$LOG_FILE"
    echo "Updated removals tracking file: $removals_file" >> "$LOG_FILE"
    echo "Updated removals tracking file"
  else
    echo "No new removed apps detected" >> "$LOG_FILE"
    echo "No new removed apps detected"
  fi
}

# Iterate through each train and check for unmatched subdirectories
for train in "${TRAINS[@]}"; do
  check_unmatched_subdirs "$train"
done

# Function to detect and consolidate deprecation files
detect_and_copy_deprecations() {
  local deprecations_file="$HUGO_ROOT/static/data/app-deprecations.yaml"
  local temp_file="$HUGO_ROOT/static/data/app-deprecations.yaml.tmp"
  local current_date=$(date +%Y-%m-%d)

  echo "" >> "$LOG_FILE"
  echo "Processing app deprecations..." >> "$LOG_FILE"
  echo "Processing app deprecations..."

  # Start fresh file with header
  cat > "$temp_file" <<'EOF'
# App Deprecations Tracking
#
# This file tracks apps with active deprecations from the TrueNAS Apps catalog.
# It consolidates all deprecations.yaml files from individual apps.
# Generated automatically by generate_app_files.sh during site builds.
#
# Format:
#   app-slug:
#     train: community|stable|enterprise
#     title: "App Display Name"
#     deprecations:
#       - scope: partial|full
#         deprecated_date: "YYYY-MM-DD"
#         removal_date: "YYYY-MM-DD"
#         reason: "Description of why deprecated"
#         partial_details:      # Only for scope: partial
#           feature: "Feature name"
#           description: "Detailed description"
#           steps:
#             - "Migration step 1"
#             - "Migration step 2"
#
# Note: When an app is removed, its deprecation history is moved to app-removals.yaml

EOF

  local apps_with_deprecations=0

  # Iterate through all trains and apps
  for train in "${TRAINS[@]}"; do
    local train_dir="$TRAINS_DIR/$train"

    if [[ ! -d "$train_dir" ]]; then
      continue
    fi

    # Get all subdirectories (apps) in the train
    for app_dir in "$train_dir"/*; do
      if [[ ! -d "$app_dir" ]]; then
        continue
      fi

      local app_name=$(basename "$app_dir")
      local deprecations_yaml="$app_dir/deprecations.yaml"

      # Check if deprecations.yaml exists
      if [[ -f "$deprecations_yaml" ]]; then
        echo "  Found deprecations for: ${app_name} (${train})" >> "$LOG_FILE"
        echo "  Found deprecations for: ${app_name} (${train})"

        # Extract app title from app_versions.json
        local json_file="$app_dir/app_versions.json"
        local title=""

        if [[ -f "$json_file" ]]; then
          title=$(jq -r '.[].app_metadata.title' "$json_file" 2>/dev/null | head -n 1)
        fi
        title=${title:-$app_name}

        # Add app entry to consolidated file
        cat >> "$temp_file" <<EOF

$app_name:
  train: $train
  title: "$title"
  deprecations:
EOF

        # Parse and add deprecation entries with proper indentation
        # We need to indent each line appropriately for the consolidated structure
        while IFS= read -r line; do
          # Skip empty lines and comments
          if [[ -z "$line" ]] || [[ "$line" =~ ^[[:space:]]*# ]]; then
            continue
          fi

          # Detect list item marker at the start (new deprecation entry)
          if [[ "$line" =~ ^-[[:space:]] ]]; then
            # Start of new deprecation entry - indent with 4 spaces
            echo "    $line" >> "$temp_file"
          # Detect keys at any indentation level
          elif [[ "$line" =~ ^[[:space:]]+ ]]; then
            # Count leading spaces to determine nesting level
            leading_spaces="${line%%[![:space:]]*}"
            spaces_count=${#leading_spaces}

            # Base indentation is 4 spaces (under deprecations:)
            # Add the original indentation plus 4
            new_indent="    $line"
            echo "$new_indent" >> "$temp_file"
          fi
        done < "$deprecations_yaml"

        apps_with_deprecations=$((apps_with_deprecations + 1))
      fi
    done
  done

  # Replace old file with new one
  mv "$temp_file" "$deprecations_file"

  echo "" >> "$LOG_FILE"
  echo "Processed ${apps_with_deprecations} apps with deprecations" >> "$LOG_FILE"
  echo "Processed ${apps_with_deprecations} apps with deprecations"
  echo "Updated deprecations file: $deprecations_file" >> "$LOG_FILE"

  # If in PR mode, stage the changes
  if [ -n "$SEND_PR" ] && [ -f "$deprecations_file" ]; then
    GIT_CHANGES_PENDING="TRUE"
  fi
}

# Check for removed apps
detect_removed_apps

# Process deprecations
detect_and_copy_deprecations

if [ -n "$SEND_PR" ] ; then
   if [ "${GIT_CHANGES_PENDING}" == "FALSE" ] ; then
       echo "No pending git changes to push, exiting..."
       exit 0
   fi

   # Add tracking files to git if they were modified
   if [ -f "$HUGO_ROOT/static/data/app-removals.yaml" ]; then
       git add "$HUGO_ROOT/static/data/app-removals.yaml"
       if [ $? -eq 0 ]; then
           echo "Staged app-removals.yaml for commit"
       fi
   fi

   # Add deprecations file
   if [ -f "$HUGO_ROOT/static/data/app-deprecations.yaml" ]; then
       git add "$HUGO_ROOT/static/data/app-deprecations.yaml"
       if [ $? -eq 0 ]; then
           echo "Staged app-deprecations.yaml for commit"
       fi
   fi

   # Commit tracking file changes if any
   if ! git diff --cached --quiet; then
       git commit -m "Update app removals tracking"
       if [ $? -ne 0 ]; then
           echo "Failed to commit tracking file changes"
           exit 1
       fi
   fi

   PR_TYPE="Bot"
   PR_TITLE="Auto-Generated New Apps Pages"
   PR_DESCRIPTION="Auto-generated list of new Apps Content Pages"

   # Format PR title
   FINAL_PR_TITLE="$PR_TYPE: $PR_TITLE"

   # Predefined Reviewers (Modify with actual GitHub usernames)
   PREDEFINED_REVIEWERS=("truenas/docs-team")

   # Convert array to comma-separated string
   REVIEWERS_LIST=$(IFS=, ; echo "${PREDEFINED_REVIEWERS[*]}")

   # Push the current branch (force)
   git push --force origin "$BRANCH_NAME"
   if [ $? -ne 0 ]; then
       echo "❌ Failed to push branch to remote."
       exit 1
   fi

   # Create the Pull Request using GitHub CLI with assigned reviewers
   gh pr create --base "$BASE_BRANCH" --head "$BRANCH_NAME" --title "$FINAL_PR_TITLE" --body "$PR_DESCRIPTION" --reviewer "$REVIEWERS_LIST"
   # Confirm the PR was created
   if [ $? -eq 0 ]; then
       echo "✅ Pull request successfully created and assigned to reviewers: $REVIEWERS_LIST"
   else
       echo "❌ Failed to create pull request."
   fi
fi

# Notify the user where the log file is located
echo "Review log has been generated at: $LOG_FILE"