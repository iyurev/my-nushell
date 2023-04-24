def output_formats [] {
    [
    "yaml",
    "json",
    "wide"
    ]
}

def resource_kind_dynamic [] {
    kubectl api-resources | dtc | get NAME
}

def namespace_from_ctx [ctx: string] {
    let cmd_list = ($ctx| split column (char space)  -c | get 0 | values)
    let namespace_name = (for --numbered  v in $cmd_list {  if $v.item == "-n" or $v.item == "--namespace" { return  ($cmd_list | get ($v.index + 1) ) }  } )
    $namespace_name
}

def resource_kind_from_ctx [ctx: string] {
    let all_kinds = (resource_kind_dynamic)
    let cmd_list =  ($ctx| split column (char space)  -c | get 0 | values)
    let kind_name = (for --numbered v in $cmd_list { if ($all_kinds | any {|kind_name| $kind_name == $v.item }) { return $v.item} })
    $kind_name
}

def resource_name_dynamic [ctx: string] {
    let kind = (resource_kind_from_ctx $ctx)
    kubectl -n (namespace_from_ctx $ctx) get $kind -ojson | from json | get items | get metadata.name
}

def list_namespaces [] {
    kubectl get ns -o json | from json | get items |  get metadata.name
}

#Get kubernetes resources
export extern "kubectl get" [
    kind: string@resource_kind_dynamic
    resource_name?: string@resource_name_dynamic #Resource name.
    --all-namespaces(-A)  #Get from all namespaces
    --output(-o): string@output_formats #Output format 
    --selector(-l): string #Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2). Matchingobjects must satisfy all of the specified label constraints.
    --filename(-f): string #Filename, directory, or URL to files identifying the resource to get from a server.
    --watch(-w) #After listing/getting the requested object, watch for changes.
    --namespace(-n): string@list_namespaces #Set context for kubernetes namespace.
]