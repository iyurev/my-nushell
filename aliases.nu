
alias ll = ls -la

alias lsd = (ls -la | where type == dir)

#alias rld-conf =  source "~/Library/Application Support/nushell/config.nu"
#alias rld-env =  source "~/Library/Application Support/nushell/env.nu"
#alias r = source "~/Library/Application Support/nushell/config.nu";  source "~/Library/Application Support/nushell/env.nu"
alias edit-nu-conf = code $nu.config-path
alias edit-nu-env = code $nu.env-path

alias kc = kubectl

alias edit-my-nushell = code $my_nushell
alias dtc = detect columns
alias nv = nvim

