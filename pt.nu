def remote_username [username: string] {
    if $username == null { "developer"}  else { $username }
}

def base_path_from_url [url: string] {
    $url | split row '//'  | get 1 | split row '/' | range 0..-2 | str join '/'
}

def local_path_from_url [url: string local_dir: string] {
    let base_path = (base_path_from_url $url)
    let project_name = ($url | split row '/' | last | split row '.' | first)
    $"($local_dir)/($base_path)/($project_name)"
}

def mirror_to_remote_host [
    src: string
    dest_host: string
    dest_path: string
    --username: string
    ] {
    let username = (remote_username $username)
    print $"Rsync ($src) to ($dest_path)"
    rsync -r -L  $src $"($username)@($dest_host):($dest_path)/"
}


export def pull [repo_url: string --mirror_to_host: string --remote_user: string] {
    let remote_user = remote_username $remote_user
    let editor = "goland"
    let local_dir = $"($nu.home-path)/src"

    let local_project_path = (local_path_from_url $repo_url $local_dir)
    let create_project_dir = if ($local_project_path | path exists) == true { false } else { true }
    print $local_project_path
    if $create_project_dir {
        print $local_project_path
        mkdir   $local_project_path
        ^git clone --progress $repo_url $local_project_path
    }
    if $mirror_to_host != null {
        let remote_project_path = (local_path_from_url $repo_url $"/home/($remote_user)/src")
            ssh $mirror_to_host mkdir -p $remote_project_path
            mirror_to_remote_host  $"($local_project_path)/*" $mirror_to_host  $"($remote_project_path)" --username $remote_user
    } else {
        ^$editor $local_project_path
    }
}