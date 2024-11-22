def remote_username [username: string] {
    if $username == null { "developer"}  else { $username }
}

def base_path_from_url [url: string] {
    $url | split row '//'  | get 1 | split row '/' | range 0..-2 | str join '/'
}

export def clone [
    repo_url: string
     --base_local_dir: string #Path to local directory, where we'd store a local copy of our git repositories
     --editor: string = "code" #Your favorite code editor.
     ] {
    let local_dir = if $base_local_dir == "" or $base_local_dir == null { $"($nu.home-path)/src" } else { $base_local_dir }
    let local_project_path = (local_path_from_git_url $local_dir $repo_url)
    let create_project_dir = if ($local_project_path | path exists) == true { false } else { true }
    print $"Using ($local_project_path) local path."
    if not ($local_project_path | path exists) {
        print  $"Ceating local directory ($local_project_path)"
        mkdir   $local_project_path
        print $"Clone remote git repository ($repo_url) to the local directory: ($local_project_path)"
        ^git clone --progress $repo_url $local_project_path
        ^$editor $local_project_path
    } else {
        ^$editor $local_project_path
    }
}

export def servers [] {
    ls -la $"($nu.home-path)/src/" | get name  | split column  '/src/' | get column2 |  str trim
}

export def update-zoxie-db [server_name: string@servers] {
    scm-projects $server_name | each {|project_path| zoxide add $project_path}
}

export def projects [server_name: string@servers] {
    run-external find $"($nu.home-path)/src/($server_name)/"  "-type" "d"  "-name" '.git'  | lines | split column '/.git' | get column1
}

export def projects-fzf [server_name: string@servers] {
      projects $server_name | to text | fzf
}

export def project-edit-in-vscode [server_name: string@servers] {
     code  (projects-fzf $server_name | str trim)

}


export def zoxide-list-all [] {
    zoxide  query --list | fzf 
}

export def is_ssh_url [url: string] {
    ($url | split column '@' | get -i column1 | get 0) == "git"
}

export def local_path_from_git_url [
        base_local_path: string #Path to local directory, where we'd store a local copy of our git repositories
        url: string #SSH or HTTP git repository URL.
        ] {
        let base_local_path = ($base_local_path | path expand)
        let url_to_dir = if (is_ssh_url $url) {
             ($url | split column "@"  | get column2 | str replace  ':' '/'  | split column '.git' | get column1 | get 0 | str trim)
        } else {
            ($url | url parse | $"($in.host)($in.path)" | split column '.git' | get column1 | get 0 | str trim)
        }
        $"($base_local_path)/($url_to_dir)" 
    } 
