

# _______ venv shortcuts _______
# Basically look for the current directory name and name the venv after it, instead of having a vanilla (.venv)
# ex, if i am inside a project named "tp_regexps", it will run :
# python3 -m venv .venv/tp_regexps -> mkenv
# source .venv/tp_regexps/bin/activate -> loadvenv
# 1. Create a venv based on the current directory name
mkvenv() {
    # 1. Set the python version: Use $1 if provided, otherwise default to 3.10
    local py_version="${1:-3.10}"
    local project_name="${PWD##*/}"
    local venv_path=".venv/$project_name"

    # 2. Check if the specified python version exists
    if ! command -v "python$py_version" &> /dev/null; then
        echo "Error: python$py_version is not installed."
        return 1 
    fi

    echo "Creating venv for project: $project_name using Python $py_version..."
    
    # 3. Create the venv using the specific version
    "python$py_version" -m venv "$venv_path"
    
    if [ $? -eq 0 ]; then
        echo "----------------------------------------"
        echo "✅ Success!"
        echo "Path:    $venv_path"
        # Echo the exact version information from the new venv
        echo "Version: $("$venv_path/bin/python" --version)"
        echo "To activate, run: loadvenv"
        echo "----------------------------------------"
    else
        echo "❌ Error: Failed to create virtual environment."
    fi
}

# 2. Activate the venv based on the current directory name
loadvenv() {
    local project_name="${PWD##*/}"
    local venv_path=".venv/$project_name/bin/activate"
    
    if [ -f "$venv_path" ]; then
        source "$venv_path"
        echo "Activated venv: $project_name"
    else
        echo "Error: No venv found at $venv_path"
        echo "Hint: Run 'mkvenv' first."
    fi
}






### --- Oh My Zsh Configuration ---

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="random" # Use this if you want random themes
ZSH_THEME="fwalch"

# Auto-update settings
zstyle ':omz:update' mode auto      # update automatically without asking

# --- Plugin Installation Logic (Auto-install if missing) ---
# Defines paths for custom plugins
_zsh_custom_plugin_path=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
_zsh_autosuggestion_path=${_zsh_custom_plugin_path}/zsh-autosuggestions
_zsh_syntax_highlighting_path=${_zsh_custom_plugin_path}/zsh-syntax-highlighting

# Clone zsh-autosuggestions if missing
if [ ! -d "$_zsh_autosuggestion_path" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$_zsh_autosuggestion_path"
fi

# Clone zsh-syntax-highlighting if missing
if [ ! -d "$_zsh_syntax_highlighting_path" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$_zsh_syntax_highlighting_path"
fi

# --- Plugins Configuration ---
# NOTE: zsh-syntax-highlighting MUST be the last plugin in the list
plugins=(
    git
    macos
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# --- Load Oh My Zsh ---
source $ZSH/oh-my-zsh.sh

# --- User Configuration ---

# Preferred editor
# export EDITOR='nvim'

# _______ Git Aliases _______
alias gl='git pull'
alias gp='git push'
alias gd='git diff'
alias gc='git commit --verbose'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status'
alias ga='git add'
alias glog='git log --oneline --graph --decorate --all'

# _______ FZF _______
# Load fzf (only if installed)
if command -v fzf >/dev/null; then
  source <(fzf --zsh)
fi

# _________ Pretty Startup _________

echo -e  
cat << "EOF"
         _,=.=,_
       ,'=.     `\___,
      /    \  (0     |        __ _
     /      \     ___/       /| | ''--.._
     |      |     \)         || |    ===|\
     ',   _/    .--'         || |   ====| |
       `"`;    (             || |    ===|/
          [[[[]]_..,_        \|_|_..--;"`
          /  .--""``\\          __)__|_
        .'       .\,,||___     |        |
  (   .'     -""`| `"";___)---'|________|__
  |\ /         __|   [_____________________]
   \|       .-'  `\        |.----------.|
    \  _           |       ||          ||
     (          .-' )      ||          ||
      `""""""""""""`      """         """  
------------------------------------------------
EOF
echo -e
