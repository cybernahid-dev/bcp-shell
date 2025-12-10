#!/usr/bin/env bash
# BCP-Shell Ultimate Installer
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
    # Ensure log directory exists
    mkdir -p "$(dirname "$LOG_FILE")"
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE" 2>/dev/null || echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Banner
show_install_banner() {
    clear
    echo -e "${CYAN}
╔══════════════════════════════════════════════════════════╗
║  ██████╗  ██████╗██████╗    ███████╗ ██████╗██╗  ██╗███████╗██╗     ██╗
║  ██╔══██╗██╔════╝██╔══██╗   ██╔════╝██╔════╝██║  ██║██╔════╝██║     ██║
║  ██████╔╝██║     ██████╔╝   ███████╗██║     ███████║█████╗  ██║     ██║
║  ██╔══██╗██║     ██╔═══╝    ╚════██║██║     ██╔══██║██╔══╝  ██║     ██║
║  ██████╔╝╚██████╗██║        ███████║╚██████╗██║  ██║███████╗███████╗███████╗
║  ╚═════╝  ╚═════╝╚═╝        ╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
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
        
        # Backup current sources
        cp $PREFIX/etc/apt/sources.list $PREFIX/etc/apt/sources.list.bak 2>/dev/null || true
        
        # Try multiple mirrors
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
        
        # Use termux-change-repo as fallback
        echo -e "${YELLOW}[!] Using termux-change-repo for manual fix...${NC}"
        termux-change-repo || true
    fi
    return 0
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

# Download repository
download_repo() {
    log "Downloading BCP-Shell..."
    
    # Create directory structure
    mkdir -p "$INSTALL_DIR" "$CONFIG_DIR" "$BANNER_DIR" "$THEME_DIR" "$PLUGIN_DIR" "$UTIL_DIR" "$BANNER_DIR/custom" "$THEME_DIR/custom"
    
    # Download using git or curl
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

# Download via curl fallback
download_via_curl() {
    log "Downloading via curl..."
    
    # Create basic structure
    mkdir -p "$INSTALL_DIR"
    
    # Download individual files
    FILES=(
        "bcp-shell.sh"
        "config/user-config"
        "config/default-theme"
        "banners/default.banner"
        "themes/default.theme"
        "plugins/banner-manager.sh"
        "plugins/theme-manager.sh"
        "plugins/user-manager.sh"
        "utils/banner-generator.py"
    )
    
    for file in "${FILES[@]}"; do
        local url="$BCP_REPO/raw/main/$file"
        local dest="$INSTALL_DIR/$file"
        mkdir -p "$(dirname "$dest")"
        curl -sSL "$url" -o "$dest" 2>/dev/null || true
    done
}

# Create default files
create_default_files() {
    log "Creating default configuration..."
    
    # User config
    if [[ ! -f "$CONFIG_DIR/user-config" ]]; then
        cat > "$CONFIG_DIR/user-config" << EOF
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
    
    # Default theme
    if [[ ! -f "$THEME_DIR/default.theme" ]]; then
        cat > "$THEME_DIR/default.theme" << EOF
# Default Theme
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
    
    # Default banner
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
    
    # Cyber banner
    cat > "$BANNER_DIR/cyber.banner" << 'EOF'
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
▓                                                                                ▓
▓   ████████╗███████╗ █████╗ ███╗   ███╗██████╗  ██████╗██████╗                 ▓
▓   ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██╔══██╗██╔════╝██╔══██╗                ▓
▓      ██║   █████╗  ███████║██╔████╔██║██████╔╝██║     ██████╔╝                ▓
▓      ██║   ██╔══╝  ██╔══██║██║╚██╔╝██║██╔══██╗██║     ██╔══██╗                ▓
▓      ██║   ███████╗██║  ██║██║ ╚═╝ ██║██████╔╝╚██████╗██║  ██║                ▓
▓      ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝  ╚═════╝╚═╝  ╚═╝                ▓
▓                                                                                ▓
▓                          User: @{USER_NAME}                                    ▓
▓                          Host: {HOSTNAME}                                      ▓
▓                          Time: {TIME}                                          ▓
▓                                                                                ▓
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
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
    
    # Backup
    cp "$shell_rc" "${shell_rc}.bcp-backup" 2>/dev/null || true
    
    # Add BCP-Shell
    if ! grep -q "BCP-Shell" "$shell_rc" 2>/dev/null; then
        cat >> "$shell_rc" << EOF

# ============================================
# BCP-Shell (TeamBCP) - $(date)
# ============================================
export BCP_SHELL_HOME="$INSTALL_DIR"
export BCP_VERSION="2.0.0"

# Load BCP-Shell
if [ -f "\$BCP_SHELL_HOME/bcp-shell.sh" ]; then
    source "\$BCP_SHELL_HOME/bcp-shell.sh"
fi
EOF
    fi
    
    # Also add to .profile for login shells
    if [[ -f "$HOME/.profile" ]] && ! grep -q "BCP-Shell" "$HOME/.profile" 2>/dev/null; then
        echo -e "\n# BCP-Shell\n[ -f \"\$HOME/.bcp-shell/bcp-shell.sh\" ] && source \"\$HOME/.bcp-shell/bcp-shell.sh\"" >> "$HOME/.profile"
    fi
}

# Set permissions
set_permissions() {
    log "Setting permissions..."
    
    chmod +x "$INSTALL_DIR/bcp-shell.sh" 2>/dev/null || true
    chmod +x "$INSTALL_DIR"/plugins/*.sh 2>/dev/null || true
    chmod +x "$INSTALL_DIR"/utils/*.sh 2>/dev/null || true
    chmod +x "$INSTALL_DIR"/utils/*.py 2>/dev/null || true
    
    # Make utils executable
    find "$INSTALL_DIR/utils" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    find "$INSTALL_DIR/utils" -type f -name "*.py" -exec chmod +x {} \; 2>/dev/null || true
}

# Final setup
final_setup() {
    log "Finalizing installation..."
    
    # Create update script
    cat > "$INSTALL_DIR/update.sh" << 'EOF'
#!/usr/bin/env bash
# BCP-Shell Updater

BCP_HOME="$HOME/.bcp-shell"
cd "$BCP_HOME"

echo "Updating BCP-Shell..."
if command -v git &>/dev/null && [ -d "$BCP_HOME/.git" ]; then
    git pull origin main
else
    curl -sSL "https://raw.githubusercontent.com/cybernahid-dev/bcp-shell/main/update.sh" | bash
fi

echo "Update complete! Restart your terminal."
EOF
    
    chmod +x "$INSTALL_DIR/update.sh"
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
║                                                          ║
║  ${YELLOW}📌 Your Prompt:${GREEN}                                       ║
║     ${CYAN}TeamBCP - @$(whoami)${GREEN}                                ║
║                                                          ║
║  ${YELLOW}📌 Next Steps:${GREEN}                                        ║
║     1. Restart terminal or run:                         ║
║        ${WHITE}source ~/.bashrc${GREEN} (or source ~/.zshrc)           ║
║     2. Customize with: ${WHITE}bcp-config${GREEN}                      ║
║     3. Choose banner: ${WHITE}bcp-banner list${GREEN}                  ║
║                                                          ║
║  ${MAGENTA}💻 Developed for TeamBCP by cybernahid-dev${GREEN}           ║
╚══════════════════════════════════════════════════════════╝${NC}
"
    
    echo -e "\n${YELLOW}[*] Installation log: $LOG_FILE${NC}"
    
    # Auto-load if possible
    if [[ -f "$INSTALL_DIR/bcp-shell.sh" ]]; then
        echo -e "\n${CYAN}[*] Loading BCP-Shell now...${NC}"
        source "$INSTALL_DIR/bcp-shell.sh"
    fi
}

# Main installation
main() {
    show_install_banner
    PLATFORM=$(detect_platform)
    
    echo -e "${YELLOW}[*] Platform: $PLATFORM${NC}"
    echo -e "${YELLOW}[*] Installing BCP-Shell...${NC}"
    
    install_dependencies
    download_repo
    create_default_files
    configure_shell
    set_permissions
    final_setup
    show_success
}

# Run
main "$@"
