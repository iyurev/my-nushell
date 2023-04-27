let home = '/Users/iyurev'
let user_bin = $"($home)/.local/bin"
let brew_bin = '/opt/homebrew/bin/'
let local_bin = '/usr/local/bin'
let go_path = $"($home)/go"
let go_bin = $"($go_path)/bin"

let-env GO_PATH = $go_path

let-env PATH = ($env.PATH | split row (char esep) | prepend $user_bin | prepend $brew_bin | append $go_bin | append $local_bin) 

let-env HOME = $home

let my_nushell = $"($home)/Documents/github.com/iyurev/my-nushell"

source  ~/.nu/kind.nu
source  ~/.nu/tools.nu
use ~/.nu/gc.nu
use ~/.nu/ansible.nu
use  ~/.nu/scm.nu
use  ~/.nu/ks.nu
use ~/.nu/kubectl.nu *
use ~/.nu/ts.nu 



