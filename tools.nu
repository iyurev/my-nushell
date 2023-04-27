export def ssl-get-server-cert [host: string] {
    openssl s_client -showcerts -connect $"($host):443" 
}

export def ssl-check-cert [cert_file: string] {
    openssl x509 -in  $cert_file -text 
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
