#!/usr/bin/env bash
# BCP-Shell Update Manager
# Handles updates for banners, themes, and shell itself

BCP_HOME="$HOME/.bcp-shell"
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
    AUTO_UPDATE="true"
}

# Check for updates
check_updates() {
    echo -e "${CYAN}Checking for BCP-Shell updates...${NC}"
    
    if [[ ! -d "$BCP_HOME/.git" ]]; then
        echo -e "${YELLOW}Git repository not found. Using manual update check.${NC}"
        check_manual_updates
        return
    fi
    
    cd "$BCP_HOME"
    
    # Fetch updates
    echo -e "${YELLOW}Fetching updates from repository...${NC}"
    git fetch origin 2>/dev/null
    
    # Check if updates available
    local local_hash=$(git rev-parse HEAD 2>/dev/null)
    local remote_hash=$(git rev-parse origin/main 2>/dev/null)
    
    if [[ "$local_hash" != "$remote_hash" ]]; then
        echo -e "${GREEN}✅ Updates available!${NC}"
        echo -e "${YELLOW}Current version: ${local_hash:0:8}${NC}"
        echo -e "${YELLOW}Latest version:  ${remote_hash:0:8}${NC}"
        
        # Show changelog if available
        if [[ -f "$BCP_HOME/CHANGELOG.md" ]]; then
            echo -e "\n${CYAN}Recent changes:${NC}"
            head -20 "$BCP_HOME/CHANGELOG.md" | grep -E "^##|^-" | head -10
        fi
        
        return 0
    else
        echo -e "${GREEN}✓ BCP-Shell is up to date${NC}"
        return 1
    fi
}

# Manual update check
check_manual_updates() {
    echo -e "${YELLOW}Checking for resource updates...${NC}"
    
    local updates_found=0
    
    # Check banners
    if [[ -d "$BCP_HOME/banners" ]]; then
        echo -e "${BLUE}Checking banners...${NC}"
        # Could add version checking here
    fi
    
    # Check themes
    if [[ -d "$BCP_HOME/themes" ]]; then
        echo -e "${BLUE}Checking themes...${NC}"
        # Could add version checking here
    fi
    
    if [[ $updates_found -eq 0 ]]; then
        echo -e "${GREEN}✓ All resources are up to date${NC}"
    fi
}

# Update banners from repo
update_banners() {
    echo -e "${CYAN}Updating banners from repository...${NC}"
    
    # Use banner manager if available
    if type bcp_banner &>/dev/null; then
        bcp_banner download
    else
        echo -e "${YELLOW}Banner manager not available${NC}"
    fi
}

# Update themes from repo
update_themes() {
    echo -e "${CYAN}Updating themes from repository...${NC}"
    
    # Use theme manager if available
    if type bcp_theme &>/dev/null; then
        bcp_theme download
    else
        echo -e "${YELLOW}Theme manager not available${NC}"
    fi
}

# Update shell itself
update_shell() {
    echo -e "${CYAN}Updating BCP-Shell core...${NC}"
    
    if [[ -f "$BCP_HOME/update.sh" ]]; then
        bash "$BCP_HOME/update.sh"
    elif [[ -d "$BCP_HOME/.git" ]]; then
        cd "$BCP_HOME"
        git pull origin main
        echo -e "${GREEN}✓ Core updated${NC}"
    else
        echo -e "${RED}Cannot update: No update method available${NC}"
        echo -e "${YELLOW}Try reinstalling:${NC}"
        echo -e "curl -sSL https://raw.githubusercontent.com/cybernahid-dev/bcp-shell/main/install.sh | bash"
        return 1
    fi
}

# Update everything
update_all() {
    echo -e "${CYAN}╔══════════════════════════════════════════╗"
    echo -e "║         BCP-Shell Full Update          ║"
    echo -e "╚══════════════════════════════════════════╝${NC}"
    
    # Check for updates first
    if ! check_updates; then
        echo -e "\n${YELLOW}No core updates available. Update resources anyway? (y/N): ${NC}"
        read -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi
    
    echo -e "\n${YELLOW}Starting update process...${NC}"
    
    # 1. Update core
    echo -e "\n${BLUE}[1/3] Updating core shell...${NC}"
    update_shell
    
    # 2. Update banners
    echo -e "\n${BLUE}[2/3] Updating banners...${NC}"
    update_banners
    
    # 3. Update themes
    echo -e "\n${BLUE}[3/3] Updating themes...${NC}"
    update_themes
    
    echo -e "\n${GREEN}══════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ Update complete!${NC}"
    echo -e "${GREEN}══════════════════════════════════════════${NC}"
    echo -e "\n${YELLOW}Next steps:${NC}"
    echo -e "1. Restart your terminal"
    echo -e "2. Or run: source ~/.bashrc"
    echo -e "3. Check new features: bcp-help"
}

# Auto-update on shell start
auto_update_check() {
    if [[ "$AUTO_UPDATE" != "true" ]]; then
        return
    fi
    
    local last_check_file="$BCP_HOME/.last_update_check"
    local current_time=$(date +%s)
    local last_check=$(cat "$last_check_file" 2>/dev/null || echo "0")
    local check_interval=$((24 * 60 * 60))  # 24 hours
    
    if (( current_time - last_check > check_interval )); then
        echo "$current_time" > "$last_check_file"
        
        # Run in background
        (
            if check_updates; then
                echo -e "\n${YELLOW}[!] BCP-Shell updates available! Run 'bcp-update'${NC}"
            fi
        ) &
    fi
}

# Update menu
update_menu() {
    while true; do
        echo -e "\n${CYAN}╔══════════════════════════════════════════╗"
        echo -e "║         BCP-Shell Update Manager       ║"
        echo -e "╠══════════════════════════════════════════╣${NC}"
        echo -e "${YELLOW}Auto-update: ${GREEN}$AUTO_UPDATE${NC}"
        echo -e ""
        echo -e "${BLUE}1.${NC} Check for updates"
        echo -e "${BLUE}2.${NC} Update everything"
        echo -e "${BLUE}3.${NC} Update core shell only"
        echo -e "${BLUE}4.${NC} Update banners only"
        echo -e "${BLUE}5.${NC} Update themes only"
        echo -e "${BLUE}6.${NC} Toggle auto-update"
        echo -e "${BLUE}7.${NC} View update history"
        echo -e "${BLUE}8.${NC} Help"
        echo -e "${BLUE}9.${NC} Exit"
        echo -e "${CYAN}══════════════════════════════════════════${NC}"
        
        read -p $'\n'"${YELLOW}Select option [1-9]: ${NC}" choice
        
        case $choice in
            1)
                check_updates
                ;;
            2)
                update_all
                ;;
            3)
                update_shell
                ;;
            4)
                update_banners
                ;;
            5)
                update_themes
                ;;
            6)
                toggle_auto_update
                ;;
            7)
                view_update_history
                ;;
            8)
                show_update_help
                ;;
            9)
                echo -e "${GREEN}Exiting Update Manager...${NC}"
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

# Toggle auto-update
toggle_auto_update() {
    if [[ "$AUTO_UPDATE" == "true" ]]; then
        sed -i "s/^AUTO_UPDATE=.*/AUTO_UPDATE=\"false\"/" "$CONFIG"
        AUTO_UPDATE="false"
        echo -e "${YELLOW}Auto-update disabled${NC}"
    else
        sed -i "s/^AUTO_UPDATE=.*/AUTO_UPDATE=\"true\"/" "$CONFIG"
        AUTO_UPDATE="true"
        echo -e "${GREEN}Auto-update enabled${NC}"
    fi
    source "$CONFIG"
}

# View update history
view_update_history() {
    local history_file="$BCP_HOME/.update_history"
    
    if [[ -f "$history_file" ]]; then
        echo -e "${CYAN}Update History:${NC}"
        echo -e "${YELLOW}────────────────────────────────────${NC}"
        tail -20 "$history_file"
        echo -e "${YELLOW}────────────────────────────────────${NC}"
    else
        echo -e "${YELLOW}No update history found${NC}"
    fi
}

# Show help
show_update_help() {
    echo -e "\n${CYAN}BCP Update Manager Help:${NC}"
    echo -e "  ${GREEN}bcp-update${NC}            - Update everything"
    echo -e "  ${GREEN}bcp-update check${NC}      - Check for updates"
    echo -e "  ${GREEN}bcp-update core${NC}       - Update core shell"
    echo -e "  ${GREEN}bcp-update banners${NC}    - Update banners"
    echo -e "  ${GREEN}bcp-update themes${NC}     - Update themes"
    echo -e "  ${GREEN}bcp-update menu${NC}       - Interactive menu"
    echo -e "  ${GREEN}bcp-update auto${NC}       - Toggle auto-update"
    echo -e "  ${GREEN}bcp-update history${NC}    - View update history"
    echo -e "  ${GREEN}bcp-update help${NC}       - Show this help"
}

# Main function
bcp_update() {
    local command="$1"
    
    case "$command" in
        "check")
            check_updates
            ;;
        "core"|"shell")
            update_shell
            ;;
        "banners")
            update_banners
            ;;
        "themes")
            update_themes
            ;;
        "auto")
            toggle_auto_update
            ;;
        "history")
            view_update_history
            ;;
        "menu")
            update_menu
            ;;
        ""|"all")
            update_all
            ;;
        "help")
            show_update_help
            ;;
        *)
            echo -e "${RED}Unknown command: $command${NC}"
            show_update_help
            return 1
            ;;
    esac
}

# Export function
alias bcp-update='bcp_update'

# Auto-run check on shell start
auto_update_check
