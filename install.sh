#!/usr/bin/env bash
# BCP-Shell Ultimate Installer - FINAL FIXED VERSION (NO WELCOME MSG)
# Author: cybernahid-dev
# Team: TeamBCP

set -e

# Configuration
BCP_REPO="https://github.com/cybernahid-dev/bcp-shell"
INSTALL_DIR="$HOME/.bcp-shell"
CONFIG_DIR="$INSTALL_DIR/config"
BANNER_DIR="$INSTALL_DIR/banners"
THEME_DIR="$INSTALL_DIR/themes"
PLUGIN_DIR="$INSTALL_DIR/plugins"
UTIL_DIR="$INSTALL_DIR/utils"
LOG_FILE="$INSTALL_DIR/install.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

# Logging function 
log() {
    mkdir -p "$(dirname "$LOG_FILE")"
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE" 2>/dev/null || echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Banner (UPDATED WITH NEW ASCII ART)
show_install_banner() {
    clear
    echo -e "${CYAN}
╔══════════════════════════════════════════════════════════╗
║  ██████╗  ██████╗██████╗     ███████╗██╗  ██╗███████╗██╗     ██╗     
║  ██╔══██╗██╔════╝██╔══██╗    ██╔════╝██║  ██║██╔════╝██║     ██║     
║  ██████╔╝██║     ██████╔╝    ███████╗███████║█████╗  ██║     ██║     
║  ██╔══██╗██║     ██╔═══╝     ╚════██║██╔══██║██╔══╝  ██║     ██║     
║  ██████╔╝╚██████╗██║         ███████║██║  ██║███████╗███████╗███████╗
║  ╚═════╝  ╚═════╝╚═╝         ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
║                                                                          ║
║                    ${WHITE}🚀 ULTIMATE CUSTOM SHELL 🚀${CYAN}                     ║
║                 ${YELLOW}For TeamBCP - @$(whoami)${CYAN}                        ║
║             ${GREEN}Developed by: cybernahid-dev${CYAN}                         ║
╚══════════════════════════════════════════════════════════╝${NC}
"
}

# Platform detection
detect_platform() {
    if [[ -d "/data/data/com.termux" ]]; then
        echo "termux"
    elif [[ "$(uname)" == "Darwin" ]]; then
        echo "macos"
    elif grep -q Microsoft /proc/version 2>/dev/null; then
        echo "wsl"
    else
        echo "linux"
    fi
}

# Fix Termux repos
fix_termux_repos() {
    if [[ "$PLATFORM" == "termux" ]]; then
        log "Fixing Termux repositories..."
        cp $PREFIX/etc/apt/sources.list $PREFIX/etc/apt/sources.list.bak 2>/dev/null || true
        MIRRORS=(
            "https://packages-cf.termux.org/apt/termux-main"
            "https://grimler.se/termux-packages-24"
            "https://termux.mentality.rip/termux-main"
            "https://mirror.mwt.me/termux/main"
        )
        for mirror in "${MIRRORS[@]}"; do
            echo "deb $mirror stable main" > $PREFIX/etc/apt/sources.list
            if pkg update -y 2>/dev/null; then
                log "Success with mirror: $mirror"
                return 0
            fi
        done
        echo -e "${YELLOW}[!] Using termux-change-repo for manual fix...${NC}"
        termux-change-repo || true
    fi
    return 0
}

# Remove Termux Welcome Message (NEW FUNCTION)
remove_termux_welcome() {
    if [[ "$PLATFORM" == "termux" ]]; then
        log "Removing Termux default welcome message..."
        if [[ -f "$PREFIX/etc/motd" ]]; then
            # Backup original motd just in case
            cp "$PREFIX/etc/motd" "$PREFIX/etc/motd.bak" 2>/dev/null || true
            # Clear the file content
            > "$PREFIX/etc/motd"
            log "Termux welcome message removed."
        fi
    fi
}

# Install dependencies
install_dependencies() {
    log "Installing dependencies for $PLATFORM..."
    case "$PLATFORM" in
        "termux")
            fix_termux_repos
            pkg update -y || true
            pkg install -y git curl wget python python-pip figlet lolcat neofetch nano vim zsh bash || true
            ;;
        "linux")
            sudo apt update -y || true
            sudo apt install -y git curl wget python3 python3-pip figlet lolcat neofetch nano vim zsh bash || true
            ;;
        "macos")
            brew update || true
            brew install git curl wget python figlet lolcat neofetch nano vim zsh bash || true
            ;;
        "wsl")
            sudo apt update -y || true
            sudo apt install -y git curl wget python3 python3-pip figlet lolcat neofetch nano vim zsh bash || true
            ;;
    esac
}

# Cleanup corrupt files
cleanup_corrupt_files() {
    log "Cleaning up corrupt files..."
    if [ -d "$THEME_DIR" ]; then
        shopt -s nullglob
        for theme_file in "$THEME_DIR"/*.theme; do
            if [[ -f "$theme_file" ]]; then
                if head -1 "$theme_file" | grep -q -E "^<|^" || file "$theme_file" | grep -q "HTML"; then
                    log "Removing corrupt theme file: $(basename "$theme_file")"
                    rm -f "$theme_file"
                fi
            fi
        done
        shopt -u nullglob
    fi
}

# Download via curl fallback
download_via_curl() {
    log "Downloading via curl..."
    mkdir -p "$INSTALL_DIR"
    local url="$BCP_REPO/raw/main/bcp-shell.sh"
    local dest="$INSTALL_DIR/bcp-shell.sh"
    curl -sSL "$url" -o "$dest" 2>/dev/null || {
        log "Failed to download main script"
        return 1
    }
}

# Download repository
download_repo() {
    log "Downloading BCP-Shell..."
    mkdir -p "$INSTALL_DIR" "$CONFIG_DIR" "$BANNER_DIR" "$THEME_DIR" "$PLUGIN_DIR" "$UTIL_DIR" "$BANNER_DIR/custom" "$THEME_DIR/custom"
    cleanup_corrupt_files
    if command -v git &>/dev/null; then
        if [[ -d "$INSTALL_DIR/.git" ]]; then
            cd "$INSTALL_DIR"
            git pull origin main 2>/dev/null || true
        else
            git clone "$BCP_REPO" "$INSTALL_DIR" 2>/dev/null || {
                log "Git failed, using curl..."
                download_via_curl
            }
        fi
    else
        download_via_curl
    fi
}

# Create default files
create_default_files() {
    log "Creating default configuration..."
    if [[ ! -f "$CONFIG_DIR/user-config" ]]; then
        cat > "$CONFIG_DIR/user-config" << 'EOF'
# BCP-Shell User Configuration
USER_NAME="$(whoami)"
DISPLAY_NAME="@$(whoami)"
TEAM_NAME="TeamBCP"
PROMPT_STYLE="advanced"
BANNER="default"
THEME="default"
SHOW_BANNER=true
SHOW_TIME=true
AUTO_UPDATE=true
COLOR_MODE="auto"
ANIMATIONS=true
NOTIFICATIONS=true
EOF
    fi
    if [[ ! -f "$THEME_DIR/default.theme" ]]; then
        cat > "$THEME_DIR/default.theme" << 'EOF'
# Default Theme - BCP-Shell v5.0
NAME="Default"
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
EOF
    fi
    cat > "$THEME_DIR/cyberpunk.theme" << 'EOF'
# Cyberpunk Theme
NAME="Cyberpunk"
PROMPT_COLOR="magenta"
USER_COLOR="cyan"
HOST_COLOR="green"
DIR_COLOR="yellow"
TIME_COLOR="red"
GIT_COLOR="white"
SUCCESS_COLOR="green"
ERROR_COLOR="red"
WARNING_COLOR="yellow"
INFO_COLOR="magenta"
BANNER_COLOR="magenta"
ASCII_STYLE="block"
EOF
    cat > "$THEME_DIR/dark.theme" << 'EOF'
# Dark Theme
NAME="Dark"
PROMPT_COLOR="gray"
USER_COLOR="white"
HOST_COLOR="yellow"
DIR_COLOR="cyan"
TIME_COLOR="blue"
GIT_COLOR="white"
SUCCESS_COLOR="green"
ERROR_COLOR="red"
WARNING_COLOR="yellow"
INFO_COLOR="cyan"
BANNER_COLOR="cyan"
ASCII_STYLE="minimal"
EOF
    cat > "$THEME_DIR/neon.theme" << 'EOF'
# Neon Theme
NAME="Neon"
PROMPT_COLOR="cyan"
USER_COLOR="green"
HOST_COLOR="yellow"
DIR_COLOR="magenta"
TIME_COLOR="blue"
GIT_COLOR="white"
SUCCESS_COLOR="green"
ERROR_COLOR="red"
WARNING_COLOR="yellow"
INFO_COLOR="pink"
BANNER_COLOR="pink"
ASCII_STYLE="neon"
EOF
    if [[ ! -f "$BANNER_DIR/default.banner" ]]; then
        cat > "$BANNER_DIR/default.banner" << 'EOF'
╔═══════════════════════════════════════════════════╗
║                🚀 TeamBCP Shell 🚀                ║
║         Developed by: cybernahid-dev              ║
║             User: @{USER_NAME}                    ║
║             Time: {TIME}                          ║
║             Host: {HOSTNAME}                      ║
║             Shell: BCP-Shell v{BCP_VERSION}       ║
╚═══════════════════════════════════════════════════╝
EOF
    fi
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
▓                          User: @{USER_NAME}                                    ▓
▓                          Host: {HOSTNAME}                                      ▓
▓                          Time: {TIME}                                          ▓
▓                                                                                ▓
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
EOF
    fi
    cat > "$BANNER_DIR/minimal.banner" << 'EOF'
┌────────────────────────────────────┐
│       {TEAM_NAME} - @{USER_NAME}   │
│       Shell v{BCP_VERSION}         │
│       {TIME} | {HOSTNAME}          │
└────────────────────────────────────┘
EOF
    cat > "$BANNER_DIR/ascii.banner" << 'EOF'
  _____                    ____   _____ 
 |_   _|__ _ __ ___  ___  / ___| |  ___|
   | |/ _ \ '__/ __|/ _ \ \___ \ | |_   
   | |  __/ |  \__ \  __/  ___) ||  _|  
   |_|\___|_|  |___/\___| |____/ |_|    
                                       
     User: @{USER_NAME}
     Team: {TEAM_NAME}
     Time: {TIME}
     Host: {HOSTNAME}
EOF
}

# Configure shell
configure_shell() {
    log "Configuring shell..."
    local shell_rc=""
    case "$SHELL" in
        */bash) shell_rc="$HOME/.bashrc" ;;
        */zsh) shell_rc="$HOME/.zshrc" ;;
        *) shell_rc="$HOME/.bashrc" ;;
    esac
    cp "$shell_rc" "${shell_rc}.bcp-backup" 2>/dev/null || true
    if ! grep -q "BCP-Shell" "$shell_rc" 2>/dev/null; then
        cat >> "$shell_rc" << 'EOF'

# ============================================
# BCP-Shell (TeamBCP) - Ultimate Custom Shell
# ============================================
export BCP_SHELL_HOME="$HOME/.bcp-shell"
export BCP_VERSION="5.0.0"

# Load BCP-Shell
if [ -f "$BCP_SHELL_HOME/bcp-shell.sh" ]; then
    source "$BCP_SHELL_HOME/bcp-shell.sh"
fi
EOF
    fi
    if [[ -f "$HOME/.profile" ]] && ! grep -q "BCP-Shell" "$HOME/.profile" 2>/dev/null; then
        echo -e "\n# BCP-Shell\n[ -f \"\$HOME/.bcp-shell/bcp-shell.sh\" ] && source \"\$HOME/.bcp-shell/bcp-shell.sh\"" >> "$HOME/.profile"
    fi
}

# Set permissions
set_permissions() {
    log "Setting permissions..."
    if [[ -f "$INSTALL_DIR/bcp-shell.sh" ]]; then
        chmod +x "$INSTALL_DIR/bcp-shell.sh"
    fi
    if ls "$THEME_DIR"/*.theme >/dev/null 2>&1; then
        chmod 644 "$THEME_DIR"/*.theme
    fi
    if ls "$BANNER_DIR"/*.banner >/dev/null 2>&1; then
        chmod 644 "$BANNER_DIR"/*.banner
    fi
    if [[ -f "$CONFIG_DIR/user-config" ]]; then
        chmod 644 "$CONFIG_DIR/user-config"
    fi
}

# Final setup
final_setup() {
    log "Finalizing installation..."
    cat > "$INSTALL_DIR/update.sh" << 'EOF'
#!/usr/bin/env bash
# BCP-Shell Updater
BCP_HOME="$HOME/.bcp-shell"
echo "Updating BCP-Shell..."
if command -v git &>/dev/null && [ -d "$BCP_HOME/.git" ]; then
    cd "$BCP_HOME"
    git pull origin main
else
    curl -sSL "https://raw.githubusercontent.com/cybernahid-dev/bcp-shell/main/bcp-shell.sh" -o "$BCP_HOME/bcp-shell-new.sh"
    if [ -s "$BCP_HOME/bcp-shell-new.sh" ]; then
        mv "$BCP_HOME/bcp-shell-new.sh" "$BCP_HOME/bcp-shell.sh"
        chmod +x "$BCP_HOME/bcp-shell.sh"
        echo "✅ Update complete!"
    else
        echo "❌ Update failed!"
    fi
fi
echo "Please restart your terminal for changes to take effect."
EOF
    chmod +x "$INSTALL_DIR/update.sh"
    
    cat > "$INSTALL_DIR/repair.sh" << 'EOF'
#!/usr/bin/env bash
# BCP-Shell Repair Script
echo "🔧 Repairing BCP-Shell installation..."
find "$HOME/.bcp-shell/themes" -name "*.theme" -type f -exec sh -c '
    for file do
        if head -1 "$file" | grep -q -E "^<|^" || file "$file" | grep -q "HTML"; then
            echo "Removing corrupt file: $file"
            rm -f "$file"
        fi
    done
' sh {} +
if [ ! -f "$HOME/.bcp-shell/themes/default.theme" ]; then
    echo "Recreating default theme..."
    cat > "$HOME/.bcp-shell/themes/default.theme" << 'THEME_EOF'
# Default Theme - BCP-Shell v5.0
NAME="Default"
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
THEME_EOF
fi
echo "✅ Repair complete!"
echo "Run: source ~/.bashrc"
EOF
    chmod +x "$INSTALL_DIR/repair.sh"
}

# Show success message
show_success() {
    clear
    echo -e "${GREEN}
╔══════════════════════════════════════════════════════════╗
║                    INSTALLATION COMPLETE!                ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║  ${CYAN}✅ BCP-Shell successfully installed!${GREEN}                 ║
║                                                          ║
║  ${YELLOW}📌 Quick Commands:${GREEN}                                    ║
║     ${WHITE}• bcp-status${GREEN}     - Show shell status                ║
║     ${WHITE}• bcp-config${GREEN}     - Configure shell                  ║
║     ${WHITE}• bcp-banner${GREEN}     - Change banner                    ║
║     ${WHITE}• bcp-theme${GREEN}      - Change theme                     ║
║     ${WHITE}• bcp-user${GREEN}       - Change username                  ║
║     ${WHITE}• bcp-update${GREEN}     - Update shell                     ║
║     ${WHITE}• bcp-repair${GREEN}     - Repair installation              ║
║                                                          ║
║  ${YELLOW}📌 Your Prompt:${GREEN}                                       ║
║     ${CYAN}TeamBCP - @$(whoami)${GREEN}                                ║
║                                                          ║
║  ${YELLOW}📌 Note:${GREEN}                                              ║
║     Termux Default Message has been removed!             ║
║                                                          ║
║  ${MAGENTA}💻 Developed for TeamBCP by cybernahid-dev${GREEN}           ║
╚══════════════════════════════════════════════════════════╝${NC}
"
    
    echo -e "\n${YELLOW}[*] Installation log: $LOG_FILE${NC}"
    echo -e "${YELLOW}[*] Available themes: default, cyberpunk, dark, neon${NC}"
    echo -e "${YELLOW}[*] Available banners: default, cyber, minimal, ascii${NC}"
    
    if [[ -f "$INSTALL_DIR/bcp-shell.sh" ]]; then
        echo -e "\n${CYAN}[*] Loading BCP-Shell now...${NC}"
        source "$INSTALL_DIR/bcp-shell.sh" 2>/dev/null || true
    fi
    
    echo -e "\n${GREEN}✅ Ready! Type 'bcp-help' to see all commands.${NC}"
}

# Main installation
main() {
    show_install_banner
    PLATFORM=$(detect_platform)
    
    echo -e "${YELLOW}[*] Platform: $PLATFORM${NC}"
    echo -e "${YELLOW}[*] Installing BCP-Shell v5.0...${NC}"
    
    install_dependencies
    mkdir -p "$INSTALL_DIR" "$CONFIG_DIR" "$BANNER_DIR" "$THEME_DIR" "$PLUGIN_DIR" "$UTIL_DIR"
    
    download_repo
    create_default_files
    configure_shell
    set_permissions
    
    # NEW: Remove Termux Welcome Message
    remove_termux_welcome
    
    final_setup
    show_success
}

main "$@"

