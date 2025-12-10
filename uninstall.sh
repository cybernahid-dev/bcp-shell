#!/usr/bin/env bash
# BCP-Shell Uninstaller

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}
╔══════════════════════════════════════╗
║        BCP-Shell Uninstaller         ║
╚══════════════════════════════════════╝${NC}"

echo -e "\n${YELLOW}This will remove BCP-Shell and restore your original shell configuration.${NC}"

read -p "Are you sure? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Uninstall cancelled.${NC}"
    exit 0
fi

echo -e "\n${YELLOW}[1] Removing from shell configuration...${NC}"

# Remove from bashrc
if [[ -f ~/.bashrc ]]; then
    sed -i '/BCP-Shell/,/# ============================================/d' ~/.bashrc
    echo "✓ Removed from ~/.bashrc"
fi

# Remove from zshrc
if [[ -f ~/.zshrc ]]; then
    sed -i '/BCP-Shell/,/# ============================================/d' ~/.zshrc
    echo "✓ Removed from ~/.zshrc"
fi

# Remove from profile
if [[ -f ~/.profile ]]; then
    sed -i '/BCP-Shell/d' ~/.profile
    echo "✓ Removed from ~/.profile"
fi

echo -e "\n${YELLOW}[2] Removing BCP-Shell files...${NC}"

# Remove installation directory
if [[ -d ~/.bcp-shell ]]; then
    # Backup user config if requested
    read -p "Backup your configuration? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp -r ~/.bcp-shell ~/.bcp-shell-backup
        echo "✓ Configuration backed up to ~/.bcp-shell-backup"
    fi
    
    rm -rf ~/.bcp-shell
    echo "✓ Removed ~/.bcp-shell"
fi

# Restore backup if exists
if [[ -f ~/.bashrc.bcp-backup ]]; then
    cp ~/.bashrc.bcp-backup ~/.bashrc
    echo "✓ Restored ~/.bashrc from backup"
fi

if [[ -f ~/.zshrc.bcp-backup ]]; then
    cp ~/.zshrc.bcp-backup ~/.zshrc
    echo "✓ Restored ~/.zshrc from backup"
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✅ BCP-Shell successfully uninstalled!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\n${YELLOW}Please restart your terminal.${NC}"
