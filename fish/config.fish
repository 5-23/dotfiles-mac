if status is-interactive
    # Commands to run in interactive sessions can go here
end

# init cargo and rust
set -gx PATH "$HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/" $PATH;
set -gx PATH "/usr/local/bin" $PATH;
set -gx PATH "$HOME/.nix-profile/bin" $PATH;
set -gx PATH "$HOME/programs" $PATH;
set -gx PATH "/opt/homebrew/bin" $PATH;
set -gx PATH "/nix/var/nix/profiles/default/bin" $PATH;
set -gx PATH "$HOME/.cargo/bin" $PATH;
set -gx PATH "$HOME/.codon/bin" $PATH;
set -gx PATH "$HOME/go/bin" $PATH;
set -x OPENAI_KEY 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
set -gx PATH "$HOME/.local/bin/" $PATH;
# set -x QT_QPA_PLATFORM wayland

# variables
set -fx EDITOR hx
set -gx QT_STYLE_OVERRIDE kvantum
set -gx BAT_THEME Catppuccin-macchiato
set -x STARSHIP_CONFIG ~/.config/starship/starship.toml 

set -Ux FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# alias
alias ls 'eza --icons -x'
alias la 'eza --icons -a'
alias dir 'eza --icons -x'
alias vi-off 'fish_default_key_bindings'
alias vi-on 'fish_vi_key_bindings'
alias cat 'bat -p'
alias helix 'hx'
alias pkm 'python3 $HOME/.config/poke/poke.py'

alias brew "/opt/homebrew/bin/brew"
# remove greeting
set -U fish_greeting


zoxide init fish --cmd cd | source
starship init fish | source

#random pokemon
pkm --random --no-title

function ls
    if count $argv > /dev/null
        if contains -- $argv --tree
            command eza --icons --tree
        else if contains -- $argv -lah
            command eza -lah
        else if contains -- $argv -a
            command eza -a
        else
            set target_file (realpath $argv[1])
            if test -f $target_file
                bat $target_file
            else
                command eza $argv
            end
        end
    else
        command eza --icons -x
    end
end
function pastebin
    set file_path $argv[1]
    set paste_url (curl -s --data-binary @$file_path https://paste.rs/)
    echo $paste_url | wl-copy
    echo "Link copied to clipboard: ' $paste_url '"
end
function battery_health_percentage
    # Get battery information using upower
    set battery_info (upower -i $(upower -e | grep 'BAT') 2>/dev/null)

    # Check if battery_info is empty (no battery found)
    if test -z "$battery_info"
        echo "Battery not found"
        return
    end

    # Extract the design capacity and the last full capacity from battery_info
    set design_capacity (echo "$battery_info" | grep -oP 'energy-full-design:\s*\K\d+')
    set last_full_capacity (echo "$battery_info" | grep -oP 'energy-full:\s*\K\d+')

    if test -z "$design_capacity" -o -z "$last_full_capacity"
        echo "Design or last full capacity not available"
        return
    end

    # Calculate the battery health percentage
    set health_percentage (math "$last_full_capacity / $design_capacity * 100")

    echo "Battery Health: $health_percentage%"
end
