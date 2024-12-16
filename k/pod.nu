use helpers.nu *

export def "get pod" [
    namespace: string@list-namespaces
    name: string@list_resources_compl

] {
     return (^kubectl -n $namespace get pod $name -oyaml | from yaml)

}

export def "list pods" [
    namespace?: string@list-namespaces
    --option: string@list_pods_options

] { 
    let pods = if $namespace == null {
        (^kubectl get pod -A  -oyaml | from yaml | get items)
    } else {
        (^kubectl -n $namespace get pod -oyaml | from yaml | get items)
    }
       

     match $option {
        null => $pods
        "summary" => ($pods | select -i  metadata.name metadata.namespace  spec.nodeName status.phase status.podIP status.hostIP status.startTime)

     }

}


def list_pods_options [] {
    [
    {value: "summary", description: "Pods list summary"}
    ]
}

export def "logs pod" [
    namespace: string@list-namespaces
    name: string@list_resources_compl
    --tail:

] {
    if not $tail {
        ^kubectl -n $namespace logs $name
    } else {
        ^kubectl -n $namespace logs --tail=1000 -f $name
    }
     
}




