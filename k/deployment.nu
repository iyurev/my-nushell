use helpers.nu *

export def "get deployment" [
    namespace: string@list-namespaces
    name: string@list_deployments_compl
    --spec-only
    --containers-only
    --resources-only
    --pod-metadata
] {

    let main_res = (^kubectl -n $namespace get deployment $name -oyaml | from yaml)

    if $spec_only {
        return ($main_res | get spec  )
    }

    if $containers_only {
        return ($main_res | get spec.template.spec.containers)
    }
    if $resources_only {
        return ($main_res | get spec.template.spec.containers | select -i name image resources.requests resources.limits)
    }
    if $pod_metadata  {
        return ($main_res | get spec.template.metadata)
    }

   return $main_res
}

export def get-deployment-pretty-yaml [
    namespace: string@list-namespaces
    name: string@list_deployments_compl
    --bat 
] {  
    let raw_data = (get-deployment $namespace $name)

     if $bat {
        $raw_data | to yaml | bat -l yaml
     }   
     
    $raw_data | to yaml | yq
}

