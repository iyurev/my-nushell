export def list-namespaces [] {
    ^kubectl get ns --output json | from json | get items | get metadata.name
}

export def list_resources_compl [
        context: string
        resource_kind: string
        ] {
 
   let n = ($context | split row -n 3 " " | uniq | last | str trim)

   let resources = (^kubectl --namespace $n  get $resource_kind  -ojson | from json | get items | get metadata.name)
   
   return $resources
   
}

export def list_deployments_compl [
    context: string
    
] {
    return (list_resources_compl $context "deployment")
}

export def list_pods_compl [
    context: string
    
] {
    return (list_resources_compl $context "pod")
}


def list-kubeconfigs [] {
    ls  ~/.kube/ | where type == file | get name 
}

def list-contexts [] {
    ^kubectl config get-contexts -o name | lines
}

def list-clusters [] {
    ^kubectl config  get-clusters  | lines 
}


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