
let user_bin = $"($nu.home-path)/.local/bin"
let brew_bin = '/opt/homebrew/bin/'
let local_bin = '/usr/local/bin'

$env.GO_PATH = $"($nu.home-path)/go"
$env.GO_ROOT = $"($local_bin)/go"
$env.HOME = $nu.home-path
$env.PATH = ($env.PATH | split row (char esep) | prepend $user_bin | prepend $brew_bin | append $"($env.GO_PATH)/bin" | append $local_bin)

use  ~/.nu/kd.nu
use ~/.nu/k3d.nu *
use  ~/.nu/tools.nu *
use ~/.nu/gc.nu
#use ~/.nu/ansible.nu
use  ~/.nu/scm.nu
use  ~/.nu/ks.nu
use ~/.nu/ts.nu 
use ~/.nu/tg.nu *
use ~/.nu/tf.nu *
