# Dockim - Docker Immich Installer

![Docker Setup Pro](https://img.shields.io/badge/Docker-Setup_Pro-blue)
![Version](https://img.shields.io/badge/version-1.0.0-green)
![Bash](https://img.shields.io/badge/Bash-Script-orange)

An enhanced interactive script for automating Docker and Immich installation on Ubuntu systems.

## 🚀 Features

- **Interactive Installation** - User-friendly prompts guide you through the setup process
- **Colorized Output** - Easy-to-read color-coded messages for different types of information
- **Visual Feedback** - ASCII art and progress indicators for a more engaging experience
- **Error Handling** - Robust error checking and recovery options
- **Configuration Options** - Customize your installation with interactive prompts
- **Detailed Summary** - Complete installation report when finished

## 📋 Prerequisites

- Ubuntu-based Linux distribution
- Sudo privileges
- Internet connection

## 🔧 What It Installs

1. **Docker Engine** - The complete Docker platform
2. **Docker Compose** - For defining and running multi-container Docker applications
3. **Immich** - Self-hosted photo and video backup solution (optional)

## 📥 Installation

1. Download the script:

2. Make it executable:

```bash
chmod +x dockim.sh
```

3. Run with sudo:

```bash
sudo ./dockim.sh
```

## 🖼️ Screenshots

```
 _____             _               _____           _        _ _       _   _             
|  __ \           | |             |_   _|         | |      | | |     | | (_)            
| |  | | ___   ___| | _____ _ __    | |  _ __  ___| |_ __ _| | | __ _| |_ _  ___  _ __  
| |  | |/ _ \ / __| |/ / _ \ '__|   | | | '_ \/ __| __/ _` | | |/ _` | __| |/ _ \| '_ \ 
| |__| | (_) | (__|   <  __/ |     _| |_| | | \__ \ || (_| | | | (_| | |_| | (_) | | | |
|_____/ \___/ \___|_|\_\___|_|    |_____|_| |_|___/\__\__,_|_|_|\__,_|\__|_|\___/|_| |_|
```

## 🌟 Key Features

### Docker Installation
- Official Docker repository setup
- Installation of Docker Engine, CLI, and plugins
- Verification with hello-world container

### Immich Setup (Optional)
- Downloads the latest Immich configuration
- Creates proper directory structure
- Sets up the complete Immich application stack
- Provides access URL after installation

### User Experience
- Confirmation prompts at critical steps
- Color-coded status messages
- Detailed installation summary
- Error detection and handling

## ⚙️ Configuration Options

During installation, you'll be prompted to:
- Choose whether to install/reinstall Docker
- Decide if you want to install Immich
- Edit the Immich configuration file before starting
- View Docker version information

## 📊 Installation Summary

After completion, the script provides a summary showing:
- Installation status of each component
- Location of installed applications
- Access URLs for web interfaces
- Running status of services

## 🛠️ Advanced Usage

### Skip Docker Installation
If you already have Docker installed, the script will detect it and offer to skip that part:

```
[CONFIRM] Docker is already installed. Do you want to reinstall it? (y/n):
```

### Custom Configuration
You can edit the Immich configuration before starting services:

```
[CONFIRM] Do you want to edit the Immich configuration before starting? (y/n):
```

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Docker for their excellent container platform
- Immich team for their fantastic photo management application

Coded by xsanlahci
