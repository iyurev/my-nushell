def loggable_kinds [] {
    [
    "deployment"
    ]
}

def resource_kind_dynamic [] {
    ^kubectl api-resources | detect columns | get NAME
}


def list-namespaces [] {
    ^kubectl get ns --output json | from json | get items | get metadata.name
}

def list-kubeconfigs [] {
    ls  ~/.kube/ | where type == file | get name 
}

def list-contexts [] {
    ^kubectl config get-contexts -o name | lines
}

def list-clusters [] {
    ^kubectl config  get-clusters  | lines 
}

export def use-context [
    name: string@list-contexts
] {
    ^kubectl config use-context $name
}

def kc-get-in-all-namespaces [kind: string] {
    ^kubectl get $kind -A -o json  | from json | get items
}

export def --env set-namespace [namespace: string@list-namespaces] {
    print $"Work with namespace: ($namespace)"
    $env.KUBE_NAMESPACE = $namespace
    ^kubectl config  set-context --current $"--namespace=($namespace)"

}

export def --env set-kubeconfig [path: string@list-kubeconfigs] {
    print $"Use kubeconfig: ($path)"
    $env.KUBECONFIG = $path    
}

export def search-ns [name: string] {
    ^kubectl get ns -o json | from json | get -i items |  where  metadata.name =~ $name | get metadata.name
}

export def get-by-label [namespace: string@list-namespaces kind: string@resource_kind_dynamic label: string] {
    ^kubectl -n $namespace get -l $label  $kind -oname
}


export def get-all-failed-pods [] {
        kc-get-in-all-namespaces  pods | where status.phase == "Failed" | select  metadata.namespace metadata.name status.phase
}

export def get-all-pending-pods [] {
        kc-get-in-all-namespaces  pods | where status.phase == "Pending" | select  metadata.namespace metadata.name status.phase
}


export def logs-tail [
    namespace: string@list-namespaces
    name: string
    --kind: string@loggable_kinds = "deployment"

] {
    ^kubectl  --namespace $namespace logs -f --tail=1000 $"($kind)/($name)"
}

# Show standard Grafana URL
export def d8-grafana-url [] {
    let host = (^kubectl --namespace  d8-monitoring get ingress grafana-dex-authenticator -o yaml  | from yaml  | get spec.rules | get 0 | get host)
    print $"https://($host)"
}

export def d8-kibana-url [] {
    let host = (^kubectl --namespace  infra-elklogs  get ingress kibana -o yaml  | from yaml  | get spec.rules | get 0 | get host)
    print $"https://($host)"
}

# Get all ingresses in the namespace with additional details
export def ingress_details [namespace: string@list-namespaces] {
    let all_ingresses = (^kubectl --namespace $namespace get ingress -o json | from json | get items)
    mut report = []
    for ingress in $all_ingresses {
        let name = $ingress.metadata.name
        let rules = $ingress.spec.rules
        
        for rule in $rules {
            let host = $rule.host
            let http = $rule.http
            let paths = $http.paths

            
            mut paths_table = []

            for p in $paths {
                let path = $p.path

                let backend = $p.backend
                let service_name = $backend.service.name
                let service_port = $backend.service.port

                let port_number =   ( $service_port | get -i number )
                let port_name = ( $service_port | get -i name )

                let port_ref = if ($port_number | is-empty) {
                    $port_name
                } else {
                    $port_number
                }

                let report_line = {
                
                    ingress_name: $name
                    host: $host
                    path: $path
                    service_name: $service_name
                    service_port: $port_ref
                }

                let path_line = {
                    path: $path
                    service_name: $service_name
                    service_port: $port_ref
                }

                $paths_table = ($paths_table | append $path_line)

                $report = ($report  | append $report_line)
            }

        }
    }
    return $report
}

export def get-master-nodes [] {
    mut report = []

    let masters = (^kubectl get nodes -l node-role.kubernetes.io/master -o json | from json | get items)

    

    for m in $masters {

    mut external_ip = "MONE"    

    let os_name = $m.status.nodeInfo.osImage
    let kubelet_version = $m.status.nodeInfo.kubeletVersion
    let capacity_cpu = $m.status.capacity.cpu
    let capacity_memory = $m.status.capacity.memory


    for a in $m.status.addresses {
        if $a.type == "ExternalIP" {
            $external_ip = $a.address
        }
    }

    let row = {name: $m.metadata.name, external_ip: $external_ip, capacity_cpu: $capacity_cpu, capacity_memory: $capacity_memory, kubelet_version: $kubelet_version,  os_name: $os_name}
    $report = ($report | append $row)

    }
    return $report
}


export def get-cluster-authorization-rules [] {
    let all_rules  = (^kubectl get ClusterAuthorizationRule  -o json | from json  | get items)

    mut report = []
    for r in $all_rules {

        let limit_namespaces = ($r.spec.limitNamespaces | str join ';')
        let subjects = ($r.spec.subjects | get name |  str join ';')

        let row = {name: $r.metadata.name, limit_namespaces: $limit_namespaces, subjects: $subjects}

        $report = ($report | append $row)
    }
    return $report
}

