import re
import os

def run():
    log_path = r"C:\Users\Om\.gemini\antigravity-ide\brain\a91e5d3e-5293-4188-a4da-d1496f97bd03\.system_generated\tasks\task-303.log"
    if not os.path.exists(log_path):
        print(f"Log not found: {log_path}")
        return
        
    with open(log_path, 'r', encoding='utf-8') as f:
        log_content = f.read()

    pattern = re.compile(r'^(lib/[^\(]+)\((\d+),(\d+)\): error .*?Constant evaluation error:', re.MULTILINE)
    fixes = {}

    for m in pattern.finditer(log_content):
        path = m.group(1)
        line = int(m.group(2))
        full_path = r"C:\Users\Om\Downloads\nb-main\nb-main\\" + path.replace('/', '\\')
        fixes.setdefault(full_path, []).append(line)

    for filepath, lines in fixes.items():
        with open(filepath, 'r', encoding='utf-8') as f:
            content_lines = f.readlines()
        
        for line_idx in sorted(set(lines), reverse=True):
            idx = line_idx - 1
            for i in range(idx, max(-1, idx - 15), -1):
                if 'const ' in content_lines[i]:
                    content_lines[i] = re.sub(r'\bconst\s+', '', content_lines[i], count=1)
                    print(f"Fixed {os.path.basename(filepath)}:{i+1}")
                    break
                    
        with open(filepath, 'w', encoding='utf-8') as f:
            f.writelines(content_lines)

if __name__ == '__main__':
    run()
