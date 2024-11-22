export use deployment.nu *
export use debug.nu *



# export def list-workload [
#     svc_name: string # service name
# ] {
#     let selector = (^kubectl get svc $svc_name -o json | from json | get spec.selector )

# }



# def loggable_kinds [] {
#     [
#     "deployment"
#     ]
# }

# def resource_kind_dynamic [] {
#     ^kubectl api-resources | detect columns | get NAME
# }



# export def use-context [
#     name: string@list-contexts
# ] {
#     ^kubectl config use-context $name
# }

# def kc-get-in-all-namespaces [kind: string] {
#     ^kubectl get $kind -A -o json  | from json | get items
# }

# export def --env set-namespace [namespace: string@list-namespaces] {
#     print $"Work with namespace: ($namespace)"
#     $env.KUBE_NAMESPACE = $namespace
#     ^kubectl config  set-context --current $"--namespace=($namespace)"

# }

# export def --env set-kubeconfig [path: string@list-kubeconfigs] {
#     print $"Use kubeconfig: ($path)"
#     $env.KUBECONFIG = $path    
# }

# export def search-ns [name: string] {
#     ^kubectl get ns -o json | from json | get -i items |  where  metadata.name =~ $name | get metadata.name
# }

# export def get-by-label [namespace: string@list-namespaces kind: string@resource_kind_dynamic label: string] {
#     ^kubectl -n $namespace get -l $label  $kind -oname
# }


# export def get-all-failed-pods [] {
#         kc-get-in-all-namespaces  pods | where status.phase == "Failed" | select  metadata.namespace metadata.name status.phase
# }

# export def get-all-pending-pods [] {
#         kc-get-in-all-namespaces  pods | where status.phase == "Pending" | select  metadata.namespace metadata.name status.phase
# }


# export def logs-tail [
#     namespace: string@list-namespaces
#     name: string
#     --kind: string@loggable_kinds = "deployment"

# ] {
#     ^kubectl  --namespace $namespace logs -f --tail=1000 $"($kind)/($name)"
# }


# export def d8-grafana-url [] {
#     let host = (^kubectl --namespace  d8-monitoring get ingress grafana-dex-authenticator -o yaml  | from yaml  | get spec.rules | get 0 | get host)
#     print $"https://($host)"
# }

# export def d8-kibana-url [] {
#     let host = (^kubectl --namespace  infra-elklogs  get ingress kibana -o yaml  | from yaml  | get spec.rules | get 0 | get host)
#     print $"https://($host)"
# }


# #kubectl get node -o json | from json  | get items | where metadata.labels.'node.deckhouse.io/group' =~ "frontend" | select  metadata.name status.addresses.address.0 metadata.name status.addresses.address.1

# #kubectl get node -o json | from json  | get items  | select  metadata.name status.addresses.address.0 metadata.name status.addresses.address.1  | where  status_addresses_address_1 =~ '10.203.45' | length