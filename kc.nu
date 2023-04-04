    def verbs [] {
        ["get", "create", "delete", "apply", "help", "version"]
    }

    def objects [] {
        [   "pod",
            "namespace",
            "node",
            "deployment",
            "rc",
            "statefulset",
            "crd"]
    }


    def objects-with-descriptions [] {
        [  { value: "pod", description: "Pod is a set of containers running in the same namespace."},
            {value: "namespace", description: "K8S project namespace."},
        ]
    }

    def formats [] {

        [
            "yaml",
            "json",
            "wide"
        ]

    }

def main_cmd [] {'kubectl'}


export def kc-get [obj: string@objects name?: string  --output: string@formats --namespace: string@list-namespaces] {
    let format = if $output == null { "" } else { $output }
    let namespace = if $namespace == null  and  $env.KUBE_NAMESPACE != null {$env.KUBE_NAMESPACE} else if $namespace == null  and  $env.KUBE_NAMESPACE == null {"default"} else { $namespace }
    let default_args = ['get', $obj, '-o', $format, '-n', $namespace]
    let args = if $name == null { $default_args } else { $default_args | append $name }
    run-external $"(main_cmd)" $args
}

export def kc-get-all-failed-pods [] {
        kc-get-in-all-namespaces  pods | where status.phase == "Failed" | select  metadata.namespace metadata.name status.phase
}

    def kc-get-in-all-namespaces [kind: string] {
    kc get $kind -A -ojson  | from json | get items
}


export def kc-get-by-label [namespace: string kind: string@objects label: string] {
    kc -n $namespace get -l $label  $kind -oname
}

def psmdb-get-all-namespaces [] {
    kc-get-in-all-namespaces  perconaservermongodbs  | select metadata.namespace
}

def scale-psmdb-operator [replicas: string] {
let all_ns = (kc-get-in-all-namespaces  perconaservermongodbs  | select metadata.namespace) 
for ns in $all_ns { let namespace = ($ns | get metadata_namespace ); let dep_name = (kc-get-by-label $namespace deployment app.kubernetes.io/name=psmdb-operator | into string | str trim); kc -n $namespace scale $dep_name $"--replicas=($replicas)"  } 

}

def list-namespaces [] {
    kubectl get ns -ojson | jq   '.items[].metadata.name'| jq  -s | from json
}

def list-kubeconfigs [] {
    ls  ~/.kube/ | where type == file | get name 
}

def list-clusters [] {
    open $env.KUBECONFIG  | from yaml | get clusters | get name
}

export def-env kc-set-kubeconfig [path: string@list-kubeconfigs] {
    print $"Use kubeconfig: ($path)"
    let-env KUBECONFIG = $path    
}

export def-env kc-set-namespace [namespace: string@list-namespaces] {
    print $"Work with namespace: ($namespace)"
    let-env KUBE_NAMESPACE = $namespace
}


export def-env kc-set-context [namespace: string@list-namespaces] {
   
}

###Kubectl 
def list-objects-in-namespace [namespace: string kind: string] {
    kubectl -n $namespace get  $kind -ojson | jq   '.items[].metadata.name'| jq  -s | from json
}
#kubectl api-resources - kubectl api-resources | dtc | select NAME

export def kc-search-ns [name: string] {
    kubectl get ns -ojson | from json | get items |  where  metadata.name =~ $name | get metadata.name
}