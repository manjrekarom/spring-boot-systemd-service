# Create files and folders for running a spring or any web application as a systemd service
# =========================================================================================
# 
# The script might need sudo access as it creates folders in opt directory.
# 
# Arguments
# ---------
# n -> Application name (no spaces). E.g. blog-app. Default is spring-app
# u -> Run as linux username. E.g. admin. Default is current user ($USER)
# 
# 

# USER ARGUMENTS
while getopts ":n:u:" opt; do
  case $opt in
    n) app_name_opt="$OPTARG"
    ;;
    u) user_name_opt="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

APP_NAME=${app_name_opt:-"spring-app"} # application name
USER_NAME=${user_name_opt:-$USER} # linux username

# SCRIPT DEFAULTS: ACTUAL
APP_BINARY="/usr/bin/java" # for spring boot apps
BASE_DIR="/opt"
CONF_DIR="/etc/default"
SERVICE_DIR="/etc/systemd/system"

# SCRIPT DEFAULTS: TESTING 
# BASE_DIR="./MOCK_OPT"
# CONF_DIR="./gen/default"
# SERVICE_DIR="./gen/system"

echo "Application name is $APP_NAME"
echo "User name is $USER_NAME"
# create application directories
create_app_dir() {
    mkdir -p "$1/$2"
    mkdir -p "$1/$2/current"
    mkdir -p "$1/$2/latest"
    mkdir -p "$1/$2/logs"
    mkdir -p "$1/$2/backups"
    chown -R "$3":"$3" "$1/$2"
    echo "Created app directory for $APP_NAME at $1/$2"
}
create_app_dir "$BASE_DIR" "$APP_NAME" $USER_NAME

add_app_and_service_config() {
    # add configuration
    sed -e "s/<app_name>/$1/g" -e "s/<user_name>/$2/g" app.conf > "$3/$1"
    # add service
    sed -e "s/<app_name>/$1/g" -e "s/<user_name>/$2/g" service.conf > "$4/$1.service"
    echo "Added configuration at "$3/$1" and service at "$4/$1.service"";
}

add_app_and_service_config "$APP_NAME" "$USER_NAME" "$CONF_DIR" "$SERVICE_DIR"

# # USER FEEDBACK
# feedback() {
#     echo "Created application $APP_NAME at $BASE_DIR/"
# }

