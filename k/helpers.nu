export def list-namespaces [] {
    ^kubectl get ns --output json | from json | get items | get metadata.name
}

export def list_resources_compl [context: string] {
     
   let  kind = (get_kind_from_ctx $context)
 
   let namespace = (get_namespace_from_ctx $context)

   let resources = (^kubectl --namespace $namespace  get $kind  -ojson | from json | get items | get metadata.name)
   
   return $resources
   
}



export def get_namespace_from_ctx [context: string] {

   let ns = ($context | split row  -r '\s+' | uniq | get 3  | str trim)

   return $ns
}

export def get_kind_from_ctx [context: string] {

   let kind = ($context | split row  -r '\s+' | uniq | get 2  | str trim)

   return $kind
}



export def list_deployments_compl [
    context: string
    
] {
    return (list_resources_compl $context)
}

export def list_pods_compl [
    context: string
    
] {
    return (list_resources_compl $context)
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