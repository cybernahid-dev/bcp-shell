### BCP-Shell: Professional Custom Shell Environment

<div align="center">

![BCP-Shell Banner](https://img.shields.io/badge/TeamBCP-Shell-blue)
![Version](https://img.shields.io/badge/Version-5.0-green)
![Platform](https://img.shields.io/badge/Platform-Termux%2FLinux%2FmacOS-orange)
![License](https://img.shields.io/badge/License-MIT-brightgreen)

**A futuristic, highly customizable shell for TeamBCP with advanced features**

</div>

## 📖Project Overview

BCP-Shell is an advanced, feature-rich custom shell environment designed for developers, system administrators, and terminal enthusiasts. Built with extensibility and aesthetics in mind, it transforms your terminal into a powerful, personalized workspace.

## ✨ Core Features

**🎯 Prompt System**

· Multiple Styles: Choose from 5+ prompt styles (Advanced, Minimal, Expert, Compact, Classic)
· Dynamic Elements: Real-time display of git status, time, user info, and system metrics
· Color Customization: Full RGB/256-color support with theme engine
· Multi-line Support: Clean, organized multi-line prompts

**🛠 User Management**

· Easy Username Changes: bcp-user <name> command
· Team Branding: Custom team name display
· Display Formats: Flexible display name configurations
· Profile Switching: Quick user profile management

**🎨 Customization Engine**

· Theme System: Pre-built themes + custom theme creation
· Banner Display: Multiple ASCII art banners
· Plugin Architecture: Extensible via plugin system
· Configuration Management: JSON-based config with import/export

**🔧 Development Features**

· Git Integration: Automatic branch detection and status
· Virtual Environment: Python/Ruby/Node.js environment detection
· Syntax Highlighting: Command syntax highlighting (optional)
· Auto-suggestions: Fish-style command suggestions
· History Management: Enhanced history with search

## 🚀 Quick Installation

One-line Install

```bash
curl -sSL https://raw.githubusercontent.com/cybernahid-dev/bcp-shell/main/install.sh | bash
```

Manual Installation

```bash
git clone https://github.com/cybernahid-dev/bcp-shell.git ~/.bcp-shell
cd ~/.bcp-shell
chmod +x install.sh
./install.sh
```

## 📦 System Requirements

Minimum Requirements

· Bash: 4.0 or higher
· Terminal: ANSI-compatible terminal
· Storage: 10MB free space
· Memory: 128MB RAM

Recommended

· Bash: 5.0+ or Zsh
· Terminal: True Color support
· Storage: 50MB free space
· Memory: 512MB RAM

## 📋 Platform Support

```
Platform Status Notes
Termux (Android) ✅ Full Support Optimized for mobile
Linux (Ubuntu/Debian) ✅ Full Support Primary platform
macOS ✅ Full Support Includes macOS-specific features
WSL (Windows) ✅ Full Support Windows Subsystem for Linux
BSD ⚠️ Limited Basic functionality
```
## 🎯 Getting Started

First-time Setup

```bash
# After installation, configure your shell:
bcp-user yourname           # Set your username
bcp-team TeamBCP            # Set team name
bcp-style expert            # Choose prompt style
bcp-theme set dark          # Apply theme
bcp-banner set cyber        # Set startup banner
bcp-status                  # Verify configuration
```

**Basic Commands**

```bash
# User & Team
bcp-user <name>             # Change username
bcp-team <name>             # Change team name
bcp-display <text>          # Set display text

# Customization
bcp-style <style>           # Change prompt style
bcp-theme list              # List available themes
bcp-theme set <name>        # Apply theme
bcp-banner list             # List available banners
bcp-banner set <name>       # Set banner

# System
bcp-status                  # Show shell status
bcp-config                  # Edit configuration
bcp-update                  # Update BCP-Shell
bcp-help                    # Show help menu
bcp-version                 # Display version
```

## 🎨 Customization Guide

Prompt Styles

```bash
# Available Styles:
bcp-style advanced          # Two-line with git/time
bcp-style minimal           # Clean one-line
bcp-style expert            # Professional multi-line
bcp-style compact           # Space-efficient
bcp-style classic           # Traditional bash style
```

**Themes**

```bash
# Pre-installed Themes:
bcp-theme set default       # Blue/Green theme
bcp-theme set dark          # Dark mode theme
bcp-theme set cyber         # Cyberpunk theme
bcp-theme set neon          # Neon colors theme
bcp-theme set purple        # Purple theme

# Create Custom Theme:
bcp-theme create mytheme    # Create new theme
```

**Banners**

```bash
# Available Banners:
bcp-banner set default      # Standard TeamBCP banner
bcp-banner set cyber        # Cyber style banner
bcp-banner set minimal      # Minimal banner
bcp-banner set ascii        # ASCII art banner

# Banner Control:
bcp-banner toggle           # Toggle on/off
bcp-banner preview <name>   # Preview banner
```

## 🔧 Advanced Features

**Plugin System**

```bash
# Plugin commands
bcp-plugin list             # List available plugins
bcp-plugin enable <name>    # Enable plugin
bcp-plugin disable <name>   # Disable plugin
bcp-plugin info <name>      # Show plugin info
```

**Utility Commands**

```bash
# System Information
bcp-sysinfo                 # System overview
bcp-weather [city]          # Weather information
bcp-cpu                     # CPU monitoring
bcp-mem                     # Memory usage
bcp-disk                    # Disk space

# Development Tools
bcp-git-status              # Enhanced git status
bcp-env-check               # Environment check
bcp-path                    # Show PATH variables
```

**Configuration Management**

```bash
# Config operations
bcp-config edit             # Edit config (opens editor)
bcp-config show             # Display current config
bcp-config backup           # Create backup
bcp-config restore          # Restore from backup
bcp-config reset            # Reset to defaults
```

## 📁 Project Structure

```
~/.bcp-shell/
├── bcp-shell.sh           # Main shell script
├── install.sh             # Installation script
├── update.sh              # Update script
├── uninstall.sh           # Uninstall script
├── README.md              # Documentation
├── LICENSE                # MIT License
├── CHANGELOG.md           # Version history
│
├── config/                # Configuration
│   ├── user.conf         # User preferences
│   ├── themes/           # Theme files
│   └── color-palettes    # Color schemes
│
├── banners/              # Banner files
│   ├── default.banner
│   ├── cyber.banner
│   ├── minimal.banner
│   └── ascii.banner
│
├── themes/               # Theme definitions
│   ├── default.theme
│   ├── dark.theme
│   ├── cyber.theme
│   └── neon.theme
│
├── plugins/              # Plugin system
│   ├── banner-manager.sh
│   ├── theme-manager.sh
│   ├── user-manager.sh
│   └── update-manager.sh
│
└── utils/                # Utility tools
    ├── banner-generator.py
    ├── theme-creator.sh
    └── color-preview.sh
```

## 🛠 Development

**Building from Source**

```bash
# Clone repository
git clone https://github.com/cybernahid-dev/bcp-shell.git
cd bcp-shell

# Build project
make build

# Run tests
make test

# Install locally
make install
```

**Creating Plugins**

```bash
# Plugin template
cat > ~/.bcp-shell/plugins/myplugin.sh << 'EOF'
#!/bin/bash
# My Custom Plugin

myplugin_init() {
    echo "Plugin initialized"
}

# Register commands
bcp_register_command "mycmd" "myplugin_mycmd"
EOF
```

**Theme Development**

```bash
# Create theme file
cat > ~/.bcp-shell/themes/custom.theme << 'EOF'
name="Custom Theme"
prompt_color="cyan"
user_color="green"
host_color="yellow"
dir_color="magenta"
time_color="blue"
EOF

# Apply theme
bcp-theme set custom
```

## 🔄 Updating

Automatic Updates

```bash
# Check for updates
bcp-update check

# Update to latest version
bcp-update

# Update with backup
bcp-update --backup
```

**Manual Updates**

```bash
# Method 1: Using git
cd ~/.bcp-shell
git pull origin main

# Method 2: Re-run installer
curl -sSL https://raw.githubusercontent.com/cybernahid-dev/bcp-shell/main/install.sh | bash

# Method 3: Download script
wget -O ~/.bcp-shell/bcp-shell.sh https://raw.githubusercontent.com/cybernahid-dev/bcp-shell/main/bcp-shell.sh
```

## 🚨 Troubleshooting

**Common Issues**

Installation Fails

```bash
# Check permissions
chmod +x ~/.bcp-shell/install.sh

# Check dependencies
which bash
which curl

# Manual install
mkdir -p ~/.bcp-shell
cp bcp-shell.sh ~/.bcp-shell/
echo "source ~/.bcp-shell/bcp-shell.sh" >> ~/.bashrc
```

**Prompt Not Showing**

```bash
# Reload shell
source ~/.bashrc

# Check PS1 variable
echo $PS1

# Manual prompt set
export PS1="[\\[\\033[0;36m\\]TeamBCP\\[\\033[0m\\]] \\[\\033[1;33m\\]@\\u\\[\\033[0m\\]:\\[\\033[0;35m\\]\\w\\[\\033[0m\\]\\$ "
```

**Commands Not Working**

```bash
# Check if shell loaded
type bcp-user

# Reload shell
source ~/.bcp-shell/bcp-shell.sh

# Check config
ls -la ~/.bcp-shell/config/
```

**Debug Mode**

```bash
# Enable debug
export BCP_DEBUG=1
source ~/.bcp-shell/bcp-shell.sh

# View logs
cat ~/.bcp-shell/debug.log
```

## 🤝 Contributing

**How to Contribute**

1. Fork the repository
2. Create feature branch: git checkout -b feature/NewFeature
3. Commit changes: git commit -m 'Add NewFeature'
4. Push to branch: git push origin feature/NewFeature
5. Open Pull Request

**Contribution Areas**

· Bug Fixes: Report and fix issues
· New Features: Add functionality
· Themes: Create new themes
· Banners: Design new banners
· Documentation: Improve docs
· Translations: Add language support

**Development Setup**

```bash
# Clone with submodules
git clone --recursive https://github.com/cybernahid-dev/bcp-shell.git

# Setup development
cd bcp-shell
./scripts/setup-dev.sh

# Run tests
./scripts/run-tests.sh
```

## 📄 License

MIT License

Copyright (c) 2025 cybernahid-dev & TeamBCP

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files(the "Software"), to deal
in the Software without restriction,including without limitation the rights
to use,copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software,and to permit persons to whom the Software is
furnished to do so,subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED,INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,DAMAGES OR OTHER
LIABILITY,WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## 👥 Team & Credits

**Core Team**

**· cybernahid-dev - Creator & Lead** Developer
· TeamBCP Members - Testing & Feedback

**Acknowledgments**

· Inspired by Oh My Zsh, Fish Shell, Powerlevel10k
· Thanks to Termux community for Android support
· Open source community for tools and libraries

**❣️ Support**

· GitHub Issues: Bug reports and feature requests
· Documentation: Comprehensive guides and examples
· Community: User discussions and support

**📞 Support & Community**

**Getting Help**

· Documentation: Read the full docs at docs/
· GitHub Issues: Report issues
· Examples: Check examples/ directory

**Community Resources**

· GitHub Discussions: Share ideas and solutions
· Wiki: User-contributed tips and tricks
· Examples: Real-world use cases

**Enterprise Support**

For commercial support or custom implementations, contact the maintainers.

---

BCP-Shell - Elevate your terminal experience with professional-grade customization.

Repository: https://github.com/cybernahid-dev/bcp-shell
Documentation: https://github.com/cybernahid-dev/bcp-shell/docs
Issues: https://github.com/cybernahid-dev/bcp-shell/issues
Releases: https://github.com/cybernahid-dev/bcp-shell/releases

Made with ❤️ for TeamBCP and the developer community.
