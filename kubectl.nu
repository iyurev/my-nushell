def output_formats [] {
    [
    "yaml",
    "json",
    "wide"
    ]
}

def resource_kinds_dynamic [] {
    kubectl api-resources | dtc | get NAME
}


#Get kubernetes resources
export extern "kubectl get" [
    kind: string@resource_kinds_dynamic
    --all-namespaces(-A)  #Get from all namespaces
    --output(-o): string@output_formats #Output format 
    --selector(-l): string #Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2). Matchingobjects must satisfy all of the specified label constraints.
    --filename(-f): string #Filename, directory, or URL to files identifying the resource to get from a server.
    --watch(-w): #After listing/getting the requested object, watch for changes.
]