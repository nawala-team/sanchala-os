#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala Backup - Configuration Management

CONFIG_FILE="${CONFIG_FILE:-/etc/sanchala/backup.toml}"
DEFAULT_CONFIG="/usr/share/sanchala/backup/backup.toml.default"

#######################################
# Load configuration from TOML file
#######################################
load_config() {
    local config_file="${1:-$CONFIG_FILE}"
    
    if [[ ! -f "$config_file" ]]; then
        print_warning "Config file not found: $config_file"
        print_info "Using default configuration"
        config_file="$DEFAULT_CONFIG"
    fi

    # Parse TOML (basic parser for shell)
    # For complex configs, we'll use a proper parser
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ "$key" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$key" ]] && continue
        
        # Clean up key and value
        key=$(echo "$key" | tr -d '[:space:]' | tr '.' '_')
        value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '"')
        
        # Export as environment variable
        export "BACKUP_${key^^}=$value"
    done < <(grep -v '^\[' "$config_file" | grep '=')
}

#######################################
# Get snapper config path
#######################################
get_snapper_config() {
    local config_name="$1"
    echo "/etc/snapper/configs/$config_name"
}

#######################################
# Check if snapper config exists
#######################################
snapper_config_exists() {
    local config_name="$1"
    [[ -f "/etc/snapper/configs/$config_name" ]]
}

#######################################
# Get subvolume path from snapper config
#######################################
get_subvolume_path() {
    local config_name="$1"
    local config_file="/etc/snapper/configs/$config_name"
    
    if [[ -f "$config_file" ]]; then
        grep "^SUBVOLUME=" "$config_file" | cut -d'"' -f2
    else
        case "$config_name" in
            root) echo "/" ;;
            home) echo "/home" ;;
            *) echo "" ;;
        esac
    fi
}

#######################################
# Show current configuration
#######################################
cmd_config() {
    local action="${1:-show}"
    
    case "$action" in
        show)
            echo -e "${BOLD}Sanchala Backup Configuration${NC}"
            echo "================================"
            echo
            
            if [[ -f "$CONFIG_FILE" ]]; then
                echo "Config file: $CONFIG_FILE"
                echo
                cat "$CONFIG_FILE"
            else
                print_warning "No configuration file found"
                echo "Default settings will be used"
            fi
            ;;
        edit)
            if command -v nano &>/dev/null; then
                sudo nano "$CONFIG_FILE"
            elif command -v vim &>/dev/null; then
                sudo vim "$CONFIG_FILE"
            else
                print_error "No editor found"
                exit 1
            fi
            ;;
        reset)
            if [[ -f "$DEFAULT_CONFIG" ]]; then
                sudo cp "$DEFAULT_CONFIG" "$CONFIG_FILE"
                print_success "Configuration reset to defaults"
            else
                print_error "Default config not found"
                exit 1
            fi
            ;;
        *)
            print_error "Unknown config action: $action"
            echo "Usage: $PROGRAM_NAME config [show|edit|reset]"
            exit 1
            ;;
    esac
}

#######################################
# Get retention settings
#######################################
get_retention() {
    local type="$1"
    local config_name="${2:-root}"
    local config_file="/etc/snapper/configs/$config_name"
    
    if [[ -f "$config_file" ]]; then
        case "$type" in
            hourly)
                grep "^TIMELINE_LIMIT_HOURLY=" "$config_file" | cut -d'=' -f2 | tr -d '"'
                ;;
            daily)
                grep "^TIMELINE_LIMIT_DAILY=" "$config_file" | cut -d'=' -f2 | tr -d '"'
                ;;
            weekly)
                grep "^TIMELINE_LIMIT_WEEKLY=" "$config_file" | cut -d'=' -f2 | tr -d '"'
                ;;
            monthly)
                grep "^TIMELINE_LIMIT_MONTHLY=" "$config_file" | cut -d'=' -f2 | tr -d '"'
                ;;
            yearly)
                grep "^TIMELINE_LIMIT_YEARLY=" "$config_file" | cut -d'=' -f2 | tr -d '"'
                ;;
        esac
    fi
}
