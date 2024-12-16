
use helpers.nu *



export def "get nodegroup" [
    name: string@list_cluster_resources_compl
    --spec
] {
    let ng = (^kubectl get ng $name -ojson | from json )

    if $spec {
        return ($ng | get spec)
    }

    return $ng 
}