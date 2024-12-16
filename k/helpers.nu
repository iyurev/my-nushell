

export def list_resources_compl [context: string] {
     
   let  kind = (get_kind_from_ctx $context)
 
   let namespace = (get_namespace_from_ctx $context)

   let resources = (^kubectl --namespace $namespace  get $kind  -ojson | from json | get items | get metadata.name)
   
   return $resources
   
}

export def list_cluster_resources_compl [context: string] {
     
   let  kind = (get_kind_from_ctx $context)
 

   let resources = (^kubectl  get $kind  -ojson | from json | get items | get metadata.name)
   
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



def list-kubeconfigs [] {
    ls  ~/.kube/ | where type == file | get name 
}

def list-contexts [] {
    ^kubectl config get-contexts -o name | lines
}

def list-clusters [] {
    ^kubectl config  get-clusters  | lines 
}

export def list-namespaces [] {
    ^kubectl get ns --output json | from json | get items | get metadata.name
}




