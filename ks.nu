def list-namespaces [] {
    kubectl get ns --output json | from json | get items | get metadata.name
}



export  def ks-set-context [namespace: string@list-namespaces] {
        print $namespace
}