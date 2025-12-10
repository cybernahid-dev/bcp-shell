#!/usr/bin/env bash
# BCP-Shell Theme Manager
# Manages themes including downloading from repository

BCP_HOME="$HOME/.bcp-shell"
THEME_DIR="$BCP_HOME/themes"
CONFIG="$BCP_HOME/config/user-config"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Load config
source "$CONFIG" 2>/dev/null || {
    THEME="default"
}

# List all themes
list_themes() {
    echo -e "${CYAN}╔══════════════════════════════════════════╗"
    echo -e "║            Available Themes             ║"
    echo -e "╠══════════════════════════════════════════╣${NC}"
    
    echo -e "${YELLOW}📁 Built-in Themes:${NC}"
    local count=0
    for theme in "$THEME_DIR"/*.theme 2>/dev/null; do
        if [[ -f "$theme" ]]; then
            local name=$(basename "$theme" .theme)
            local theme_name=$(grep "^NAME=" "$theme" 2>/dev/null | cut -d'"' -f2 || echo "$name")
            
            if [[ "$name" == "$THEME" ]]; then
                echo -e "  ${GREEN}✓ $name ${YELLOW}($theme_name) - current${NC}"
            else
                echo -e "  ${BLUE}• $name ${CYAN}($theme_name)${NC}"
            fi
            ((count++))
        fi
    done
    
    echo -e "\n${YELLOW}📁 Custom Themes:${NC}"
    for theme in "$THEME_DIR/custom"/*.theme 2>/dev/null; do
        if [[ -f "$theme" ]]; then
            local name="custom/$(basename "$theme" .theme)"
            local theme_name=$(grep "^NAME=" "$theme" 2>/dev/null | cut -d'"' -f2 || echo "$(basename "$theme" .theme)")
            
            if [[ "$name" == "$THEME" ]]; then
                echo -e "  ${GREEN}✓ $name ${YELLOW}($theme_name) - current${NC}"
            else
                echo -e "  ${MAGENTA}• $name ${CYAN}($theme_name)${NC}"
            fi
            ((count++))
        fi
    done
    
    echo -e "\n${CYAN}╠══════════════════════════════════════════╣"
    echo -e "║ Total: $count themes available           ║"
    echo -e "╚══════════════════════════════════════════╝${NC}"
}

# Preview theme
preview_theme() {
    local theme_name="$1"
    local theme_file=""
    
    # Find theme file
    if [[ -f "$THEME_DIR/$theme_name.theme" ]]; then
        theme_file="$THEME_DIR/$theme_name.theme"
    elif [[ -f "$THEME_DIR/custom/$theme_name.theme" ]]; then
        theme_file="$THEME_DIR/custom/$theme_name.theme"
    else
        echo -e "${RED}Error: Theme '$theme_name' not found${NC}"
        return 1
    fi
    
    echo -e "\n${CYAN}Preview of '$theme_name':${NC}"
    echo -e "${YELLOW}────────────────────────────────────${NC}"
    
    # Load theme temporarily
    source "$theme_file"
    
    echo -e "${BOLD}Theme Name:${NC} $NAME"
    echo -e ""
    echo -e "${CYAN}Color Scheme:${NC}"
    echo -e "  Prompt:    $(color_code "$PROMPT_COLOR")████████████████${NC} ($PROMPT_COLOR)"
    echo -e "  User:      $(color_code "$USER_COLOR")████████████████${NC} ($USER_COLOR)"
    echo -e "  Host:      $(color_code "$HOST_COLOR")████████████████${NC} ($HOST_COLOR)"
    echo -e "  Directory: $(color_code "$DIR_COLOR")████████████████${NC} ($DIR_COLOR)"
    echo -e "  Time:      $(color_code "$TIME_COLOR")████████████████${NC} ($TIME_COLOR)"
    echo -e "  Banner:    $(color_code "$BANNER_COLOR")████████████████${NC} ($BANNER_COLOR)"
    echo -e ""
    echo -e "${CYAN}Style:${NC} $ASCII_STYLE"
    
    echo -e "${YELLOW}────────────────────────────────────${NC}"
    
    # Reload original config
    source "$CONFIG"
}

# Color helper for preview
color_code() {
    case "$1" in
        "black")    echo -e "\033[0;30m" ;;
        "red")      echo -e "\033[0;31m" ;;
        "green")    echo -e "\033[0;32m" ;;
        "yellow")   echo -e "\033[1;33m" ;;
        "blue")     echo -e "\033[0;34m" ;;
        "magenta")  echo -e "\033[0;35m" ;;
        "cyan")     echo -e "\033[0;36m" ;;
        "white")    echo -e "\033[1;37m" ;;
        "orange")   echo -e "\033[0;33m" ;;
        "purple")   echo -e "\033[0;35m" ;;
        "pink")     echo -e "\033[1;35m" ;;
        "gray")     echo -e "\033[0;90m" ;;
        *)          echo -e "\033[0m" ;;
    esac
}

# Set active theme
set_theme() {
    local theme_name="$1"
    
    # Check if theme exists
    if [[ ! -f "$THEME_DIR/$theme_name.theme" ]] && \
       [[ ! -f "$THEME_DIR/custom/$theme_name.theme" ]]; then
        echo -e "${RED}Error: Theme '$theme_name' not found${NC}"
        echo -e "Use 'bcp-theme list' to see available themes"
        return 1
    fi
    
    # Update config
    sed -i "s/^THEME=.*/THEME=\"$theme_name\"/" "$CONFIG"
    source "$CONFIG"
    
    echo -e "${GREEN}✓ Theme set to: $theme_name${NC}"
    echo -e "${YELLOW}Changes will apply to your next prompt.${NC}"
    
    # Ask to preview
    read -p "Preview theme colors? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        preview_theme "$theme_name"
    fi
}

# Create new theme
create_theme() {
    local theme_name="$1"
    
    if [[ -z "$theme_name" ]]; then
        echo -e "${RED}Error: Please provide a theme name${NC}"
        echo -e "Usage: bcp-theme create <name>"
        return 1
    fi
    
    # Check if exists
    if [[ -f "$THEME_DIR/custom/$theme_name.theme" ]] || \
       [[ -f "$THEME_DIR/$theme_name.theme" ]]; then
        echo -e "${YELLOW}Theme '$theme_name' already exists. Overwrite? (y/N): ${NC}"
        read -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi
    
    # Create theme template
    local theme_file="$THEME_DIR/custom/$theme_name.theme"
    
    cat > "$theme_file" << 'EOF'
# Custom Theme: {THEME_NAME}
NAME="{THEME_NAME}"
PROMPT_COLOR="cyan"
USER_COLOR="green"
HOST_COLOR="yellow"
DIR_COLOR="magenta"
TIME_COLOR="blue"
GIT_COLOR="white"
SUCCESS_COLOR="green"
ERROR_COLOR="red"
WARNING_COLOR="yellow"
INFO_COLOR="cyan"
BANNER_COLOR="cyan"
ASCII_STYLE="standard"

# Available colors:
#   black, red, green, yellow, blue, magenta, cyan, white
#   orange, purple, pink, gray
EOF
    
    # Replace placeholder
    sed -i "s/{THEME_NAME}/$theme_name/" "$theme_file"
    
    echo -e "${GREEN}✓ Theme created: $theme_name${NC}"
    echo -e "${YELLOW}Location: $theme_file${NC}"
    
    # Open for editing
    read -p "Edit theme now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        "${EDITOR:-nano}" "$theme_file"
    fi
    
    # Ask to set as active
    read -p "Set as active theme? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        set_theme "custom/$theme_name"
    fi
}

# Edit theme
edit_theme() {
    local theme_name="$1"
    local theme_file=""
    
    if [[ -z "$theme_name" ]]; then
        echo -e "${RED}Error: Please provide a theme name${NC}"
        echo -e "Usage: bcp-theme edit <name>"
        return 1
    fi
    
    # Find theme file
    if [[ -f "$THEME_DIR/$theme_name.theme" ]]; then
        theme_file="$THEME_DIR/$theme_name.theme"
    elif [[ -f "$THEME_DIR/custom/$theme_name.theme" ]]; then
        theme_file="$THEME_DIR/custom/$theme_name.theme"
    else
        echo -e "${RED}Error: Theme '$theme_name' not found${NC}"
        return 1
    fi
    
    # Open editor
    echo -e "${CYAN}Editing theme: $theme_name${NC}"
    echo -e "${YELLOW}File: $theme_file${NC}"
    
    "${EDITOR:-nano}" "$theme_file"
    
    echo -e "${GREEN}✓ Theme updated${NC}"
}

# Delete theme
delete_theme() {
    local theme_name="$1"
    
    if [[ -z "$theme_name" ]]; then
        echo -e "${RED}Error: Please provide a theme name${NC}"
        echo -e "Usage: bcp-theme delete <name>"
        return 1
    fi
    
    # Don't allow deleting active theme
    if [[ "$theme_name" == "$THEME" ]]; then
        echo -e "${RED}Cannot delete active theme!${NC}"
        echo -e "Please select a different theme first:"
        echo -e "  bcp-theme set <other-theme>"
        return 1
    fi
    
    local theme_file=""
    
    # Find and delete
    if [[ -f "$THEME_DIR/$theme_name.theme" ]]; then
        theme_file="$THEME_DIR/$theme_name.theme"
        echo -e "${YELLOW}Deleting built-in theme: $theme_name${NC}"
    elif [[ -f "$THEME_DIR/custom/$theme_name.theme" ]]; then
        theme_file="$THEME_DIR/custom/$theme_name.theme"
        echo -e "${YELLOW}Deleting custom theme: $theme_name${NC}"
    else
        echo -e "${RED}Error: Theme '$theme_name' not found${NC}"
        return 1
    fi
    
    # Confirm deletion
    echo -e "${RED}This action cannot be undone!${NC}"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Deletion cancelled${NC}"
        return 0
    fi
    
    rm -f "$theme_file"
    echo -e "${GREEN}✓ Theme deleted: $theme_name${NC}"
}

# Download themes from repository
download_themes() {
    echo -e "${CYAN}Checking for new themes from repository...${NC}"
    
    # GitHub API URL for themes
    local repo_url="https://api.github.com/repos/cybernahid-dev/bcp-shell/contents/themes"
    local temp_dir="/tmp/bcp-themes-$$"
    
    mkdir -p "$temp_dir"
    
    # Download theme list
    echo -e "${YELLOW}Fetching theme list...${NC}"
    curl -sSL "$repo_url" -o "$temp_dir/themes.json" 2>/dev/null
    
    if [[ ! -f "$temp_dir/themes.json" ]]; then
        echo -e "${RED}Failed to fetch themes${NC}"
        return 1
    fi
    
    # Parse and download
    local downloaded=0
    grep -o '"download_url": "[^"]*"' "$temp_dir/themes.json" | \
    cut -d'"' -f4 | while read url; do
        local filename=$(basename "$url")
        
        # Skip if already exists
        if [[ -f "$THEME_DIR/$filename" ]]; then
            continue
        fi
        
        echo -e "${BLUE}Downloading: $filename${NC}"
        curl -sSL "$url" -o "$THEME_DIR/$filename" 2>/dev/null
        
        if [[ -f "$THEME_DIR/$filename" ]]; then
            echo -e "  ${GREEN}✓ Downloaded${NC}"
            ((downloaded++))
        else
            echo -e "  ${RED}✗ Failed${NC}"
        fi
    done
    
    rm -rf "$temp_dir"
    
    echo -e "\n${CYAN}══════════════════════════════════════════${NC}"
    echo -e "${GREEN}Download complete!${NC}"
    echo -e "${YELLOW}New themes downloaded: $downloaded${NC}"
    echo -e "${CYAN}Use 'bcp-theme list' to see all themes${NC}"
}

# Theme menu
theme_menu() {
    while true; do
        echo -e "\n${CYAN}╔══════════════════════════════════════════╗"
        echo -e "║           BCP Theme Manager            ║"
        echo -e "╠══════════════════════════════════════════╣${NC}"
        echo -e "${YELLOW}Current theme: ${GREEN}$THEME${NC}"
        echo -e ""
        echo -e "${BLUE}1.${NC} List all themes"
        echo -e "${BLUE}2.${NC} Preview theme"
        echo -e "${BLUE}3.${NC} Set active theme"
        echo -e "${BLUE}4.${NC} Create new theme"
        echo -e "${BLUE}5.${NC} Edit theme"
        echo -e "${BLUE}6.${NC} Delete theme"
        echo -e "${BLUE}7.${NC} Download new themes"
        echo -e "${BLUE}8.${NC} Help"
        echo -e "${BLUE}9.${NC} Exit"
        echo -e "${CYAN}══════════════════════════════════════════${NC}"
        
        read -p $'\n'"${YELLOW}Select option [1-9]: ${NC}" choice
        
        case $choice in
            1)
                list_themes
                ;;
            2)
                read -p "Enter theme name to preview: " name
                preview_theme "$name"
                ;;
            3)
                read -p "Enter theme name to set: " name
                set_theme "$name"
                ;;
            4)
                read -p "Enter name for new theme: " name
                create_theme "$name"
                ;;
            5)
                read -p "Enter theme name to edit: " name
                edit_theme "$name"
                ;;
            6)
                read -p "Enter theme name to delete: " name
                delete_theme "$name"
                ;;
            7)
                download_themes
                ;;
            8)
                echo -e "\n${CYAN}BCP Theme Manager Help:${NC}"
                echo -e "  ${GREEN}bcp-theme list${NC}    - List all themes"
                echo -e "  ${GREEN}bcp-theme set <name>${NC} - Set active theme"
                echo -e "  ${GREEN}bcp-theme create <name>${NC} - Create new theme"
                echo -e "  ${GREEN}bcp-theme edit <name>${NC} - Edit theme"
                echo -e "  ${GREEN}bcp-theme delete <name>${NC} - Delete theme"
                echo -e "  ${GREEN}bcp-theme download${NC} - Download new themes"
                ;;
            9)
                echo -e "${GREEN}Exiting Theme Manager...${NC}"
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
bcp_theme() {
    local command="$1"
    local argument="$2"
    
    case "$command" in
        "list")
            list_themes
            ;;
        "preview")
            preview_theme "$argument"
            ;;
        "set")
            set_theme "$argument"
            ;;
        "create")
            create_theme "$argument"
            ;;
        "edit")
            edit_theme "$argument"
            ;;
        "delete")
            delete_theme "$argument"
            ;;
        "download")
            download_themes
            ;;
        "menu")
            theme_menu
            ;;
        ""|"help")
            echo -e "${CYAN}BCP Theme Manager - Usage:${NC}"
            echo -e "  ${GREEN}bcp-theme list${NC}           - List all themes"
            echo -e "  ${GREEN}bcp-theme preview <name>${NC} - Preview theme"
            echo -e "  ${GREEN}bcp-theme set <name>${NC}     - Set active theme"
            echo -e "  ${GREEN}bcp-theme create <name>${NC}  - Create new theme"
            echo -e "  ${GREEN}bcp-theme edit <name>${NC}    - Edit theme"
            echo -e "  ${GREEN}bcp-theme delete <name>${NC}  - Delete theme"
            echo -e "  ${GREEN}bcp-theme download${NC}       - Download new themes"
            echo -e "  ${GREEN}bcp-theme menu${NC}           - Interactive menu"
            echo -e "  ${GREEN}bcp-theme help${NC}           - Show this help"
            ;;
        *)
            echo -e "${RED}Unknown command: $command${NC}"
            echo -e "Use 'bcp-theme help' for usage"
            return 1
            ;;
    esac
}

# Export function
alias bcp-theme='bcp_theme'
