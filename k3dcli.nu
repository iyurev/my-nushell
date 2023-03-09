def cluster_already_exists [err: string] {
    let err_suffix = 'because a cluster with that name already exists'
    $err | str contains $err_suffix
}

#Shortcut for creating DEV K8S clusters
export def-env create-cluster [
    name: string #Kubernetes cluster name
    --expose_ingress: bool #Expose tcp/80 and tcp/443 network ports from cluster nodes
    ] {
    let k3d = "k3d"
    let default_args = ["cluster", "create", $name, "--kubeconfig-update-default=false"]
    let expose_ingress_args = ["--port",  "80:80@loadbalancer", "--port", "443:443@loadbalancer"]
    let args = if $expose_ingress == true { $default_args | append expose_ingress_args  } else { $default_args }
    $args
    let result = (do -i { ^$k3d $args } | complete)
    let err =  ($result | get stderr)
    if $err != "" {
        if cluster_already_exists $err {
            print "Cluster already exists, nothing to do."
            return
        }
    }
    # sleep 2sec
    # let kubeconfig_path = (^k3d kubeconfig write demo-01)
    # let-env KUBECONFIG = $kubeconfig_path
}

def list-cluster-names [] { k3d cluster list -oyaml | from yaml | get name }


#Delete DEV k8s cluster
export def delete-cluster [
    name: string@list-cluster-names #Cluster name
] {
    let cluster_name = if $name == "all" { "--all" } else { $name }
    k3d cluster delete $cluster_name
}

export def list-clusters [] {
    list-cluster-names
}


#cluster create -v $"($env.PWD)/manifests:/var/lib/rancher/k3s/server/manifests/additional@server:0"  hcp-01-dev