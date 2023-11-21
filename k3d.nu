def cluster_already_exists [err: string] {
    let err_suffix = 'because a cluster with that name already exists'
    $err | str contains $err_suffix
}
def list-cluster-names [] { ^k3d cluster list -oyaml | from yaml | get name }


def-env export_cluster_credentials [cluster_name: string] {
    let kubeconfig_path = (^k3d kubeconfig write $cluster_name)
    $env.KUBECONFIG = $kubeconfig_path
    $env.KUBE_CONFIG_PATH = $kubeconfig_path
}

#Shortcut for creating DEV K8S clusters
export def-env k3d-cluster-create [
    name: string #Kubernetes cluster name
    --expose_ingress: bool #Expose tcp/80 and tcp/443 network ports from cluster nodes
    --export_kubeconfig: bool = true #Export environment variable KUBECONFIG
    --recreate #Recreate cluster if it exists.
    ] {
    if $recreate  {
        cluster-delete $name
    }
    let default_args = ["cluster", "create", $name, "--kubeconfig-update-default=false"]
    let expose_ingress_args = ["--port",  "80:80@loadbalancer", "--port", "443:443@loadbalancer"]
    let args = if $expose_ingress == true { $default_args | append expose_ingress_args  } else { $default_args }
    print $"Creating dev k8s cluster, name: ($name)"
    let result = (do -i { ^k3d $args } | complete)
    let err =  ($result | get stderr)
    if $err != "" {
        if (cluster_already_exists $err) {
            if $export_kubeconfig {
            export_cluster_credentials $name
            }
            print "Cluster already exists, nothing to do."
            return
        }
    }
  sleep 2sec
  let kubeconfig_path = (^k3d kubeconfig write $name)
  if $export_kubeconfig {
        export_cluster_credentials $name
  }
  return $kubeconfig_path
}

#Create a bunch of dev k8s clusters
export def k3d-cluster-bunch [
    base_name: string #Base cluster name.
    cluster_numbers: int #Number of clusters that we should create
] {
    for count in 1..$cluster_numbers {
        let cluster_name = $"($base_name)-($count)" 
        let kubeconfig_path = (cluster-create $cluster_name --export_kubeconfig=false)
        print $"Cluster successfully created, kubeconfig path: ($kubeconfig_path)"
    }
}

#Delete DEV k8s cluster
export def k3d-cluster-delete [
    name: string@list-cluster-names #Cluster name
] {
    let cluster_name = if $name == "all" { "--all" } else { $name }
    ^k3d cluster delete $cluster_name
}
#List all existing K8S clusters.
export def clusters-list [] {
    list-cluster-names
}


#cluster create -v $"($env.PWD)/manifests:/var/lib/rancher/k3s/server/manifests/additional@server:0"  hcp-01-dev