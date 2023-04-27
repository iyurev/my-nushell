def output_formats [] {
    [
    "yaml",
    "json",
    "wide",
    "name",
    "go-template",
    "go-template-file",
    "template",
    "templatefile",
    "jsonpath",
	"jsonpath-as-json",
    "jsonpath-file"
    ]
}


def dry_run [] {["none", "server", "client"]}

def validate [] {
    [
        { value: "strict", description: " 'true' or 'strict' will use a schema to validate,  the input and fail the request if invalid. It will perform server side validation if ServerSideFieldValidation is enabled on the api-server, but will fall back to less reliable client-side validation if not."},
        { value: "true", description: " 'true' or 'strict' will use a schema to validate,  the input and fail the request if invalid. It will perform server side validation if ServerSideFieldValidation is enabled on the api-server, but will fall back to less reliable client-side validation if not."},
        "warn",
        "ignore",
        "false"
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
    kubectl -n (namespace_from_ctx $ctx) get $kind -o json | from json | get items | get metadata.name
}

def list_namespaces [] {
    kubectl get ns -o json | from json | get items |  get metadata.name
}

#Display one or many resources
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

# Show details of a specific resource or group of resources.
export extern "kubectl describe" [
    kind: string@resource_kind_dynamic
    resource_name?: string@resource_name_dynamic #Resource name.
    --all-namespaces(-A)  #Get from all namespaces
    --selector(-l): string #Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2). Matchingobjects must satisfy all of the specified label constraints.
    --filename(-f): string #Filename, directory, or URL to files to use to create the resource
    --kustomize(-k): string # Process the kustomization directory. This flag can't be used together with -f or -R.
    --recursive(-R) #Default: false. Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests #organized within the same directory.
    --chunk-size: int = 500  #Return large lists in chunks rather than all at once. Pass 0 to disable. This flag is beta and may change in the future.
    --show-events # If true, display events related to the described object.
]

#Create a resource from a file or from stdin.
export extern "kubectl create" [
    --dry-run : string@dry_run #Must be "none", "server", or "client". If client strategy, only print the object that would be sent, without sending it. If server strategy, submit server-side request without persisting the resource.

]

#Create a namespace with the specified name.
export extern "kubectl create namespace" [
    name: string
    --allow-missing-template-keys #If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.
    --dry-run: string@dry_run #Must be "none", "server", or "client". If client strategy, only print the object that would be sent, without sending it. If server strategy, submit server-side request without persisting the resource.
    --edit #Edit the API resource before creating
    --field-manager: string #Name of the manager used to track field ownership.
    --filename(-f): string #Filename, directory, or URL to files to use to create the resource
    --kustomize(-k): string # Process the kustomization directory. This flag can't be used together with -f or -R.
    --output(-o): string@output_formats ## Output format. One of: (json, yaml, name, go-template, go-template-file, template, templatefile, jsonpath, jsonpath-as-json, jsonpath-file).
    --raw: string # Raw URI to POST to the server.  Uses the transport specified by the kubeconfig file.
    --recursive(-R) #Default: false. Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests #organized within the same directory.
    --save-config #Default: false. # If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.
    --selector(-l): string # Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2). Matching # objects must satisfy all of the specified label constraints.
    --show-managed-fields #Default: false. If true, keep the managedFields when printing objects in JSON or YAML format.
    --template: string #Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format # is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
    --validate: string@validate # Must be one of: strict (or true), warn, ignore (or false).
    --windows-line-endings #Default: false. Only relevant if --edit=true. Defaults to the line ending native to your platform.
    --help #Get original help message.
]
#Create a service using a specified subcommand.
export extern "kubectl create service" [

]

#Create a ClusterIP service
export extern "kubectl create service clusterip" [
    name: string
    --validate: string@validate # Must be one of: strict (or true), warn, ignore (or false).
]


