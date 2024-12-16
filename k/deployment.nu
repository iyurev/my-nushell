use helpers.nu *

export def "get deployment" [
    namespace: string@list-namespaces
    name: string@list_resources_compl

] {

     return (^kubectl -n $namespace get deployment $name -oyaml | from yaml)

    
}

export def "list deployments" [
    namespace: string@list-namespaces
] {
    let all_deployments = (^kubectl -n $namespace get deployment -oyaml | from yaml)
    if ($all_deployments.items | length)  == 0 {
        print "there are no deployments in namespace"
        return
    }

    return ($all_deployments | get items | select metadata.name metadata.namespace)
}

