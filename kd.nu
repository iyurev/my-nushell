
def verbs [] {
    [
        "create",
        "get",
        "delete"
    ]
}


def create-cluster-flags [] {
    [
        {value: "--config", description: "path to a kind config file"},
        {value: "--image", description: "node docker image to use for booting the cluster"},
        {value: "--kubeconfig", description: "sets kubeconfig path instead of $KUBECONFIG or $HOME/.kube/config"},

    ]
}

export def-env create [name: string] {
    let kubeconfig_path  = $"/tmp/($name)-kubeconfig"
    kind create cluster  --name ($name) --kubeconfig ($kubeconfig_path)
    let-env KUBECONFIG = $kubeconfig_path
    let-env KUBE_CONFIG_PATH = $kubeconfig_path
}

export def list [] {
    kind get clusters 
     
}
export def delete [name: string] {
    if ($name == 'all') {
        kind delete clusters --all   
    } else {
        kind delete clusters  ($name) 
    }
}