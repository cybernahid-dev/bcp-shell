#!/usr/bin/env bash
# BCP-Shell Banner Manager
# Manages banners including downloading from repository

BCP_HOME="$HOME/.bcp-shell"
BANNER_DIR="$BCP_HOME/banners"
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
    USER_NAME="$(whoami)"
    DISPLAY_NAME="@$(whoami)"
    BANNER="default"
}

# List all banners
list_banners() {
    echo -e "${CYAN}╔══════════════════════════════════════════╗"
    echo -e "║           Available Banners            ║"
    echo -e "╠══════════════════════════════════════════╣${NC}"
    
    echo -e "${YELLOW}📁 Built-in Banners:${NC}"
    local count=0
    for banner in "$BANNER_DIR"/*.banner 2>/dev/null; do
        if [[ -f "$banner" ]]; then
            local name=$(basename "$banner" .banner)
            if [[ "$name" == "$BANNER" ]]; then
                echo -e "  ${GREEN}✓ $name ${YELLOW}(current)${NC}"
            else
                echo -e "  ${BLUE}• $name${NC}"
            fi
            ((count++))
        fi
    done
    
    echo -e "\n${YELLOW}📁 Custom Banners:${NC}"
    for banner in "$BANNER_DIR/custom"/*.banner 2>/dev/null; do
        if [[ -f "$banner" ]]; then
            local name="custom/$(basename "$banner" .banner)"
            if [[ "$name" == "$BANNER" ]]; then
                echo -e "  ${GREEN}✓ $name ${YELLOW}(current)${NC}"
            else
                echo -e "  ${MAGENTA}• $name${NC}"
            fi
            ((count++))
        fi
    done
    
    echo -e "\n${CYAN}╠══════════════════════════════════════════╣"
    echo -e "║ Total: $count banners available          ║"
    echo -e "╚══════════════════════════════════════════╝${NC}"
}

# Preview banner
preview_banner() {
    local banner_name="$1"
    local banner_file=""
    
    # Find banner file
    if [[ -f "$BANNER_DIR/$banner_name.banner" ]]; then
        banner_file="$BANNER_DIR/$banner_name.banner"
    elif [[ -f "$BANNER_DIR/custom/$banner_name.banner" ]]; then
        banner_file="$BANNER_DIR/custom/$banner_name.banner"
    else
        echo -e "${RED}Error: Banner '$banner_name' not found${NC}"
        return 1
    fi
    
    echo -e "\n${CYAN}Preview of '$banner_name':${NC}"
    echo -e "${YELLOW}────────────────────────────────────${NC}"
    
    # Load temp config
    local temp_banner="$BANNER"
    local temp_user="$USER_NAME"
    BANNER="$banner_name"
    
    # Show banner
    if [[ -f "$banner_file" ]]; then
        local content=$(cat "$banner_file")
        content="${content//\{USER_NAME\}/$USER_NAME}"
        content="${content//\{DISPLAY_NAME\}/$DISPLAY_NAME}"
        content="${content//\{TEAM_NAME\}/TeamBCP}"
        content="${content//\{HOSTNAME\}/$(hostname)}"
        content="${content//\{TIME\}/$(date '+%H:%M:%S')}"
        echo -e "${CYAN}$content${NC}"
    fi
    
    echo -e "${YELLOW}────────────────────────────────────${NC}"
}

# Set active banner
set_banner() {
    local banner_name="$1"
    
    # Check if banner exists
    if [[ ! -f "$BANNER_DIR/$banner_name.banner" ]] && \
       [[ ! -f "$BANNER_DIR/custom/$banner_name.banner" ]]; then
        echo -e "${RED}Error: Banner '$banner_name' not found${NC}"
        echo -e "Use 'bcp-banner list' to see available banners"
        return 1
    fi
    
    # Update config
    sed -i "s/^BANNER=.*/BANNER=\"$banner_name\"/" "$CONFIG"
    source "$CONFIG"
    
    echo -e "${GREEN}✓ Banner set to: $banner_name${NC}"
    echo -e "${YELLOW}It will be shown in your next terminal session.${NC}"
    
    # Ask to preview
    read -p "Preview now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        preview_banner "$banner_name"
    fi
}

# Create new banner
create_banner() {
    local banner_name="$1"
    
    if [[ -z "$banner_name" ]]; then
        echo -e "${RED}Error: Please provide a banner name${NC}"
        echo -e "Usage: bcp-banner create <name>"
        return 1
    fi
    
    # Check if exists
    if [[ -f "$BANNER_DIR/custom/$banner_name.banner" ]] || \
       [[ -f "$BANNER_DIR/$banner_name.banner" ]]; then
        echo -e "${YELLOW}Banner '$banner_name' already exists. Overwrite? (y/N): ${NC}"
        read -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi
    
    # Create banner template
    local banner_file="$BANNER_DIR/custom/$banner_name.banner"
    
    cat > "$banner_file" << 'EOF'
╔═══════════════════════════════════════════════════╗
║                Custom Banner                      ║
║             User: @{USER_NAME}                    ║
║             Team: {TEAM_NAME}                     ║
║             Host: {HOSTNAME}                      ║
║             Time: {TIME}                          ║
║             Date: {DATE}                          ║
╚═══════════════════════════════════════════════════╝

Available variables:
  {USER_NAME}    - Your username
  {DISPLAY_NAME} - Your display name
  {TEAM_NAME}    - Team name
  {HOSTNAME}     - Computer hostname
  {TIME}         - Current time
  {DATE}         - Current date
  {BCP_VERSION}  - BCP-Shell version
  {SHELL}        - Shell type
  {PLATFORM}     - Operating system
EOF
    
    echo -e "${GREEN}✓ Banner created: $banner_name${NC}"
    echo -e "${YELLOW}Location: $banner_file${NC}"
    
    # Open for editing
    read -p "Edit banner now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        "${EDITOR:-nano}" "$banner_file"
    fi
    
    # Ask to set as active
    read -p "Set as active banner? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        set_banner "custom/$banner_name"
    fi
}

# Edit banner
edit_banner() {
    local banner_name="$1"
    local banner_file=""
    
    if [[ -z "$banner_name" ]]; then
        echo -e "${RED}Error: Please provide a banner name${NC}"
        echo -e "Usage: bcp-banner edit <name>"
        return 1
    fi
    
    # Find banner file
    if [[ -f "$BANNER_DIR/$banner_name.banner" ]]; then
        banner_file="$BANNER_DIR/$banner_name.banner"
    elif [[ -f "$BANNER_DIR/custom/$banner_name.banner" ]]; then
        banner_file="$BANNER_DIR/custom/$banner_name.banner"
    else
        echo -e "${RED}Error: Banner '$banner_name' not found${NC}"
        return 1
    fi
    
    # Open editor
    echo -e "${CYAN}Editing banner: $banner_name${NC}"
    echo -e "${YELLOW}File: $banner_file${NC}"
    
    "${EDITOR:-nano}" "$banner_file"
    
    echo -e "${GREEN}✓ Banner updated${NC}"
}

# Delete banner
delete_banner() {
    local banner_name="$1"
    
    if [[ -z "$banner_name" ]]; then
        echo -e "${RED}Error: Please provide a banner name${NC}"
        echo -e "Usage: bcp-banner delete <name>"
        return 1
    fi
    
    # Don't allow deleting active banner
    if [[ "$banner_name" == "$BANNER" ]]; then
        echo -e "${RED}Cannot delete active banner!${NC}"
        echo -e "Please select a different banner first:"
        echo -e "  bcp-banner set <other-banner>"
        return 1
    fi
    
    local banner_file=""
    
    # Find and delete
    if [[ -f "$BANNER_DIR/$banner_name.banner" ]]; then
        banner_file="$BANNER_DIR/$banner_name.banner"
        echo -e "${YELLOW}Deleting built-in banner: $banner_name${NC}"
    elif [[ -f "$BANNER_DIR/custom/$banner_name.banner" ]]; then
        banner_file="$BANNER_DIR/custom/$banner_name.banner"
        echo -e "${YELLOW}Deleting custom banner: $banner_name${NC}"
    else
        echo -e "${RED}Error: Banner '$banner_name' not found${NC}"
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
    
    rm -f "$banner_file"
    echo -e "${GREEN}✓ Banner deleted: $banner_name${NC}"
}

# Download banners from repository
download_banners() {
    echo -e "${CYAN}Checking for new banners from repository...${NC}"
    
    # GitHub API URL for banners
    local repo_url="https://api.github.com/repos/cybernahid-dev/bcp-shell/contents/banners"
    local temp_dir="/tmp/bcp-banners-$$"
    
    mkdir -p "$temp_dir"
    
    # Download banner list
    echo -e "${YELLOW}Fetching banner list...${NC}"
    curl -sSL "$repo_url" -o "$temp_dir/banners.json" 2>/dev/null
    
    if [[ ! -f "$temp_dir/banners.json" ]]; then
        echo -e "${RED}Failed to fetch banners${NC}"
        return 1
    fi
    
    # Parse and download
    local downloaded=0
    grep -o '"download_url": "[^"]*"' "$temp_dir/banners.json" | \
    cut -d'"' -f4 | while read url; do
        local filename=$(basename "$url")
        
        # Skip if already exists
        if [[ -f "$BANNER_DIR/$filename" ]]; then
            continue
        fi
        
        echo -e "${BLUE}Downloading: $filename${NC}"
        curl -sSL "$url" -o "$BANNER_DIR/$filename" 2>/dev/null
        
        if [[ -f "$BANNER_DIR/$filename" ]]; then
            echo -e "  ${GREEN}✓ Downloaded${NC}"
            ((downloaded++))
        else
            echo -e "  ${RED}✗ Failed${NC}"
        fi
    done
    
    rm -rf "$temp_dir"
    
    echo -e "\n${CYAN}══════════════════════════════════════════${NC}"
    echo -e "${GREEN}Download complete!${NC}"
    echo -e "${YELLOW}New banners downloaded: $downloaded${NC}"
    echo -e "${CYAN}Use 'bcp-banner list' to see all banners${NC}"
}

# Banner menu
banner_menu() {
    while true; do
        echo -e "\n${CYAN}╔══════════════════════════════════════════╗"
        echo -e "║           BCP Banner Manager           ║"
        echo -e "╠══════════════════════════════════════════╣${NC}"
        echo -e "${YELLOW}Current banner: ${GREEN}$BANNER${NC}"
        echo -e ""
        echo -e "${BLUE}1.${NC} List all banners"
        echo -e "${BLUE}2.${NC} Preview banner"
        echo -e "${BLUE}3.${NC} Set active banner"
        echo -e "${BLUE}4.${NC} Create new banner"
        echo -e "${BLUE}5.${NC} Edit banner"
        echo -e "${BLUE}6.${NC} Delete banner"
        echo -e "${BLUE}7.${NC} Download new banners"
        echo -e "${BLUE}8.${NC} Help"
        echo -e "${BLUE}9.${NC} Exit"
        echo -e "${CYAN}══════════════════════════════════════════${NC}"
        
        read -p $'\n'"${YELLOW}Select option [1-9]: ${NC}" choice
        
        case $choice in
            1)
                list_banners
                ;;
            2)
                read -p "Enter banner name to preview: " name
                preview_banner "$name"
                ;;
            3)
                read -p "Enter banner name to set: " name
                set_banner "$name"
                ;;
            4)
                read -p "Enter name for new banner: " name
                create_banner "$name"
                ;;
            5)
                read -p "Enter banner name to edit: " name
                edit_banner "$name"
                ;;
            6)
                read -p "Enter banner name to delete: " name
                delete_banner "$name"
                ;;
            7)
                download_banners
                ;;
            8)
                echo -e "\n${CYAN}BCP Banner Manager Help:${NC}"
                echo -e "  ${GREEN}bcp-banner list${NC}    - List all banners"
                echo -e "  ${GREEN}bcp-banner set <name>${NC} - Set active banner"
                echo -e "  ${GREEN}bcp-banner create <name>${NC} - Create new banner"
                echo -e "  ${GREEN}bcp-banner edit <name>${NC} - Edit banner"
                echo -e "  ${GREEN}bcp-banner delete <name>${NC} - Delete banner"
                echo -e "  ${GREEN}bcp-banner download${NC} - Download new banners"
                ;;
            9)
                echo -e "${GREEN}Exiting Banner Manager...${NC}"
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
bcp_banner() {
    local command="$1"
    local argument="$2"
    
    case "$command" in
        "list")
            list_banners
            ;;
        "preview")
            preview_banner "$argument"
            ;;
        "set")
            set_banner "$argument"
            ;;
        "create")
            create_banner "$argument"
            ;;
        "edit")
            edit_banner "$argument"
            ;;
        "delete")
            delete_banner "$argument"
            ;;
        "download")
            download_banners
            ;;
        "menu")
            banner_menu
            ;;
        ""|"help")
            echo -e "${CYAN}BCP Banner Manager - Usage:${NC}"
            echo -e "  ${GREEN}bcp-banner list${NC}           - List all banners"
            echo -e "  ${GREEN}bcp-banner preview <name>${NC} - Preview banner"
            echo -e "  ${GREEN}bcp-banner set <name>${NC}     - Set active banner"
            echo -e "  ${GREEN}bcp-banner create <name>${NC}  - Create new banner"
            echo -e "  ${GREEN}bcp-banner edit <name>${NC}    - Edit banner"
            echo -e "  ${GREEN}bcp-banner delete <name>${NC}  - Delete banner"
            echo -e "  ${GREEN}bcp-banner download${NC}       - Download new banners"
            echo -e "  ${GREEN}bcp-banner menu${NC}           - Interactive menu"
            echo -e "  ${GREEN}bcp-banner help${NC}           - Show this help"
            ;;
        *)
            echo -e "${RED}Unknown command: $command${NC}"
            echo -e "Use 'bcp-banner help' for usage"
            return 1
            ;;
    esac
}

# Export function
alias bcp-banner='bcp_banner'
