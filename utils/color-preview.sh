#!/usr/bin/env bash
# BCP-Shell Color Preview
# Shows all available colors

echo -e "${CYAN}╔══════════════════════════════════════════╗"
echo -e "║          Color Preview Tool           ║"
echo -e "╚══════════════════════════════════════════╝${NC}"

echo -e "\n${BOLD}Standard Colors:${NC}"
echo -e "────────────────────────────────────"

# Standard colors
echo -e "  \033[0;30m████████████████${NC} - Black"
echo -e "  \033[0;31m████████████████${NC} - Red"
echo -e "  \033[0;32m████████████████${NC} - Green"
echo -e "  \033[0;33m████████████████${NC} - Yellow"
echo -e "  \033[0;34m████████████████${NC} - Blue"
echo -e "  \033[0;35m████████████████${NC} - Magenta"
echo -e "  \033[0;36m████████████████${NC} - Cyan"
echo -e "  \033[0;37m████████████████${NC} - White"

echo -e "\n${BOLD}Bright Colors:${NC}"
echo -e "────────────────────────────────────"

# Bright colors
echo -e "  \033[1;30m████████████████${NC} - Bright Black (Gray)"
echo -e "  \033[1;31m████████████████${NC} - Bright Red"
echo -e "  \033[1;32m████████████████${NC} - Bright Green"
echo -e "  \033[1;33m████████████████${NC} - Bright Yellow"
echo -e "  \033[1;34m████████████████${NC} - Bright Blue"
echo -e "  \033[1;35m████████████████${NC} - Bright Magenta"
echo -e "  \033[1;36m████████████████${NC} - Bright Cyan"
echo -e "  \033[1;37m████████████████${NC} - Bright White"

echo -e "\n${BOLD}BCP-Shell Named Colors:${NC}"
echo -e "────────────────────────────────────"

# BCP named colors
echo -e "  \033[0;33m████████████████${NC} - Orange"
echo -e "  \033[0;35m████████████████${NC} - Purple"
echo -e "  \033[1;35m████████████████${NC} - Pink"
echo -e "  \033[0;90m████████████████${NC} - Gray"

echo -e "\n${BOLD}Background Colors:${NC}"
echo -e "────────────────────────────────────"

# Background colors
echo -e "  \033[40m████████████████\033[0m - Black Background"
echo -e "  \033[41m████████████████\033[0m - Red Background"
echo -e "  \033[42m████████████████\033[0m - Green Background"
echo -e "  \033[43m████████████████\033[0m - Yellow Background"
echo -e "  \033[44m████████████████\033[0m - Blue Background"
echo -e "  \033[45m████████████████\033[0m - Magenta Background"
echo -e "  \033[46m████████████████\033[0m - Cyan Background"
echo -e "  \033[47m████████████████\033[0m - White Background"

echo -e "\n${BOLD}Text Styles:${NC}"
echo -e "────────────────────────────────────"

# Text styles
echo -e "  \033[1mBold Text\033[0m"
echo -e "  \033[2mDim Text\033[0m"
echo -e "  \033[3mItalic Text\033[0m"
echo -e "  \033[4mUnderlined Text\033[0m"
echo -e "  \033[5mBlinking Text\033[0m"
echo -e "  \033[7mInverted Text\033[0m"
echo -e "  \033[8mHidden Text\033[0m"
echo -e "  \033[9mStrikethrough Text\033[0m"

echo -e "\n${BOLD}Usage in Themes:${NC}"
echo -e "────────────────────────────────────"
echo -e "In theme files, use these color names:"
echo -e "  black, red, green, yellow, blue"
echo -e "  magenta, cyan, white, orange"
echo -e "  purple, pink, gray"
echo -e ""
echo -e "Example:"
echo -e "  PROMPT_COLOR=\"cyan\""
echo -e "  USER_COLOR=\"green\""
echo -e "  BANNER_COLOR=\"magenta\""

echo -e "\n${CYAN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}Run 'bcp-theme-create' to make your own theme!${NC}"
