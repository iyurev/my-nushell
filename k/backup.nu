export def backup-and-edit [
    namespace: string
    kind: string
    name: string
    
] { 
    let time_now = (date now  | format date "%Y-%m-%d_%H-%M-%S")
    let backup_file = $"./($namespace)_($kind)_($name).backup-($time_now).yaml"
    let to_edit_file = $"./($namespace)_($kind)_($name).yaml"

    ^kubectl -n $namespace get  $kind $name -oyaml | save $backup_file
    cp $backup_file $to_edit_file

    code $to_edit_file
}