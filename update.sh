#!/usr/bin/env bash
# BCP-Shell Auto Updater

BCP_HOME="$HOME/.bcp-shell"
LOG_FILE="$BCP_HOME/update.log"

echo "Updating BCP-Shell..."
echo "====================="

# Backup current config
backup_config() {
    echo "[1] Backing up configuration..."
    cp "$BCP_HOME/config/user-config" "$BCP_HOME/config/user-config.backup" 2>/dev/null || true
    echo "✓ Configuration backed up"
}

# Update from git
update_from_git() {
    echo "[2] Updating from GitHub..."
    cd "$BCP_HOME"
    
    if command -v git &>/dev/null && [ -d "$BCP_HOME/.git" ]; then
        git fetch origin
        git pull origin main
        echo "✓ Git update completed"
        return 0
    else
        echo "! Git not available, using curl"
        return 1
    fi
}

# Update via curl
update_via_curl() {
    echo "[3] Updating via curl..."
    
    # Download update script
    curl -sSL "https://raw.githubusercontent.com/cybernahid-dev/bcp-shell/main/update-files.sh" -o /tmp/bcp-update.sh
    bash /tmp/bcp-update.sh
}

# Restore config
restore_config() {
    echo "[4] Restoring configuration..."
    
    if [ -f "$BCP_HOME/config/user-config.backup" ]; then
        # Merge old config with new
        while IFS='=' read -r key value; do
            if [[ ! "$key" =~ ^# ]] && [[ -n "$key" ]]; then
                if grep -q "^$key=" "$BCP_HOME/config/user-config" 2>/dev/null; then
                    # Key exists in new config, preserve new value
                    continue
                else
                    # Add old key-value pair
                    echo "$key=$value" >> "$BCP_HOME/config/user-config"
                fi
            fi
        done < "$BCP_HOME/config/user-config.backup"
        
        echo "✓ Configuration restored"
    fi
}

# Update banners and themes
update_resources() {
    echo "[5] Updating banners and themes..."
    
    # Create directories
    mkdir -p "$BCP_HOME/banners/custom" "$BCP_HOME/themes/custom"
    
    # Download new banners
    BANNER_URL="https://api.github.com/repos/cybernahid-dev/bcp-shell/contents/banners"
    curl -sSL "$BANNER_URL" | grep -o '"download_url": "[^"]*"' | cut -d'"' -f4 | while read url; do
        filename=$(basename "$url")
        if [[ ! -f "$BCP_HOME/banners/$filename" ]]; then
            curl -sSL "$url" -o "$BCP_HOME/banners/$filename"
            echo "  + $filename"
        fi
    done 2>/dev/null || true
    
    echo "✓ Resources updated"
}

# Finalize
finalize_update() {
    echo "[6] Finalizing update..."
    
    # Update version
    echo "BCP_VERSION=\"2.0.0\"" > "$BCP_HOME/.version"
    
    # Set permissions
    chmod +x "$BCP_HOME/bcp-shell.sh" "$BCP_HOME/update.sh" 2>/dev/null || true
    chmod +x "$BCP_HOME/plugins"/*.sh 2>/dev/null || true
    chmod +x "$BCP_HOME/utils"/*.sh 2>/dev/null || true
    chmod +x "$BCP_HOME/utils"/*.py 2>/dev/null || true
    
    echo "✓ Update finalized"
}

# Main update process
main() {
    echo "Starting BCP-Shell update at $(date)"
    echo "====================================="
    
    backup_config
    
    if update_from_git; then
        echo "Git update successful"
    else
        update_via_curl
    fi
    
    restore_config
    update_resources
    finalize_update
    
    echo ""
    echo "====================================="
    echo "✅ BCP-Shell updated successfully!"
    echo ""
    echo "📌 What's new:"
    echo "   • New themes and banners"
    echo "   • Improved customization"
    echo "   • Bug fixes"
    echo ""
    echo "🔄 Restart your terminal or run:"
    echo "   source ~/.bashrc"
    echo ""
    echo "🎨 Try new features:"
    echo "   bcp-theme list"
    echo "   bcp-banner list"
    echo "   bcp-user <yourname>"
}

# Run update
main "$@" 2>&1 | tee "$LOG_FILE"
