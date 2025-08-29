# setup_for_linux

A collection of setup scripts for configuring a Linux development environment.

## Available Scripts

- `setup_git.sh` - Configure Git with user credentials and set nvim as default editor
- `install_nvim.sh` - Install and configure Neovim
- `install_docker.sh` - Install Docker
- `install_copilot.sh` - Install GitHub Copilot
- `make_ssh_key.sh` - Generate SSH keys
- `install_japanese_input.sh` - Setup Japanese Hiragana input with Mozc
- `setup_capslock_to_ctrl.sh` - Remap CapsLock key to function as Ctrl key

## Usage

Make scripts executable and run them:
```bash
chmod +x script_name.sh
./script_name.sh
```

### Japanese Input Setup

The `install_japanese_input.sh` script will:
- Install IBus and Mozc for Japanese input
- Configure environment variables for proper input method integration
- Set up autostart for IBus daemon
- Add Mozc to available input sources

After running the script, log out and log back in, then use `Super+Space` or `Ctrl+Space` to toggle between English and Japanese Hiragana input.

### CapsLock to Ctrl Remapping

The `setup_capslock_to_ctrl.sh` script will:
- Remap CapsLock key to function as Ctrl key
- Create persistent configuration across reboots
- Set up autostart entries for desktop environments
- Configure system-wide X11 settings
- Create manual apply/reset scripts

After running the script, CapsLock will immediately function as Ctrl. Use the created helper scripts to manually apply or reset the remapping if needed.