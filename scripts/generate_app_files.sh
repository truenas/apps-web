#!/bin/bash

if [ "$1" == "send-pr" ] ; then
   SEND_PR="TRUE"
   GIT_CHANGES_PENDING="FALSE"
   timestamp=$(date +%s)
   BRANCH_NAME="apps-content-pr"
   BASE_BRANCH="main"
   git checkout ${BRANCH_NAME}
   if [ $? -ne 0 ] ; then
	echo "Creating ${BRANCH_NAME} branch"
        git checkout -b ${BRANCH_NAME}
        if [ $? -ne 0 ] ; then
	  echo "Failed creating ${BRANCH_NAME} branch"
	  exit 1
	fi
   else
	git pull origin ${BASE_BRANCH}
        if [ $? -ne 0 ] ; then
	  echo "Failed updating ${BRANCH_NAME} branch"
	  exit 1
	fi
   fi
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

# Iterate through each train and check for unmatched subdirectories
for train in "${TRAINS[@]}"; do
  check_unmatched_subdirs "$train"
done

if [ -n "$SEND_PR" ] ; then
   if [ "${GIT_CHANGES_PENDING}" == "FALSE" ] ; then
	   echo "No pending git changes to push, exiting..."
	   exit 0
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

   # Push the current branch (if not already pushed)
   git push origin "$BRANCH_NAME"

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
