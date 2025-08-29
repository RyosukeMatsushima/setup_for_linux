#!/bin/bash

# Script to install and configure Japanese input with Mozc
# This script sets up Japanese Hiragana input using IBus and Mozc

set -e

echo "🇯🇵 Setting up Japanese input with Mozc..."

# Function to check if running on supported distribution
check_distro() {
    if command -v apt-get &> /dev/null; then
        DISTRO="debian"
    elif command -v dnf &> /dev/null; then
        DISTRO="fedora"
    elif command -v yum &> /dev/null; then
        DISTRO="rhel"
    elif command -v pacman &> /dev/null; then
        DISTRO="arch"
    else
        echo "❌ Unsupported distribution. This script supports Debian/Ubuntu, Fedora, RHEL/CentOS, and Arch Linux."
        exit 1
    fi
    echo "✅ Detected distribution: $DISTRO"
}

# Function to install packages based on distribution
install_packages() {
    echo "📦 Installing Japanese input packages..."
    
    case $DISTRO in
        "debian")
            sudo apt-get update
            sudo apt-get install -y ibus ibus-mozc mozc-utils-gui
            ;;
        "fedora")
            sudo dnf install -y ibus ibus-mozc mozc
            ;;
        "rhel")
            sudo yum install -y ibus ibus-mozc mozc
            ;;
        "arch")
            sudo pacman -Sy --noconfirm ibus ibus-mozc mozc
            ;;
    esac
    
    echo "✅ Packages installed successfully"
}

# Function to configure IBus
configure_ibus() {
    echo "⚙️  Configuring IBus..."
    
    # Set IBus as the default input method
    export GTK_IM_MODULE=ibus
    export QT_IM_MODULE=ibus
    export XMODIFIERS=@im=ibus
    
    # Add environment variables to profile
    if ! grep -q "GTK_IM_MODULE=ibus" ~/.profile 2>/dev/null; then
        echo "" >> ~/.profile
        echo "# Japanese input method configuration" >> ~/.profile
        echo "export GTK_IM_MODULE=ibus" >> ~/.profile
        echo "export QT_IM_MODULE=ibus" >> ~/.profile
        echo "export XMODIFIERS=@im=ibus" >> ~/.profile
    fi
    
    # Also add to .bashrc for immediate effect
    if ! grep -q "GTK_IM_MODULE=ibus" ~/.bashrc 2>/dev/null; then
        echo "" >> ~/.bashrc
        echo "# Japanese input method configuration" >> ~/.bashrc
        echo "export GTK_IM_MODULE=ibus" >> ~/.bashrc
        echo "export QT_IM_MODULE=ibus" >> ~/.bashrc
        echo "export XMODIFIERS=@im=ibus" >> ~/.bashrc
    fi
    
    echo "✅ IBus environment variables configured"
}

# Function to start IBus daemon
start_ibus_daemon() {
    echo "🚀 Starting IBus daemon..."
    
    # Kill existing IBus processes
    pkill -f ibus-daemon 2>/dev/null || true
    
    # Start IBus daemon
    ibus-daemon -drx
    
    echo "✅ IBus daemon started"
}

# Function to add Mozc input method
add_mozc_input() {
    echo "🔧 Adding Mozc input method..."
    
    # Add Japanese (Mozc) input method
    ibus engine mozc &>/dev/null || true
    
    # Wait a moment for IBus to initialize
    sleep 2
    
    # Add Mozc to the list of input sources
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'mozc-jp')]" 2>/dev/null || true
    
    echo "✅ Mozc input method added"
}

# Function to configure autostart
configure_autostart() {
    echo "⚙️  Configuring autostart..."
    
    # Create autostart directory if it doesn't exist
    mkdir -p ~/.config/autostart
    
    # Create IBus autostart file
    cat > ~/.config/autostart/ibus.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=IBus
Exec=ibus-daemon -drx
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF
    
    echo "✅ IBus autostart configured"
}

# Function to show usage instructions
show_instructions() {
    echo ""
    echo "🎉 Japanese input setup completed!"
    echo ""
    echo "📋 Usage Instructions:"
    echo "1. Log out and log back in (or reboot) for changes to take effect"
    echo "2. Use Super+Space or Ctrl+Space to switch between input methods"
    echo "3. When Mozc is active, you can type in Hiragana"
    echo "4. Use the language indicator in your system tray to switch input methods"
    echo ""
    echo "🔧 Additional Configuration:"
    echo "• Run 'ibus-setup' to configure input methods and shortcuts"
    echo "• Run 'mozc_tool --mode=config_dialog' to configure Mozc settings"
    echo "• In GNOME: Settings → Keyboard → Input Sources to manage input methods"
    echo ""
    echo "💡 Keyboard Shortcuts in Mozc:"
    echo "• F6: Convert to Hiragana"
    echo "• F7: Convert to Katakana"
    echo "• F8: Convert to half-width Katakana"
    echo "• F9: Convert to full-width alphanumeric"
    echo "• F10: Convert to half-width alphanumeric"
    echo ""
    echo "🔄 To manually restart IBus if needed:"
    echo "   pkill ibus-daemon && ibus-daemon -drx"
}

# Main execution
main() {
    echo "🚀 Starting Japanese input setup..."
    
    check_distro
    install_packages
    configure_ibus
    start_ibus_daemon
    add_mozc_input
    configure_autostart
    show_instructions
    
    echo ""
    echo "✨ Setup complete! Please log out and log back in to use Japanese input."
}

# Run main function
main "$@"
