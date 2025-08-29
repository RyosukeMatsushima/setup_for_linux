#!/bin/bash

# Script to remap CapsLock to Ctrl
# This script configures CapsLock key to function as Ctrl key

set -e

echo "⌨️  Setting up CapsLock to Ctrl remapping..."

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

# Function to install required packages
install_packages() {
    echo "📦 Installing required packages..."
    
    case $DISTRO in
        "debian")
            sudo apt-get update
            sudo apt-get install -y x11-xkb-utils
            ;;
        "fedora")
            sudo dnf install -y xorg-x11-xkb-utils
            ;;
        "rhel")
            sudo yum install -y xorg-x11-xkb-utils
            ;;
        "arch")
            sudo pacman -Sy --noconfirm xorg-setxkbmap
            ;;
    esac
    
    echo "✅ Required packages installed"
}

# Function to apply CapsLock to Ctrl remapping for current session
apply_current_session() {
    echo "🔧 Applying CapsLock to Ctrl remapping for current session..."
    
    # Use setxkbmap to remap CapsLock to Ctrl
    setxkbmap -option ctrl:nocaps
    
    echo "✅ CapsLock remapped to Ctrl for current session"
}

# Function to make the remapping persistent
make_persistent() {
    echo "💾 Making CapsLock to Ctrl remapping persistent..."
    
    # Method 1: Add to .profile for login shells
    if ! grep -q "setxkbmap -option ctrl:nocaps" ~/.profile 2>/dev/null; then
        echo "" >> ~/.profile
        echo "# Remap CapsLock to Ctrl" >> ~/.profile
        echo "setxkbmap -option ctrl:nocaps" >> ~/.profile
    fi
    
    # Method 2: Add to .bashrc for interactive shells
    if ! grep -q "setxkbmap -option ctrl:nocaps" ~/.bashrc 2>/dev/null; then
        echo "" >> ~/.bashrc
        echo "# Remap CapsLock to Ctrl" >> ~/.bashrc
        echo "setxkbmap -option ctrl:nocaps" >> ~/.bashrc
    fi
    
    # Method 3: Create autostart entry for desktop environments
    mkdir -p ~/.config/autostart
    cat > ~/.config/autostart/capslock-to-ctrl.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=CapsLock to Ctrl
Exec=setxkbmap -option ctrl:nocaps
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Comment=Remap CapsLock key to Ctrl
EOF
    
    # Method 4: Create X11 configuration (system-wide, requires sudo)
    echo "🔐 Creating system-wide X11 configuration (requires sudo)..."
    sudo mkdir -p /etc/X11/xorg.conf.d
    
    sudo tee /etc/X11/xorg.conf.d/90-capslock-to-ctrl.conf > /dev/null << 'EOF'
Section "InputClass"
    Identifier "keyboard-layout"
    Driver "libinput"
    MatchIsKeyboard "yes"
    Option "XkbOptions" "ctrl:nocaps"
EndSection
EOF
    
    echo "✅ Persistent configuration created"
}

# Function to configure for different desktop environments
configure_desktop_environments() {
    echo "🖥️  Configuring for desktop environments..."
    
    # GNOME/GDM configuration
    if command -v gsettings &> /dev/null; then
        echo "⚙️  Configuring GNOME settings..."
        gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']" 2>/dev/null || true
        echo "✅ GNOME settings configured"
    fi
    
    # Create a script for manual application
    mkdir -p ~/.local/bin
    cat > ~/.local/bin/apply-capslock-ctrl << 'EOF'
#!/bin/bash
# Manual script to apply CapsLock to Ctrl remapping
setxkbmap -option ctrl:nocaps
echo "CapsLock remapped to Ctrl"
EOF
    
    chmod +x ~/.local/bin/apply-capslock-ctrl
    
    echo "✅ Desktop environment configuration completed"
}

# Function to show usage instructions
show_instructions() {
    echo ""
    echo "🎉 CapsLock to Ctrl remapping setup completed!"
    echo ""
    echo "📋 What was configured:"
    echo "• CapsLock key now functions as Ctrl key"
    echo "• Configuration is persistent across reboots"
    echo "• Works in X11 sessions and most desktop environments"
    echo ""
    echo "🔧 Manual commands:"
    echo "• Apply remapping: setxkbmap -option ctrl:nocaps"
    echo "• Reset to original: setxkbmap -option"
    echo "• Quick apply: ~/.local/bin/apply-capslock-ctrl"
    echo "• Quick reset: ~/.local/bin/reset-capslock-ctrl"
    echo ""
    echo "💡 Notes:"
    echo "• The remapping is already active in your current session"
    echo "• It will automatically apply on login/reboot"
    echo "• Works with most applications and terminal emulators"
    echo "• For Wayland sessions, the configuration may vary by compositor"
    echo ""
    echo "🔍 Troubleshooting:"
    echo "• If remapping doesn't work, try logging out and back in"
    echo "• For Wayland/GNOME: Check Settings → Keyboard → Special Character Entry"
    echo "• For other desktop environments: Check keyboard settings in system preferences"
}

# Function to test the remapping
test_remapping() {
    echo "🧪 Testing CapsLock remapping..."
    
    # Get current keyboard options
    CURRENT_OPTIONS=$(setxkbmap -query | grep options || echo "options:")
    
    if echo "$CURRENT_OPTIONS" | grep -q "ctrl:nocaps"; then
        echo "✅ CapsLock to Ctrl remapping is active"
    else
        echo "⚠️  Remapping may not be active. Try running: setxkbmap -option ctrl:nocaps"
    fi
}

# Main execution
main() {
    echo "🚀 Starting CapsLock to Ctrl remapping setup..."
    
    check_distro
    install_packages
    apply_current_session
    make_persistent
    configure_desktop_environments
    test_remapping
    
    # Show reset instructions
    echo ""
    echo "🔄 To reset CapsLock to its original behavior:"
    echo "   setxkbmap -option"
    echo "   Or run: ~/.local/bin/reset-capslock-ctrl"
    
    # Create reset script
    mkdir -p ~/.local/bin
    cat > ~/.local/bin/reset-capslock-ctrl << 'EOF'
#!/bin/bash
# Script to reset CapsLock to its original behavior
setxkbmap -option
echo "CapsLock reset to original behavior"
EOF
    
    chmod +x ~/.local/bin/reset-capslock-ctrl
    
    show_instructions
    
    echo ""
    echo "✨ Setup complete! CapsLock is now mapped to Ctrl."
    echo "   Try pressing CapsLock + C to copy, or CapsLock + V to paste!"
}

# Run main function
main "$@"
