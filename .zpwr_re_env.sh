#!/usr/bin/env bash
#{{{                    MARK:Header
#**************************************************************
##### Author: MenkeTechnologies
##### GitHub: https://github.com/MenkeTechnologies
##### Date: Fri Aug 28 16:10:06 EDT 2020
##### Purpose: bash/zsh script to hold refreshable env vars
##### Notes:
#}}}***********************************************************

#{{{                    MARK:env vars to re eval after sourcing tokens
#**************************************************************
type -a ZPWR_VARS 1>/dev/null 2>&1 || declare -A ZPWR_VARS

type -a evalIfNeeded 1>/dev/null 2>&1 || function evalIfNeeded() {

    local name current prev
    name="$1"
    current="$2"
    wanted="$3"

    # first time sourced from .zpwr_env.sh
    if [[ -z "$current" ]]; then
        # when no env var from env pre zpwr and first time this file is read
        eval "export $name=\"$wanted\""
        ZPWR_VARS[prev_$name]="$wanted"
        return 0
    elif [[ -z "${ZPWR_VARS[prev_$name]}" ]]; then
        # when env var from zshenv but first time this file is read
        # overwrite it b/c all zpwr config must be done in zpwr except $ZPWR
        eval "export $name=\"$wanted\""
        ZPWR_VARS[prev_$name]="$wanted"
        return 0
    fi

    # no user changes to environment variable
    if [[ "$current" == "$wanted" ]]; then
        return 0
    fi
    prev=${ZPWR_VARS[prev_$name]}

    if [[ "$current" == "$prev" ]]; then
        # user has made change to base variables so reexport
        eval "export $name=\"$wanted\""
        # save prev state
        ZPWR_VARS[prev_$name]="$wanted"
        return 0
    fi
    # user has made direct change to env variable so leave alone
}

# the base dir for zpwr configs
test -z "$ZPWR" && export ZPWR="$HOME/.zpwr"
# local file ignored by git
evalIfNeeded ZPWR_LOCAL "$ZPWR_LOCAL" "$ZPWR/local" "$ZPWR"
# autoloaded non completion functions
evalIfNeeded ZPWR_AUTOLOAD "$ZPWR_AUTOLOAD" "$ZPWR/autoload" "$ZPWR"
# autoloaded common non completion functions
evalIfNeeded ZPWR_AUTOLOAD_COMMON "$ZPWR_AUTOLOAD_COMMON" "$ZPWR_AUTOLOAD/common" "$ZPWR_AUTOLOAD"
# autoloaded darwin non completion functions
evalIfNeeded ZPWR_AUTOLOAD_DARWIN "$ZPWR_AUTOLOAD_DARWIN" "$ZPWR_AUTOLOAD/darwin" "$ZPWR_AUTOLOAD"
# autoloaded linux non completion functions
evalIfNeeded ZPWR_AUTOLOAD_LINUX "$ZPWR_AUTOLOAD_LINUX" "$ZPWR_AUTOLOAD/linux" "$ZPWR_AUTOLOAD"
# autoloaded systemctl non completion functions
evalIfNeeded ZPWR_AUTOLOAD_SYSTEMCTL "$ZPWR_AUTOLOAD_SYSTEMTCTL" "$ZPWR_AUTOLOAD/systemctl" "$ZPWR_AUTOLOAD"
# autoloaded completion functions
evalIfNeeded ZPWR_COMPS "$ZPWR_COMPS" "$ZPWR/comps" "$ZPWR"
# OMZ custom plugin dir
evalIfNeeded ZPWR_PLUGIN_DIR "$ZPWR_PLUGIN_DIR" "$ZSH_CUSTOM/plugins" "$ZSH_CUSTOM"
# same as zpwr local
evalIfNeeded ZPWR_HIDDEN_DIR "$ZPWR_HIDDEN_DIR" "$ZPWR/local" "$ZPWR"
# private tokens file sourced before
evalIfNeeded ZPWR_TOKEN_PRE "$ZPWR_TOKEN_PRE" "$ZPWR_LOCAL/.tokens.sh" "$ZPWR_LOCAL"
# private tokens file sourced after
evalIfNeeded ZPWR_TOKEN_POST "$ZPWR_TOKEN_POST" "$ZPWR_LOCAL/.tokens-post.sh" "$ZPWR_LOCAL"
evalIfNeeded ZPWR_TEST "$ZPWR_TEST" "$ZPWR/tests" "$ZPWR"
# zpwr install files
evalIfNeeded ZPWR_INSTALL "$ZPWR_INSTALL" "$ZPWR/install" "$ZPWR"
# zpwr tmux config files
evalIfNeeded ZPWR_TMUX "$ZPWR_TMUX" "$ZPWR/.tmux" "$ZPWR"
# zpwr tmux git ignored files
evalIfNeeded ZPWR_TMUX_LOCAL "$ZPWR_TMUX_LOCAL" "$ZPWR_TMUX/local" "$ZPWR_TMUX"
# the base dir for zpwr temp
evalIfNeeded ZPWR_HIDDEN_DIR_TEMP "$ZPWR_HIDDEN_DIR_TEMP" "$ZPWR_LOCAL/.temp" "$ZPWR_LOCAL"
# the path to a lock file (semaphore) for zpwr
evalIfNeeded ZPWR_LOCK_FILE "$ZPWR_LOCK_FILE" "$ZPWR_LOCAL/.lock" "$ZPWR_LOCAL"
# cache file for all zpwr env lookups
evalIfNeeded ZPWR_ENV "$ZPWR_ENV" "$ZPWR_LOCAL/zpwrEnv" "$ZPWR_LOCAL"
# forked powerlevel9k config file for PROMPT
evalIfNeeded ZPWR_PROMPT_FILE "$ZPWR_PROMPT_FILE" "$ZPWR/.powerlevel9kconfig.sh" "$ZPWR"
# the location of associated interpreted scripts
evalIfNeeded ZPWR_SCRIPTS "$ZPWR_SCRIPTS" "$ZPWR/scripts" "$ZPWR"
# the location of macOS only associated interpreted scripts
evalIfNeeded ZPWR_SCRIPTS_MAC "$ZPWR_SCRIPTS_MAC" "$ZPWR_SCRIPTS/macOnly" "$ZPWR_SCRIPTS"
# the location of zpwr lib file
evalIfNeeded ZPWR_LIB "$ZPWR_LIB" "$ZPWR_SCRIPTS/lib.sh" "$ZPWR_SCRIPTS"
# the location of zpwr init file
evalIfNeeded ZPWR_LIB_INIT "$ZPWR_LIB_INIT" "$ZPWR_SCRIPTS/init.sh" "$ZPWR_SCRIPTS"
# command for all fzf clearlist in preview pane
evalIfNeeded ZPWR_FZF_CLEARLIST "$ZPWR_FZF_CLEARLIST" "zsh $ZPWR_SCRIPTS/clearList.zsh -- \\\$file | fold -s -w 80" "$ZPWR_SCRIPTS"
# when ZPWR_USE_NEOVIM=true this the file used to find most recent files opened in neovim
evalIfNeeded ZPWR_NVIMINFO "$ZPWR_NVIMINFO" "$ZPWR_LOCAL/.nviminfo" "$ZPWR_LOCAL"
# emacs recent files
evalIfNeeded ZPWR_RECENTF "$ZPWR_RECENTF" "$HOME/.emacs.d/.cache/recentf" "$HOME"
# alternate banner to ponysay
evalIfNeeded ZPWR_DEFAULT_BANNER "$ZPWR_DEFAULT_BANNER" "bash $ZPWR_SCRIPTS_MAC/figletRandomFontOnce.sh $(hostname)" "$ZPWR_SCRIPTS_MAC"
# zpwr banner file location
evalIfNeeded ZPWR_BANNER_SCRIPT "$ZPWR_BANNER_SCRIPT" "$ZPWR_SCRIPTS/about.sh" "$ZPWR_SCRIPTS"
# list of git dirs
evalIfNeeded ZPWR_ALL_GIT_DIRS "$ZPWR_ALL_GIT_DIRS" "$ZPWR_LOCAL/zpwrGitDirs.txt" "$ZPWR_LOCAL"
# log file
evalIfNeeded ZPWR_LOGFILE "$ZPWR_LOGFILE" "$ZPWR_LOCAL/zpwrLog.txt" "$ZPWR_LOCAL"
# cache of env keys
evalIfNeeded ZPWR_ENV_KEY_FILE "$ZPWR_ENV_KEY_FILE" "${ZPWR_ENV}Key.txt" "$ZPWR_ENV"
# cache of env values
evalIfNeeded ZPWR_ENV_VALUE_FILE "$ZPWR_ENV_VALUE_FILE" "${ZPWR_ENV}Value.txt" "$ZPWR_ENV"
# temp files
evalIfNeeded ZPWR_TEMPFILE "$ZPWR_TEMPFILE" "$ZPWR_HIDDEN_DIR_TEMP/.temp$$-$USER" "$ZPWR_HIDDEN_DIR_TEMP" "$USER"
evalIfNeeded ZPWR_TEMPFILE1 "$ZPWR_TEMPFILE1" "$ZPWR_HIDDEN_DIR_TEMP/.temp$$-1$USER" "$ZPWR_HIDDEN_DIR_TEMP" "$USER"
evalIfNeeded ZPWR_TEMPFILE2 "$ZPWR_TEMPFILE2" "$ZPWR_HIDDEN_DIR_TEMP/.temp$$-2$USER" "$ZPWR_HIDDEN_DIR_TEMP" "$USER"
evalIfNeeded ZPWR_TEMPFILE3 "$ZPWR_TEMPFILE3" "$ZPWR_HIDDEN_DIR_TEMP/.temp$$-3$USER" "$ZPWR_HIDDEN_DIR_TEMP" "$USER"
evalIfNeeded ZPWR_TEMPFILE4 "$ZPWR_TEMPFILE4" "$ZPWR_HIDDEN_DIR_TEMP/.temp$$-4$USER" "$ZPWR_HIDDEN_DIR_TEMP" "$USER"
# SQL temp files for use with learning collection
evalIfNeeded ZPWR_TEMPFILE_SQL "$ZPWR_TEMPFILE_SQL" "$ZPWR_HIDDEN_DIR_TEMP/.temp$$-2$USER.sql" "$ZPWR_HIDDEN_DIR_TEMP" "$USER"
# remove all files in these dirs, modify this in your tokens file
# common dirs
evalIfNeeded ZPWR_D "$ZPWR_D" "$HOME/Desktop" "$HOME"
evalIfNeeded ZPWR_DOC "$ZPWR_DOC" "$HOME/Documents" "$HOME"
evalIfNeeded ZPWR_DL "$ZPWR_DL" "$HOME/Downloads" "$HOME"
# history file
evalIfNeeded HISTFILE "$HISTFILE" "$HOME/.$ZPWR_REPO_NAME-$ZPWR_GITHUB_ACCOUNT-history" "$HOME" "$ZPWR_REPO_NAME" "$ZPWR_GITHUB_ACCOUNT"
# the path for vim keybindings cache
evalIfNeeded ZPWR_VIM_KEYBINDINGS "$ZPWR_VIM_KEYBINDINGS" "$ZPWR_LOCAL/zpwrVimKeybindings.txt" "$ZPWR_LOCAL"
# the path for all keybindings cache
evalIfNeeded ZPWR_ALL_KEYBINDINGS "$ZPWR_ALL_KEYBINDINGS" "$ZPWR_LOCAL/zpwrAllKeybindings.txt" "$ZPWR_LOCAL"
evalIfNeeded GITHUB_ACCOUNT "$GITHUB_ACCOUNT" "$ZPWR_GITHUB_ACCOUNT" "$ZPWR_GITHUB_ACCOUNT"
evalIfNeeded ZPWR_GITHUB_URL "$ZPWR_GITHUB_URL" "https://github.com/$ZPWR_GITHUB_ACCOUNT" "$ZPWR_GITHUB_ACCOUNT"
#}}}***********************************************************
