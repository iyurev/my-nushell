export def ssl-get-server-cert [host: string] {
    openssl s_client -showcerts -connect $"($host):443" 
}

export def ssl-check-cert [cert_file: string] {
    openssl x509 -in  $cert_file -text 
}

export def passwd-hash [] {
    openssl  passwd -6
}

export def git-time-tag [branch: string] {
    $"(date now | date format '%Y%m%d%H%M')-($branch)"
}

export def ps-grep [name: string] {
    ps | where name =~ $name
}

export def ssh-xterm [host: string] {
    TERM=xterm-256color ssh $host
}
#List only directories in the current location.
export def lsd [] {
   (ls -la | where type == dir)
}


export def git-squash-commits [
    branch_name: string
    commit_message: string
    --source_branch: string = "master"
] {
    let temp_branch = $"($branch_name)-temp"
    ^git checkout -b $temp_branch
    ^git checkout $branch_name
    ^git fetch
    ^git reset --hard $"origin/($source_branch)"
    ^git merge --squash $temp_branch
    ^git commit -m $commit_message
}

def ansible_container_images [] {
    [
        "ghcr.io/ansible/creator-ee:v0.13.0",
    ]
}

export def ansible-shell [--image: string@ansible_container_images] {
    let wd = $"($env.PWD):/workspace"
    docker run -ti --rm -v $wd  -w /workspace $image sh
    
}

