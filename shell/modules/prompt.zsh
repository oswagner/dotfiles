# =============================================================================
# Spaceship Prompt Configuration
# Configuração do tema Spaceship para Zsh
# =============================================================================

ZSH_THEME="spaceship"

# Configurações gerais do prompt
SPACESHIP_PROMPT_ADD_NEWLINE=false          # Adds a newline character before each prompt line
SPACESHIP_PROMPT_SEPARATE_LINE=true         # Make the prompt span across two lines
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=false    # Shows a prefix of the first section in prompt
SPACESHIP_PROMPT_PREFIXES_SHOW=true         # Show prefixes before prompt sections or not
SPACESHIP_PROMPT_SUFFIXES_SHOW=true         # Show suffixes before prompt sections or not
SPACESHIP_PROMPT_DEFAULT_SUFFIX=" "
SPACESHIP_PROMPT_DEFAULT_PREFIX=""

# Time section
SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_PREFIX=""

# User section
SPACESHIP_USER_SHOW=always
SPACESHIP_USER_COLOR=#00ff87
SPACESHIP_USER_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX

# Dir section
SPACESHIP_DIR_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_DIR_SUFFIX=$SPACESHIP_PROMPT_DEFAULT_SUFFIX

# Python VENV
SPACESHIP_VENV_SHOW=true
SPACESHIP_VENV_PREFIX="venv["
SPACESHIP_VENV_SUFFIX="] "
SPACESHIP_VENV_COLOR="blue"

# PYTHON
SPACESHIP_PYTHON_SHOW=true
SPACESHIP_PYTHON_PREFIX="("
SPACESHIP_PYTHON_SUFFIX=") "
SPACESHIP_PYTHON_SYMBOL="py "
SPACESHIP_PYTHON_COLOR="green"

# RUBY
SPACESHIP_RUBY_SHOW=true
SPACESHIP_RUBY_ASYNC=true
SPACESHIP_RUBY_PREFIX="("
SPACESHIP_RUBY_SUFFIX=")"
SPACESHIP_RUBY_SYMBOL="ruby "
SPACESHIP_RUBY_COLOR="red"

# JAVA
SPACESHIP_JAVA_SHOW=true
SPACESHIP_JAVA_ASYNC=true
SPACESHIP_JAVA_PREFIX="("
SPACESHIP_JAVA_SUFFIX=")"
SPACESHIP_JAVA_SYMBOL="java "
SPACESHIP_JAVA_COLOR="cyan"

# Docker
SPACESHIP_DOCKER_SHOW=true                                      # Show current Docker version or not
SPACESHIP_DOCKER_PREFIX="on "                                   # Prefix before the Docker section
SPACESHIP_DOCKER_SUFFIX=$SPACESHIP_PROMPT_DEFAULT_SUFFIX        # Suffix after the Docker section
SPACESHIP_DOCKER_SYMBOL="docker "                               # Character to be shown before Docker version
SPACESHIP_DOCKER_COLOR="cyan"                                   # Color of Docker section
SPACESHIP_DOCKER_VERBOSE=false                                  # Show complete Docker version

# Docker Compose
SPACESHIP_DOCKER_COMPOSE_SHOW=true
SPACESHIP_DOCKER_COMPOSE_ASYNC=true
SPACESHIP_DOCKER_COMPOSE_PREFIX="with "
SPACESHIP_DOCKER_COMPOSE_SUFFIX=$SPACESHIP_PROMPT_DEFAULT_SUFFIX
SPACESHIP_DOCKER_COMPOSE_SYMBOL="compose "
SPACESHIP_DOCKER_COMPOSE_COLOR=cyan
SPACESHIP_DOCKER_COMPOSE_COLOR_UP=green
SPACESHIP_DOCKER_COMPOSE_COLOR_DOWN=red
SPACESHIP_DOCKER_COMPOSE_COLOR_PAUSED=yellow

# Google cloud
SPACESHIP_GCLOUD_SHOW=true
SPACESHIP_GCLOUD_ASYNC=true
SPACESHIP_GCLOUD_PREFIX="gcloud using "
SPACESHIP_GCLOUD_SUFFIX=$SPACESHIP_PROMPT_DEFAULT_SUFFIX
SPACESHIP_GCLOUD_SYMBOL=""
SPACESHIP_GCLOUD_COLOR=white

# Execution time
SPACESHIP_EXEC_TIME_SHOW=true                                   # Show execution time
SPACESHIP_EXEC_TIME_PREFIX="took "                              # Prefix before execution time section
SPACESHIP_EXEC_TIME_SUFFIX=$SPACESHIP_PROMPT_DEFAULT_SUFFIX     # Suffix after execution time section
SPACESHIP_EXEC_TIME_COLOR="yellow"                              # Color of execution time section
SPACESHIP_EXEC_TIME_ELAPSED=2                                   # The minimum number of seconds for showing execution time section

# Ordem das seções no prompt
SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  gcloud         # Google Cloud Platform section
  node          # Node.js section
  venv          # virtualenv section
  docker        # Docker section
  docker_compose # Docker section
  ruby          # Ruby section
  java          # Java section
  uv             # uv section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
