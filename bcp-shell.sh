#!/data/data/com.termux/files/usr/bin/bash

# BCP-Shell v5.0 - Complete with All Features
# Author: cybernahid-dev
# Team: TeamBCP

==================== CONFIGURATION ====================

BCP_HOME="$HOME/.bcp-shell"
CONFIG_DIR="$BCP_HOME/config"
BANNER_DIR="$BCP_HOME/banners"
THEME_DIR="$BCP_HOME/themes"
CONFIG_FILE="$CONFIG_DIR/user.conf"

# Create directories
mkdir -p "$CONFIG_DIR" "$BANNER_DIR" "$THEME_DIR"

# Load or create config
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    # Default values
    BCP_USER="$(whoami)"
    BCP_DISPLAY="@$(whoami)"
    BCP_TEAM="TeamBCP"
    BCP_STYLE="advanced"
    BCP_THEME="default"
    BCP_BANNER="default"
    BCP_SHOW_BANNER="true"

    # Save to file  
    echo "BCP_USER='$BCP_USER'" > "$CONFIG_FILE"  
    echo "BCP_DISPLAY='$BCP_DISPLAY'" >> "$CONFIG_FILE"  
    echo "BCP_TEAM='$BCP_TEAM'" >> "$CONFIG_FILE"  
    echo "BCP_STYLE='$BCP_STYLE'" >> "$CONFIG_FILE"  
    echo "BCP_THEME='$BCP_THEME'" >> "$CONFIG_FILE"  
    echo "BCP_BANNER='$BCP_BANNER'" >> "$CONFIG_FILE"  
    echo "BCP_SHOW_BANNER='$BCP_SHOW_BANNER'" >> "$CONFIG_FILE"
fi

==================== CREATE DEFAULT BANNERS ONLY (FIXED) ====================

# Default Banner (FIXED)
if [[ ! -f "$BANNER_DIR/default.banner" ]]; then
cat > "$BANNER_DIR/default.banner" << 'EOF'
╔══════════════════════════════════════════╗
║              🚀 TeamBCP Shell 🚀         ║
║           Developed by cybernahid-dev    ║
║                                          ║
║        User: @{USER}                     ║
║        Team: {TEAM}                      ║
║        Time: {TIME}                      ║
║        Host: {HOST}                      ║
╚══════════════════════════════════════════╝
EOF
fi

# Cyber Banner (FIXED WITH CORRECT 'P')
if [[ ! -f "$BANNER_DIR/cyber.banner" ]]; then
cat > "$BANNER_DIR/cyber.banner" << 'EOF'
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
▓                                                                                ▓
▓   ████████╗███████╗ █████╗ ███╗   ███╗██████╗  ██████╗██████╗                 ▓
▓   ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██╔══██╗██╔════╝██╔══██╗                ▓
▓      ██║   █████╗  ███████║██╔████╔██║██████╔╝██║     ██████╔╝                ▓
▓      ██║   ██╔══╝  ██╔══██║██║╚██╔╝██║██╔══██╗██║     ██╔═══╝                 ▓
▓      ██║   ███████╗██║  ██║██║ ╚═╝ ██║██████╔╝╚██████╗██║                     ▓
▓      ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝  ╚═════╝╚═╝                     ▓
▓                                                                                ▓
▓                          User: @{USER}                                         ▓
▓                          Team: {TEAM}                                          ▓
▓                          Host: {HOST}                                          ▓
▓                                                                                ▓
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
EOF
fi

# Minimal Banner
if [[ ! -f "$BANNER_DIR/minimal.banner" ]]; then
cat > "$BANNER_DIR/minimal.banner" << 'EOF'
┌────────────────────────────────────┐
│       {TEAM} - @{USER}             │
│       Shell v5.0                   │
│       {TIME} | {HOST}              │
└────────────────────────────────────┘
EOF
fi

# ASCII Art Banner (This is BCP-Shell's default ASCII banner)
if [[ ! -f "$BANNER_DIR/ascii.banner" ]]; then
cat > "$BANNER_DIR/ascii.banner" << 'EOF'


---

|_   |_ _ __ ___  ___  / | |  |
| |/ _ \ '/ |/ _ \ _ \ | |
| |  / |  _ \  /  ) ||  |
||_||  |/_| |__/ ||

User: @{USER}  
 Team: {TEAM}  
 Time: {TIME}  
 Host: {HOST}

EOF
fi

==================== LOAD THEME FROM EXISTING FILES ====================

load_theme() {
    local theme_file="$THEME_DIR/${BCP_THEME}.theme"

    if [[ -f "$theme_file" ]]; then  
        # থিম ফাইল লোড করুন  
        source "$theme_file"  
          
        # থিম ফাইলে যদি রং ডিফাইন না থাকে, ডিফল্ট সেট করুন  
        if [[ -z "$PROMPT_COLOR" ]]; then PROMPT_COLOR="cyan"; fi  
        if [[ -z "$USER_COLOR" ]]; then USER_COLOR="green"; fi  
        if [[ -z "$TEAM_COLOR" ]]; then TEAM_COLOR="green"; fi  
        if [[ -z "$DIR_COLOR" ]]; then DIR_COLOR="magenta"; fi  
        if [[ -z "$TIME_COLOR" ]]; then TIME_COLOR="blue"; fi  
        if [[ -z "$BANNER_COLOR" ]]; then BANNER_COLOR="cyan"; fi  
    else  
        # থিম ফাইল না থাকলে ডিফল্ট রং সেট করুন  
        echo -e "\033[1;33m⚠️  Theme file not found: $BCP_THEME\033[0m"  
        echo -e "\033[0;36m💡 Available themes: $(ls "$THEME_DIR"/*.theme 2>/dev/null | xargs -n1 basename | sed 's/.theme$//' | tr '\n' ' ')\033[0m"  
          
        # ডিফল্ট রং  
        PROMPT_COLOR="cyan"  
        USER_COLOR="green"  
        TEAM_COLOR="green"  
        DIR_COLOR="magenta"  
        TIME_COLOR="blue"  
        BANNER_COLOR="cyan"  
    fi  
      
    # Convert color names to codes  
    case "$PROMPT_COLOR" in  
        "cyan") PC='\033[0;36m' ;;  
        "green") PC='\033[0;32m' ;;  
        "magenta") PC='\033[0;35m' ;;  
        "gray") PC='\033[0;90m' ;;  
        "red") PC='\033[0;31m' ;;  
        "yellow") PC='\033[1;33m' ;;  
        "blue") PC='\033[0;34m' ;;  
        "white") PC='\033[1;37m' ;;  
        *) PC='\033[0;36m' ;;  
    esac  
      
    case "$USER_COLOR" in  
        "green") UC='\033[0;32m' ;;  
        "yellow") UC='\033[1;33m' ;;  
        "cyan") UC='\033[0;36m' ;;  
        "white") UC='\033[1;37m' ;;  
        "red") UC='\033[0;31m' ;;  
        "magenta") UC='\033[0;35m' ;;  
        "blue") UC='\033[0;34m' ;;  
        *) UC='\033[1;33m' ;;  
    esac  
      
    case "$TEAM_COLOR" in  
        "green") TC='\033[0;32m' ;;  
        "yellow") TC='\033[1;33m' ;;  
        "cyan") TC='\033[0;36m' ;;  
        "white") TC='\033[1;37m' ;;  
        "red") TC='\033[0;31m' ;;  
        "magenta") TC='\033[0;35m' ;;  
        "blue") TC='\033[0;34m' ;;  
        *) TC='\033[0;32m' ;;  
    esac  
      
    case "$DIR_COLOR" in  
        "magenta") DC='\033[0;35m' ;;  
        "cyan") DC='\033[0;36m' ;;  
        "yellow") DC='\033[1;33m' ;;  
        "green") DC='\033[0;32m' ;;  
        "red") DC='\033[0;31m' ;;  
        "blue") DC='\033[0;34m' ;;  
        "white") DC='\033[1;37m' ;;  
        *) DC='\033[0;35m' ;;  
    esac  
      
    case "$TIME_COLOR" in  
        "blue") TiC='\033[0;34m' ;;  
        "red") TiC='\033[0;31m' ;;  
        "cyan") TiC='\033[0;36m' ;;  
        "green") TiC='\033[0;32m' ;;  
        "yellow") TiC='\033[1;33m' ;;  
        "magenta") TiC='\033[0;35m' ;;  
        "white") TiC='\033[1;37m' ;;  
        *) TiC='\033[0;34m' ;;  
    esac  
      
    RST='\033[0m'
}

# Load initial theme
load_theme

==================== SHOW BANNER ====================

show_banner() {
    if [[ "$BCP_SHOW_BANNER" == "true" ]]; then
        local banner_file="$BANNER_DIR/${BCP_BANNER}.banner"

        if [[ -f "$banner_file" ]]; then  
            local banner_content=$(cat "$banner_file")  
              
            # Replace variables  
            banner_content="${banner_content//\{USER\}/$BCP_USER}"  
            banner_content="${banner_content//\{TEAM\}/$BCP_TEAM}"  
            banner_content="${banner_content//\{HOST\}/$(hostname)}"  
            banner_content="${banner_content//\{TIME\}/$(date +'%H:%M:%S')}"  
              
            # Apply banner color  
            case "$BANNER_COLOR" in  
                "cyan") echo -e "\033[0;36m$banner_content\033[0m" ;;  
                "magenta") echo -e "\033[0;35m$banner_content\033[0m" ;;  
                "green") echo -e "\033[0;32m$banner_content\033[0m" ;;  
                "pink") echo -e "\033[1;35m$banner_content\033[0m" ;;  
                "yellow") echo -e "\033[1;33m$banner_content\033[0m" ;;  
                "red") echo -e "\033[0;31m$banner_content\033[0m" ;;  
                "blue") echo -e "\033[0;34m$banner_content\033[0m" ;;  
                "white") echo -e "\033[1;37m$banner_content\033[0m" ;;  
                *) echo -e "\033[0;36m$banner_content\033[0m" ;;  
            esac  
        else  
            # Default banner  
            echo -e "\033[0;36m"  
            echo "╔══════════════════════════════════╗"  
            echo "║         TeamBCP Shell v5.0       ║"  
            echo "║      Developed by cybernahid-dev ║"  
            echo "║         User: $BCP_USER          ║"  
            echo "╚══════════════════════════════════╝"  
            echo -e "\033[0m"  
        fi  
    fi
}

==================== PROMPT SYSTEM ====================

update_prompt() {
    case "$BCP_STYLE" in
        "minimal")
            PS1="${PC}[${TC}${BCP_TEAM}${PC}] ${UC}${BCP_DISPLAY}${PC}:${DC}\w${PC}\$${RST} "
            ;;
        "expert")
            PS1="${PC}╭─[${TC}${BCP_TEAM}${PC}]─[${UC}${BCP_DISPLAY}${PC}]─[${TiC}\t${PC}]\n${PC}╰─[${DC}\w${PC}]»${RST} "
            ;;
        "compact")
            PS1="${PC}[${TC}${BCP_TEAM}${PC}|${UC}${BCP_DISPLAY}${PC}] ${DC}\w${PC} »${RST} "
            ;;
        "classic")
            PS1="${PC}[${TC}${BCP_TEAM}${PC}] ${UC}$(whoami)@$(hostname)${PC}:${DC}\w${PC}\$${RST} "
            ;;
        "advanced"|*)
            PS1="${PC}┌─[${TC}${BCP_TEAM}${PC}]─[${UC}${BCP_DISPLAY}${PC}]─[${TiC}\t${PC}]\n${PC}└──╼${DC} \w ${PC}»${RST} "
            ;;
    esac
}

# Initialize prompt
update_prompt

==================== CORE COMMANDS ====================

bcp-user() {
    if [[ -z "$1" ]]; then
        echo "Usage: bcp-user <username>"
        echo "Example: bcp-user Nahid"
        return 1
    fi

    local new_user="$1"  
      
    # Update config  
    sed -i "s/^BCP_USER=.*/BCP_USER='$new_user'/" "$CONFIG_FILE"  
    sed -i "s/^BCP_DISPLAY=.*/BCP_DISPLAY='@$new_user'/" "$CONFIG_FILE"  
      
    # Reload config  
    source "$CONFIG_FILE"  
      
    # Update prompt  
    update_prompt  
      
    echo -e "\033[0;32m✅ Username changed to: $BCP_USER\033[0m"  
    echo -e "\033[0;36mDisplay: $BCP_DISPLAY\033[0m"
}

bcp-team() {
    if [[ -z "$1" ]]; then
        echo "Usage: bcp-team <team-name>"
        echo "Example: bcp-team BCP"
        return 1
    fi

    local new_team="$1"  
      
    sed -i "s/^BCP_TEAM=.*/BCP_TEAM='$new_team'/" "$CONFIG_FILE"  
    source "$CONFIG_FILE"  
    update_prompt  
      
    echo -e "\033[0;32m✅ Team changed to: $BCP_TEAM\033[0m"
}

bcp-style() {
    local style="$1"

    if [[ -z "$style" ]]; then  
        echo "Available styles: advanced, minimal, expert, compact, classic"  
        echo "Current: $BCP_STYLE"  
        return 0  
    fi  
      
    sed -i "s/^BCP_STYLE=.*/BCP_STYLE='$style'/" "$CONFIG_FILE"  
    source "$CONFIG_FILE"  
    update_prompt  
      
    echo -e "\033[0;32m✅ Style changed to: $BCP_STYLE\033[0m"
}

bcp-theme() {
    local action="$1"
    local theme_name="$2"

    case "$action" in  
        "list")  
            echo "Available themes:"  
            if [[ -d "$THEME_DIR" ]]; then  
                ls "$THEME_DIR"/*.theme 2>/dev/null | xargs -n1 basename | sed 's/.theme$//' | column  
            else  
                echo "No themes directory found"  
            fi  
            echo ""  
            echo "Current theme: $BCP_THEME"  
            ;;  
        "set")  
            if [[ -z "$theme_name" ]]; then  
                echo "Usage: bcp-theme set <theme-name>"  
                return 1  
            fi  
              
            if [[ -f "$THEME_DIR/${theme_name}.theme" ]]; then  
                sed -i "s/^BCP_THEME=.*/BCP_THEME='$theme_name'/" "$CONFIG_FILE"  
                source "$CONFIG_FILE"  
                load_theme  
                update_prompt  
                echo -e "\033[0;32m✅ Theme changed to: $BCP_THEME\033[0m"  
            else  
                echo "Theme not found: $theme_name"  
                echo "Use 'bcp-theme list' to see available themes"  
            fi  
            ;;  
        "info")  
            if [[ -z "$theme_name" ]]; then  
                theme_name="$BCP_THEME"  
            fi  
              
            local theme_file="$THEME_DIR/${theme_name}.theme"  
            if [[ -f "$theme_file" ]]; then  
                echo "Theme: $theme_name"  
                echo "File: $theme_file"  
                echo ""  
                echo "Colors:"  
                source "$theme_file"  
                echo "  Prompt: ${PROMPT_COLOR:-not set}"  
                echo "  User: ${USER_COLOR:-not set}"  
                echo "  Team: ${TEAM_COLOR:-not set}"  
                echo "  Directory: ${DIR_COLOR:-not set}"  
                echo "  Time: ${TIME_COLOR:-not set}"  
                echo "  Banner: ${BANNER_COLOR:-not set}"  
            else  
                echo "Theme not found: $theme_name"  
            fi  
            ;;  
        *)  
            echo "Theme Commands:"  
            echo "  bcp-theme list          - List available themes"  
            echo "  bcp-theme set <name>    - Change theme"  
            echo "  bcp-theme info [name]   - Show theme info"  
            ;;  
    esac
}

bcp-banner() {
    local action="$1"
    local banner_name="$2"

    case "$action" in  
        "list")  
            echo "Available banners:"  
            ls "$BANNER_DIR"/*.banner 2>/dev/null | xargs -n1 basename | sed 's/.banner$//' | column  
            echo ""  
            echo "Current banner: $BCP_BANNER"  
            ;;  
        "set")  
            if [[ -z "$banner_name" ]]; then  
                echo "Usage: bcp-banner set <banner-name>"  
                return 1  
            fi  
              
            if [[ -f "$BANNER_DIR/${banner_name}.banner" ]]; then  
                sed -i "s/^BCP_BANNER=.*/BCP_BANNER='$banner_name'/" "$CONFIG_FILE"  
                source "$CONFIG_FILE"  
                echo -e "\033[0;32m✅ Banner changed to: $BCP_BANNER\033[0m"  
                echo "Banner will show on next terminal start"  
            else  
                echo "Banner not found: $banner_name"  
                echo "Use 'bcp-banner list' to see available banners"  
            fi  
            ;;  
        "toggle")  
            if [[ "$BCP_SHOW_BANNER" == "true" ]]; then  
                sed -i "s/^BCP_SHOW_BANNER=.*/BCP_SHOW_BANNER='false'/" "$CONFIG_FILE"  
                echo "Banner disabled"  
            else  
                sed -i "s/^BCP_SHOW_BANNER=.*/BCP_SHOW_BANNER='true'/" "$CONFIG_FILE"  
                echo "Banner enabled"  
            fi  
            source "$CONFIG_FILE"  
            ;;  
        "preview")  
            if [[ -n "$banner_name" ]]; then  
                BCP_BANNER="$banner_name"  
                show_banner  
            else  
                echo "Usage: bcp-banner preview <banner-name>"  
            fi  
            ;;  
        *)  
            echo "Banner Commands:"  
            echo "  bcp-banner list          - List available banners"  
            echo "  bcp-banner set <name>    - Change banner"  
            echo "  bcp-banner toggle        - Toggle banner on/off"  
            echo "  bcp-banner preview <name> - Preview banner"  
            ;;  
    esac
}

bcp-status() {
    echo -e "\033[0;36m╔══════════════════════════════════════════╗"
    echo "║           BCP-Shell Status v5.0         ║"
    echo "╠══════════════════════════════════════════╣"
    echo "║  Team: $BCP_TEAM"
    echo "║  User: $BCP_USER"
    echo "║  Display: $BCP_DISPLAY"
    echo "║  Style: $BCP_STYLE"
    echo "║  Theme: $BCP_THEME"
    echo "║  Banner: $BCP_BANNER"
    echo "║  Show Banner: $BCP_SHOW_BANNER"
    echo "║  Home: $BCP_HOME"
    echo "║  Themes Dir: $THEME_DIR"
    echo "║  Available Themes: $(ls "$THEME_DIR"/*.theme 2>/dev/null | wc -l)"
    echo "╚══════════════════════════════════════════╝\033[0m"
}

bcp-help() {
    echo -e "\033[0;36m╔══════════════════════════════════════════╗"
    echo "║           BCP-Shell Commands v5.0       ║"
    echo "╠══════════════════════════════════════════╣"
    echo "║  \033[0;32mUser Management:\033[0;36m"
    echo "║    bcp-user <name>    - Change username"
    echo "║    bcp-team <name>    - Change team name"
    echo "║"
    echo "║  \033[1;33mCustomization:\033[0;36m"
    echo "║    bcp-style <style>  - Change prompt style"
    echo "║    bcp-theme list     - List themes"
    echo "║    bcp-theme set <name> - Change theme"
    echo "║    bcp-banner list    - List banners"
    echo "║    bcp-banner set <name> - Change banner"
    echo "║    bcp-banner toggle  - Toggle banner"
    echo "║"
    echo "║  \033[0;35mInfo & Utilities:\033[0;36m"
    echo "║    bcp-status         - Show status"
    echo "║    bcp-config         - Edit config"
    echo "║    bcp-update         - Update shell"
    echo "║    bcp-help           - This help"
    echo "║"
    echo "║  \033[0;34mPrompt Styles:\033[0;36m"
    echo "║    advanced, minimal, expert"
    echo "║    compact, classic"
    echo "║"
    echo "║  \033[0;32mExamples:\033[0;36m"
    echo "║    bcp-user Nahid"
    echo "║    bcp-team TeamBCP"
    echo "║    bcp-style expert"
    echo "║    bcp-theme set cyber"
    echo "║    bcp-banner set cyber"
    echo "╚══════════════════════════════════════════╝\033[0m"
}

bcp-config() {
    nano "$CONFIG_FILE"
    source "$CONFIG_FILE"
    load_theme
    update_prompt
    echo -e "\033[0;32m✅ Configuration reloaded!\033[0m"
}

bcp-update() {
    echo "Updating BCP-Shell..."
    curl -sL https://raw.githubusercontent.com/cybernahid-dev/bcp-shell/main/bcp-shell.sh > "$BCP_HOME/bcp-shell-new.sh"
    if [[ -s "$BCP_HOME/bcp-shell-new.sh" ]]; then
        mv "$BCP_HOME/bcp-shell-new.sh" "$BCP_HOME/bcp-shell.sh"
        chmod +x "$BCP_HOME/bcp-shell.sh"
        echo -e "\033[0;32m✅ Update complete! Restart terminal.\033[0m"
    else
        echo -e "\033[0;31m❌ Update failed!\033[0m"
    fi
}

==================== ALIASES ====================

alias bcp-ver='echo "BCP-Shell v5.0"'
alias bcp-reload='source "$BCP_HOME/bcp-shell.sh"'
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'

==================== STARTUP ====================

show_banner
echo -e "\033[0;32m✅ BCP-Shell v5.0 activated!\033[0m"
echo -e "\033[0;36m💡 Type 'bcp-help' for all commands\033[0m"
echo -e "\033[1;33m🚀 Try: bcp-user Nahid\033[0m"
