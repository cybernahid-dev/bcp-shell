#!/usr/bin/env python3
# BCP-Shell Banner Generator
# Creates custom banners for users

import os
import sys
import argparse
from datetime import datetime

BCP_HOME = os.path.expanduser("~/.bcp-shell")
BANNER_DIR = os.path.join(BCP_HOME, "banners", "custom")

def create_banner(name, text, style="box"):
    """Create a custom banner"""
    
    os.makedirs(BANNER_DIR, exist_ok=True)
    
    banner_file = os.path.join(BANNER_DIR, f"{name}.banner")
    
    styles = {
        "box": create_box_banner,
        "line": create_line_banner,
        "ascii": create_ascii_banner,
        "simple": create_simple_banner
    }
    
    if style in styles:
        banner_content = styles[style](text)
    else:
        banner_content = create_box_banner(text)
    
    with open(banner_file, 'w') as f:
        f.write(banner_content)
    
    print(f"✓ Banner created: {name}")
    print(f"  Location: {banner_file}")
    return banner_file

def create_box_banner(text):
    """Create box-style banner"""
    lines = text.split('\n')
    max_len = max(len(line) for line in lines)
    
    banner = "╔" + "═" * (max_len + 2) + "╗\n"
    for line in lines:
        padding = max_len - len(line)
        banner += f"║ {line}" + " " * padding + " ║\n"
    banner += "╚" + "═" * (max_len + 2) + "╝"
    
    return banner

def create_line_banner(text):
    """Create line-style banner"""
    return f"──────────────────────────────────\n{text}\n──────────────────────────────────"

def create_ascii_banner(text):
    """Create ASCII art banner"""
    ascii_art = """
    ╔══════════════════════════════════╗
    ║        TeamBCP Shell             ║
    ║    {text:^28}   ║
    ║    {date:^28}   ║
    ╚══════════════════════════════════╝
    """
    return ascii_art.format(
        text=text[:28],
        date=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    )

def create_simple_banner(text):
    """Create simple banner"""
    return f"""
╔══════════════════════════════════╗
║           {text:^20}           ║
║      User: @{{USER_NAME}}                 ║
║      Time: {{TIME}}                     ║
╚══════════════════════════════════╝
"""

def list_banners():
    """List all available banners"""
    banners_dir = os.path.join(BCP_HOME, "banners")
    print("Available banners:")
    print("-" * 40)
    
    for root, dirs, files in os.walk(banners_dir):
        for file in files:
            if file.endswith('.banner'):
                rel_path = os.path.relpath(os.path.join(root, file), banners_dir)
                print(f"  • {rel_path[:-7]}")

def main():
    parser = argparse.ArgumentParser(description="BCP-Shell Banner Generator")
    subparsers = parser.add_subparsers(dest="command", help="Commands")
    
    # Create command
    create_parser = subparsers.add_parser("create", help="Create new banner")
    create_parser.add_argument("name", help="Banner name")
    create_parser.add_argument("text", help="Banner text")
    create_parser.add_argument("--style", choices=["box", "line", "ascii", "simple"],
                             default="box", help="Banner style")
    
    # List command
    subparsers.add_parser("list", help="List all banners")
    
    args = parser.parse_args()
    
    if args.command == "create":
        create_banner(args.name, args.text, args.style)
    elif args.command == "list":
        list_banners()
    else:
        parser.print_help()

if __name__ == "__main__":
    main()
