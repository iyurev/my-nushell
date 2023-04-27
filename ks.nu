def resource_kind_dynamic [] {
    kubectl api-resources | dtc | get NAME
}


def list-namespaces [] {
    kubectl get ns --output json | from json | get items | get metadata.name
}

def list-kubeconfigs [] {
    ls  ~/.kube/ | where type == file | get name 
}

def list-clusters [] {
    open $env.KUBECONFIG  | from yaml | get clusters | get name
}

def kc-get-in-all-namespaces [kind: string] {
    kc get $kind -A -ojson  | from json | get items
}

export def-env set-namespace [namespace: string@list-namespaces] {
    print $"Work with namespace: ($namespace)"
    let-env KUBE_NAMESPACE = $namespace
}

export def-env set-kubeconfig [path: string@list-kubeconfigs] {
    print $"Use kubeconfig: ($path)"
    let-env KUBECONFIG = $path    
}

export def search-ns [name: string] {
    kubectl get ns -o json | from json | get -i items |  where  metadata.name =~ $name | get metadata.name
}

export def get-by-label [namespace: string@list-namespaces kind: string@resource_kind_dynamic label: string] {
    kubectl -n $namespace get -l $label  $kind -oname
}

export def get-all-failed-pods [] {
        kc-get-in-all-namespaces  pods | where status.phase == "Failed" | select  metadata.namespace metadata.name status.phase
}





