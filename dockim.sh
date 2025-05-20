#!/bin/bash
#======================================================
#     _____             _           _____      _               
#    |  __ \           | |         / ____|    | |              
#    | |  | | ___   ___| | _____  | (___   ___| |_ _   _ _ __  
#    | |  | |/ _ \ / __| |/ / _ \  \___ \ / _ \ __| | | | '_ \ 
#    | |__| | (_) | (__|   <  __/  ____) |  __/ |_| |_| | |_) |
#    |_____/ \___/ \___|_|\_\___| |_____/ \___|\__|\__,_| .__/ 
#                                                       | |    
#                                                       |_|    
#
#    Docker & Immich Installation Script
#    Coded by xsanlahci
#======================================================

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display colorful messages
print_message() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "\n${BLUE}==== $1 ====${NC}\n"
}

# Function to check if command succeeded
check_success() {
    if [ $? -eq 0 ]; then
        print_success "$1"
    else
        print_error "$2"
        exit 1
    fi
}

# Function to ask for confirmation
confirm() {
    read -p "$(echo -e ${YELLOW}[CONFIRM]${NC}) $1 (y/n): " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Welcome message
clear
echo -e "${CYAN}"
cat << "EOF"
 _____             _               _____           _        _ _       _   _             
|  __ \           | |             |_   _|         | |      | | |     | | (_)            
| |  | | ___   ___| | _____ _ __    | |  _ __  ___| |_ __ _| | | __ _| |_ _  ___  _ __  
| |  | |/ _ \ / __| |/ / _ \ '__|   | | | '_ \/ __| __/ _` | | |/ _` | __| |/ _ \| '_ \ 
| |__| | (_) | (__|   <  __/ |     _| |_| | | \__ \ || (_| | | | (_| | |_| | (_) | | | |
|_____/ \___/ \___|_|\_\___|_|    |_____|_| |_|___/\__\__,_|_|_|\__,_|\__|_|\___/|_| |_|
                                                                                        
EOF
echo -e "${NC}"
echo -e "${GREEN}Docker & Immich Installation Setup${NC}"
echo -e "${BLUE}Coded by xsanlahci${NC}"
echo -e "${YELLOW}======================================================${NC}"
echo ""

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ] && [ -z "$SUDO_USER" ]; then
    print_error "This script must be run with sudo privileges."
    exit 1
fi

# Install Docker
print_header "DOCKER INSTALLATION"

if command -v docker &> /dev/null; then
    if confirm "Docker is already installed. Do you want to reinstall it?"; then
        print_message "Proceeding with Docker reinstallation..."
    else
        print_message "Skipping Docker installation..."
        SKIP_DOCKER=true
    fi
fi

if [ -z "$SKIP_DOCKER" ]; then
    print_message "Updating package information..."
    sudo apt-get update
    check_success "Package information updated." "Failed to update package information."

    print_message "Installing prerequisites (ca-certificates, curl)..."
    sudo apt-get install -y ca-certificates curl
    check_success "Prerequisites installed." "Failed to install prerequisites."

    print_message "Setting up Docker repository..."
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    check_success "Docker repository setup completed." "Failed to set up Docker repository."

    print_message "Adding Docker repository to APT sources..."
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    print_message "Updating package information with Docker repository..."
    sudo apt-get update
    check_success "Package information updated with Docker repository." "Failed to update package information."

    print_message "Installing Docker packages..."
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    check_success "Docker installed successfully!" "Failed to install Docker."

    print_message "Verifying Docker installation with hello-world..."
    sudo docker run hello-world
    check_success "Docker is working correctly!" "Docker hello-world test failed."
fi

# Ask user if they want to install Immich
print_header "IMMICH INSTALLATION"

if confirm "Do you want to install Immich photo management system?"; then
    # Get username if running with sudo
    if [ -n "$SUDO_USER" ]; then
        USERNAME="$SUDO_USER"
    else
        USERNAME="$(whoami)"
    fi
    
    USER_HOME="/home/$USERNAME"
    
    print_message "Creating directory structure..."
    if [ ! -d "$USER_HOME/docker" ]; then
        mkdir -p "$USER_HOME/docker"
        check_success "Docker directory created." "Failed to create Docker directory."
    else
        print_message "Docker directory already exists."
    fi
    
    if [ ! -d "$USER_HOME/docker/immich-app" ]; then
        mkdir -p "$USER_HOME/docker/immich-app"
        check_success "Immich directory created." "Failed to create Immich directory."
    else
        print_warning "Immich directory already exists. Content might be overwritten."
        if ! confirm "Continue with installation?"; then
            print_message "Installation aborted by user."
            exit 0
        fi
    fi
    
    cd "$USER_HOME/docker/immich-app"
    
    print_message "Downloading Immich docker-compose.yml..."
    wget -O docker-compose.yml https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
    check_success "docker-compose.yml downloaded." "Failed to download docker-compose.yml."
    
    print_message "Downloading Immich environment file..."
    wget -O .env https://github.com/immich-app/immich/releases/latest/download/example.env
    check_success "Environment file downloaded." "Failed to download environment file."
    
    # Optional: Edit configuration
    if confirm "Do you want to edit the Immich configuration before starting?"; then
        if command -v nano &> /dev/null; then
            nano .env
        elif command -v vim &> /dev/null; then
            vim .env
        else
            print_warning "No editor found. Skipping configuration editing."
        fi
    fi
    
    print_message "Starting Immich services..."
    docker compose up -d
    check_success "Immich started successfully!" "Failed to start Immich services."
    
    # Get server IP for easy access
    SERVER_IP=$(hostname -I | awk '{print $1}')
    print_header "INSTALLATION COMPLETE"
    echo -e "${GREEN}Immich is now running!${NC}"
    echo -e "Access the Immich web interface at: ${CYAN}http://$SERVER_IP:2283${NC}"
    echo -e "Default admin credentials can be set on first login."
else
    print_message "Immich installation skipped."
fi

print_header "INSTALLATION SUMMARY"
echo -e "${BLUE}=====================================================${NC}"
if [ -z "$SKIP_DOCKER" ]; then
    echo -e "✅ ${GREEN}Docker installed and verified${NC}"
else
    echo -e "⏩ ${YELLOW}Docker installation skipped (already installed)${NC}"
fi

if confirm "Do you want to show Docker version information?"; then
    docker --version
    docker compose version
fi

echo ""
if [ -d "$USER_HOME/docker/immich-app" ] && [ -f "$USER_HOME/docker/immich-app/docker-compose.yml" ]; then
    echo -e "✅ ${GREEN}Immich installed${NC}"
    echo -e "   ${CYAN}Location: $USER_HOME/docker/immich-app${NC}"
    
    # Check if Immich containers are running
    if docker ps | grep -q immich; then
        echo -e "   ${GREEN}Status: Running${NC}"
        SERVER_IP=$(hostname -I | awk '{print $1}')
        echo -e "   ${CYAN}Access URL: http://$SERVER_IP:2283${NC}"
    else
        echo -e "   ${YELLOW}Status: Not running${NC}"
    fi
else
    echo -e "⏩ ${YELLOW}Immich installation skipped${NC}"
fi
echo -e "${BLUE}=====================================================${NC}"
echo ""
echo -e "${GREEN}Thank you for using Docker & Immich Setup!${NC}"
echo -e "${BLUE}Coded by xsanlahci${NC}"
