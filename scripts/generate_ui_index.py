import os
import json
from bs4 import BeautifulSoup
from pathlib import Path

PUBLIC_DIR = './public'

ui_index = {}

def insert_html_by_level(parts, html_block, source_file):
    doctype = parts[0]
    screen = parts[1] if len(parts) > 1 else ''
    section = parts[2] if len(parts) > 2 else ''
    field = parts[3] if len(parts) > 3 else ''

    screens = ui_index.setdefault("screen", {})
    screen_node = screens.setdefault(screen, {"_html": {}, "section": {}})

    if len(parts) == 2:
        screen_node["_html"].setdefault(doctype, []).append({
            "html": html_block,
            "source": source_file
        })
        return

    sections = screen_node.setdefault("section", {})
    section_node = sections.setdefault(section, {"_html": {}, "field": {}})

    if len(parts) == 3:
        section_node["_html"].setdefault(doctype, []).append({
            "html": html_block,
            "source": source_file
        })
        return

    fields = section_node.setdefault("field", {})
    field_node = fields.setdefault(field, {"_html": {}})

    if len(parts) == 4:
        field_node["_html"].setdefault(doctype, []).append({
            "html": html_block,
            "source": source_file
        })

# Walk through all HTML files
for root, dirs, files in os.walk(PUBLIC_DIR):
    for file in files:
        if file.endswith('.html'):
            path = os.path.join(root, file)
            rel_path = os.path.relpath(path, PUBLIC_DIR).replace('\\', '/')
            with open(path, 'r', encoding='utf-8') as f:
                soup = BeautifulSoup(f, 'html.parser')
                for tag in soup.find_all(attrs={'id': True}):
                    id_val = tag['id']
                    if '.' not in id_val:
                        continue
                    parts = id_val.split('.')
                    if len(parts) < 2:
                        continue
                    html_block = str(tag)
                    insert_html_by_level(parts, html_block, rel_path)

def sort_dict(d):
    if not isinstance(d, dict):
        return d
    return {k: sort_dict(v) for k, v in sorted(d.items())}

sorted_ui_index = sort_dict(ui_index)

output_path = Path("ui-index.json")
output_path.parent.mkdir(parents=True, exist_ok=True)

with output_path.open("w", encoding="utf-8") as f:
    json.dump(sorted_ui_index, f, indent=2, ensure_ascii=False)

print(f"✅ UI index written to {output_path}")
