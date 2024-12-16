
#Extract .CONTAINERS information from controller resource or pod
export def "select containers" [
    name?: string
    --option: string@containers_select_options

]: record -> any {

    let containers = if $in.kind == "Pod" { $in.spec.containers } else { $in.spec.template.spec.containers  }

        if $name != null {
            return ($containers | where name == $name)
        }

        match $option {
            null => $containers
            "resources" => ($containers | select -i name resources  )
            "summary" => ($containers | select -i name image imagePullPolicy ports  )
        }
    
}

def containers_select_options [] {
    [
        {value: "resources", description: "Get resource configuration for containers"}
        {value: "summary", description: "Get summary information about containers"}
    ]
    
}