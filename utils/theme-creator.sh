#!/usr/bin/env bash
# BCP-Shell Theme Creator
# Interactive theme creation tool

BCP_HOME="$HOME/.bcp-shell"
THEME_DIR="$BCP_HOME/themes/custom"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Available colors
COLORS=(
    "black" "red" "green" "yellow" "blue" "magenta" "cyan" "white"
    "orange" "purple" "pink" "gray"
)

# Color samples
show_color_samples() {
    echo -e "\n${CYAN}Available Colors:${NC}"
    echo -e "${YELLOW}────────────────────────────────────${NC}"
    
    for color in "${COLORS[@]}"; do
        case $color in
            "black")    echo -e "  black    - \033[0;30m████████████████${NC}" ;;
            "red")      echo -e "  red      - \033[0;31m████████████████${NC}" ;;
            "green")    echo -e "  green    - \033[0;32m████████████████${NC}" ;;
            "yellow")   echo -e "  yellow   - \033[1;33m████████████████${NC}" ;;
            "blue")     echo -e "  blue     - \033[0;34m████████████████${NC}" ;;
            "magenta")  echo -e "  magenta  - \033[0;35m████████████████${NC}" ;;
            "cyan")     echo -e "  cyan     - \033[0;36m████████████████${NC}" ;;
            "white")    echo -e "  white    - \033[1;37m████████████████${NC}" ;;
            "orange")   echo -e "  orange   - \033[0;33m████████████████${NC}" ;;
            "purple")   echo -e "  purple   - \033[0;35m████████████████${NC}" ;;
            "pink")     echo -e "  pink     - \033[1;35m████████████████${NC}" ;;
            "gray")     echo -e "  gray     - \033[0;90m████████████████${NC}" ;;
        esac
    done
    
    echo -e "${YELLOW}────────────────────────────────────${NC}"
}

# Create theme interactively
create_theme_interactive() {
    echo -e "${CYAN}╔══════════════════════════════════════════╗"
    echo -e "║         Interactive Theme Creator       ║"
    echo -e "╚══════════════════════════════════════════╝${NC}"
    
    # Get theme name
    read -p $'\n'"${YELLOW}Enter theme name: ${NC}" theme_name
    if [[ -z "$theme_name" ]]; then
        echo -e "${RED}Theme name cannot be empty${NC}"
        return 1
    fi
    
    # Check if exists
    if [[ -f "$THEME_DIR/$theme_name.theme" ]]; then
        echo -e "${YELLOW}Theme '$theme_name' already exists. Overwrite? (y/N): ${NC}"
        read -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi
    
    # Show color samples
    show_color_samples
    
    # Get colors
    echo -e "\n${CYAN}Select colors for your theme:${NC}"
    
    local prompt_color=""
    local user_color=""
    local host_color=""
    local dir_color=""
    local time_color=""
    local banner_color=""
    
    # Prompt color
    while [[ -z "$prompt_color" ]]; do
        read -p "${YELLOW}Prompt color (default: cyan): ${NC}" prompt_color
        prompt_color=${prompt_color:-"cyan"}
        if [[ ! " ${COLORS[@]} " =~ " ${prompt_color} " ]]; then
            echo -e "${RED}Invalid color. Choose from: ${COLORS[*]}${NC}"
            prompt_color=""
        fi
    done
    
    # User color
    while [[ -z "$user_color" ]]; do
        read -p "${YELLOW}User color (default: green): ${NC}" user_color
        user_color=${user_color:-"green"}
        if [[ ! " ${COLORS[@]} " =~ " ${user_color} " ]]; then
            echo -e "${RED}Invalid color${NC}"
            user_color=""
        fi
    done
    
    # Host color
    while [[ -z "$host_color" ]]; do
        read -p "${YELLOW}Host color (default: yellow): ${NC}" host_color
        host_color=${host_color:-"yellow"}
        if [[ ! " ${COLORS[@]} " =~ " ${host_color} " ]]; then
            echo -e "${RED}Invalid color${NC}"
            host_color=""
        fi
    done
    
    # Directory color
    while [[ -z "$dir_color" ]]; do
        read -p "${YELLOW}Directory color (default: magenta): ${NC}" dir_color
        dir_color=${dir_color:-"magenta"}
        if [[ ! " ${COLORS[@]} " =~ " ${dir_color} " ]]; then
            echo -e "${RED}Invalid color${NC}"
            dir_color=""
        fi
    done
    
    # Time color
    while [[ -z "$time_color" ]]; do
        read -p "${YELLOW}Time color (default: blue): ${NC}" time_color
        time_color=${time_color:-"blue"}
        if [[ ! " ${COLORS[@]} " =~ " ${time_color} " ]]; then
            echo -e "${RED}Invalid color${NC}"
            time_color=""
        fi
    done
    
    # Banner color
    while [[ -z "$banner_color" ]]; do
        read -p "${YELLOW}Banner color (default: cyan): ${NC}" banner_color
        banner_color=${banner_color:-"cyan"}
        if [[ ! " ${COLORS[@]} " =~ " ${banner_color} " ]]; then
            echo -e "${RED}Invalid color${NC}"
            banner_color=""
        fi
    done
    
    # ASCII style
    read -p "${YELLOW}ASCII style (standard/cyber/minimal, default: standard): ${NC}" ascii_style
    ascii_style=${ascii_style:-"standard"}
    
    # Create theme file
    local theme_file="$THEME_DIR/$theme_name.theme"
    mkdir -p "$THEME_DIR"
    
    cat > "$theme_file" << EOF
# Custom Theme: $theme_name
NAME="$theme_name"
PROMPT_COLOR="$prompt_color"
USER_COLOR="$user_color"
HOST_COLOR="$host_color"
DIR_COLOR="$dir_color"
TIME_COLOR="$time_color"
GIT_COLOR="white"
SUCCESS_COLOR="green"
ERROR_COLOR="red"
WARNING_COLOR="yellow"
INFO_COLOR="cyan"
BANNER_COLOR="$banner_color"
ASCII_STYLE="$ascii_style"
EOF
    
    echo -e "\n${GREEN}✓ Theme created successfully!${NC}"
    echo -e "${YELLOW}File: $theme_file${NC}"
    
    # Preview
    echo -e "\n${CYAN}Theme Preview:${NC}"
    echo -e "${YELLOW}────────────────────────────────────${NC}"
    
    # Load and show colors
    source "$theme_file"
    
    echo -e "Prompt:    $(color_sample "$PROMPT_COLOR")"
    echo -e "User:      $(color_sample "$USER_COLOR")"
    echo -e "Host:      $(color_sample "$HOST_COLOR")"
    echo -e "Directory: $(color_sample "$DIR_COLOR")"
    echo -e "Time:      $(color_sample "$TIME_COLOR")"
    echo -e "Banner:    $(color_sample "$BANNER_COLOR")"
    
    echo -e "${YELLOW}────────────────────────────────────${NC}"
    
    # Ask to set as active
    read -p $'\n'"${YELLOW}Set as active theme? (y/N): ${NC}" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if type bcp_theme &>/dev/null; then
            bcp_theme set "custom/$theme_name"
        else
            echo -e "${YELLOW}Run this to set theme:${NC}"
            echo -e "bcp-theme set custom/$theme_name"
        fi
    fi
    
    # Ask to edit
    read -p "${YELLOW}Edit theme file? (y/N): ${NC}" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        "${EDITOR:-nano}" "$theme_file"
    fi
}

# Color sample helper
color_sample() {
    local color="$1"
    case $color in
        "black")    echo -e "\033[0;30m████████████████\033[0m ($color)" ;;
        "red")      echo -e "\033[0;31m████████████████\033[0m ($color)" ;;
        "green")    echo -e "\033[0;32m████████████████\033[0m ($color)" ;;
        "yellow")   echo -e "\033[1;33m████████████████\033[0m ($color)" ;;
        "blue")     echo -e "\033[0;34m████████████████\033[0m ($color)" ;;
        "magenta")  echo -e "\033[0;35m████████████████\033[0m ($color)" ;;
        "cyan")     echo -e "\033[0;36m████████████████\033[0m ($color)" ;;
        "white")    echo -e "\033[1;37m████████████████\033[0m ($color)" ;;
        "orange")   echo -e "\033[0;33m████████████████\033[0m ($color)" ;;
        "purple")   echo -e "\033[0;35m████████████████\033[0m ($color)" ;;
        "pink")     echo -e "\033[1;35m████████████████\033[0m ($color)" ;;
        "gray")     echo -e "\033[0;90m████████████████\033[0m ($color)" ;;
        *)          echo -e "\033[0m████████████████\033[0m ($color)" ;;
    esac
}

# Edit existing theme
edit_theme_interactive() {
    echo -e "${CYAN}Select theme to edit:${NC}"
    
    # List themes
    local themes=()
    local i=1
    
    for theme in "$THEME_DIR"/*.theme 2>/dev/null; do
        if [[ -f "$theme" ]]; then
            local name=$(basename "$theme" .theme)
            themes[i]="$name"
            echo -e "  ${BLUE}$i.${NC} $name"
            ((i++))
        fi
    done
    
    if [[ ${#themes[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No custom themes found${NC}"
        return 1
    fi
    
    read -p $'\n'"${YELLOW}Select theme [1-$(($i-1))]: ${NC}" choice
    
    if [[ ! "$choice" =~ ^[0-9]+$ ]] || [[ "$choice" -lt 1 ]] || [[ "$choice" -ge $i ]]; then
        echo -e "${RED}Invalid selection${NC}"
        return 1
    fi
    
    local theme_name="${themes[$choice]}"
    local theme_file="$THEME_DIR/$theme_name.theme"
    
    echo -e "\n${CYAN}Editing theme: $theme_name${NC}"
    "${EDITOR:-nano}" "$theme_file"
    
    echo -e "${GREEN}✓ Theme updated${NC}"
}

# Main menu
main_menu() {
    while true; do
        echo -e "\n${CYAN}╔══════════════════════════════════════════╗"
        echo -e "║         BCP Theme Creator            ║"
        echo -e "╠══════════════════════════════════════════╣${NC}"
        echo -e "${BLUE}1.${NC} Create new theme"
        echo -e "${BLUE}2.${NC} Edit existing theme"
        echo -e "${BLUE}3.${NC} Show color samples"
        echo -e "${BLUE}4.${NC} List existing themes"
        echo -e "${BLUE}5.${NC} Help"
        echo -e "${BLUE}6.${NC} Exit"
        echo -e "${CYAN}══════════════════════════════════════════${NC}"
        
        read -p $'\n'"${YELLOW}Select option [1-6]: ${NC}" choice
        
        case $choice in
            1)
                create_theme_interactive
                ;;
            2)
                edit_theme_interactive
                ;;
            3)
                show_color_samples
                ;;
            4)
                echo -e "\n${CYAN}Custom Themes:${NC}"
                ls "$THEME_DIR"/*.theme 2>/dev/null | xargs -n1 basename | sed 's/.theme$//' | column
                ;;
            5)
                echo -e "\n${CYAN}Theme Creator Help:${NC}"
                echo -e "This tool helps you create custom themes for BCP-Shell."
                echo -e "Themes control the colors and styles of your shell."
                echo -e ""
                echo -e "Usage:"
                echo -e "  bcp-theme-create       - Interactive creator"
                echo -e "  bcp-theme-create new   - Create new theme"
                echo -e "  bcp-theme-create edit  - Edit theme"
                echo -e "  bcp-theme-create list  - List themes"
                ;;
            6)
                echo -e "${GREEN}Exiting Theme Creator...${NC}"
                break
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                ;;
        esac
        
        echo -e "\n${YELLOW}Press Enter to continue...${NC}"
        read -r
    done
}

# Main function
bcp_theme_create() {
    local command="$1"
    
    case "$command" in
        "new")
            create_theme_interactive
            ;;
        "edit")
            edit_theme_interactive
            ;;
        "list")
            echo -e "${CYAN}Custom Themes:${NC}"
            ls "$THEME_DIR"/*.theme 2>/dev/null | xargs -n1 basename | sed 's/.theme$//' | column
            ;;
        "samples")
            show_color_samples
            ;;
        "menu")
            main_menu
            ;;
        ""|"help")
            echo -e "${CYAN}Theme Creator Usage:${NC}"
            echo -e "  ${GREEN}bcp-theme-create${NC}       - Interactive menu"
            echo -e "  ${GREEN}bcp-theme-create new${NC}   - Create new theme"
            echo -e "  ${GREEN}bcp-theme-create edit${NC}  - Edit existing theme"
            echo -e "  ${GREEN}bcp-theme-create list${NC}  - List custom themes"
            echo -e "  ${GREEN}bcp-theme-create samples${NC} - Show color samples"
            echo -e "  ${GREEN}bcp-theme-create menu${NC}  - Interactive menu"
            echo -e "  ${GREEN}bcp-theme-create help${NC}  - Show this help"
            ;;
        *)
            echo -e "${RED}Unknown command: $command${NC}"
            return 1
            ;;
    esac
}

# Export function
alias bcp-theme-create='bcp_theme_create'

# Run menu if no arguments
if [[ $# -eq 0 ]] && [[ $- == *i* ]]; then
    main_menu
fi
