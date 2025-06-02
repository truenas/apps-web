import os
import json
from bs4 import BeautifulSoup
from collections import defaultdict
from pathlib import Path

# Directory containing rendered HTML files
PUBLIC_DIR = './public'

# Store IDs and associated HTML
ui_index = defaultdict(list)

# Helper to extract ID hierarchy
def parse_id(id_str):
    parts = id_str.split('.')
    if len(parts) < 2:
        return ('zzz', 'zzz', 'zzz', 'zzz')  # Force to bottom of sort if malformed
    doctype = parts[0]
    screen = parts[1] if len(parts) > 1 else ''
    section = parts[2] if len(parts) > 2 else ''
    field = parts[3] if len(parts) > 3 else ''
    return (screen, section, field, doctype)

# Walk through all HTML files in public/
for root, dirs, files in os.walk(PUBLIC_DIR):
    for file in files:
        if file.endswith('.html'):
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                soup = BeautifulSoup(f, 'html.parser')
                for tag in soup.find_all(attrs={'id': True}):
                    id_val = tag['id']
                    if '.' in id_val:  # We're only interested in structured IDs
                        html_block = str(tag)
                        ui_index[id_val].append(html_block)

# Sort keys by screen > section > field > doctype
sorted_keys = sorted(ui_index.keys(), key=parse_id)

# Create ordered dict for output
sorted_ui_index = {key: ui_index[key] for key in sorted_keys}

# Output path
output_path = Path("public/ui-index.json")
output_path.parent.mkdir(parents=True, exist_ok=True)

with output_path.open("w", encoding="utf-8") as f:
    json.dump(ui_index, f, indent=2, ensure_ascii=False)
print(f"✅ UI index written to: {output_path}")
