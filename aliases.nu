
alias ll = ls -la

alias lsd = (ls -la | where type == dir)

alias rld-conf =  source "~/Library/Application Support/nushell/config.nu"
alias rld-env =  source "~/Library/Application Support/nushell/env.nu"
#alias r = source "~/Library/Application Support/nushell/config.nu";  source "~/Library/Application Support/nushell/env.nu"
alias edit-nu-conf = code "~/Library/Application Support/nushell/config.nu"
alias edit-nu-env = code "~/Library/Application Support/nushell/env.nu"

alias kc = kubectl

alias edit-my-nushell = code $my_nushell
#alias ssh = TERM="xterm-256color" ssh
alias to = z
alias dtc = detect columns