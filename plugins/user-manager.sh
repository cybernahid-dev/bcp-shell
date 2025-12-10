#!/usr/bin/env bash
# BCP-Shell User Manager
# Allows users to easily change username and display settings

BCP_HOME="$HOME/.bcp-shell"
BCP_CONFIG="$BCP_HOME/config/user-config"

bcp-user-menu() {
    echo -e "\033[1;36m╔══════════════════════════════════════╗"
    echo -e "║         USER CONFIGURATION         ║"
    echo -e "╚══════════════════════════════════════╝\033[0m"
    
    echo -e "\n\033[1;33mCurrent Settings:\033[0m"
    echo -e "  Username: \033[1;32m$USER_NAME\033[0m"
    echo -e "  Display: \033[1;32m$DISPLAY_NAME\033[0m"
    echo -e "  Team: \033[1;32m$TEAM_NAME\033[0m"
    
    echo -e "\n\033[1;33mOptions:\033[0m"
    echo -e "  1. Change Username"
    echo -e "  2. Change Display Name"
    echo -e "  3. Change Team Name"
    echo -e "  4. Reset to Default"
    echo -e "  5. Show Current"
    echo -e "  6. Exit"
    
    read -p $'\n\033[1;36mSelect option [1-6]: \033[0m' choice
    
    case $choice in
        1)
            read -p "Enter new username: " new_user
            if [[ -n "$new_user" ]]; then
                sed -i "s/^USER_NAME=.*/USER_NAME=\"$new_user\"/" "$BCP_CONFIG"
                echo -e "\033[1;32m✓ Username changed to: $new_user\033[0m"
            fi
            ;;
        2)
            read -p "Enter display name (with @): " display_name
            if [[ -n "$display_name" ]]; then
                sed -i "s/^DISPLAY_NAME=.*/DISPLAY_NAME=\"$display_name\"/" "$BCP_CONFIG"
                echo -e "\033[1;32m✓ Display name changed to: $display_name\033[0m"
            fi
            ;;
        3)
            read -p "Enter team name: " team_name
            if [[ -n "$team_name" ]]; then
                sed -i "s/^TEAM_NAME=.*/TEAM_NAME=\"$team_name\"/" "$BCP_CONFIG"
                echo -e "\033[1;32m✓ Team name changed to: $team_name\033[0m"
            fi
            ;;
        4)
            cp "$BCP_HOME/config/default-user-config" "$BCP_CONFIG" 2>/dev/null || {
                cat > "$BCP_CONFIG" << EOF
USER_NAME="$(whoami)"
DISPLAY_NAME="@$(whoami)"
TEAM_NAME="TeamBCP"
EOF
            }
            echo -e "\033[1;32m✓ Reset to default settings\033[0m"
            ;;
        5)
            echo -e "\n\033[1;36mCurrent Configuration:\033[0m"
            cat "$BCP_CONFIG" | grep -E "^(USER_NAME|DISPLAY_NAME|TEAM_NAME)="
            ;;
        6)
            echo "Exiting..."
            return 0
            ;;
        *)
            echo -e "\033[1;31mInvalid option\033[0m"
            ;;
    esac
    
    # Reload config
    source "$BCP_CONFIG"
    echo -e "\n\033[1;33mConfiguration reloaded! Restart terminal or run:\033[0m"
    echo -e "\033[1;36msource ~/.bashrc\033[0m"
}

# Alias for menu
alias bcp-user-menu='bcp-user-menu'
