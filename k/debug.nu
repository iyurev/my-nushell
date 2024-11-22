# kubectl --namespace  dom-preprod   debug --share-processes=true  -it atp-66b7bd8c5d-rz7tl  --image=docker-remote-docker-io.art.lmru.tech/goodsmileduck/redis-cli:latest  --target=atp --arguments-only -- sh


#kubectl --namespace  dom-preprod   debug --share-processes=true  -it atp-b5c6fd665-r6g8f  --image=docker-remote-docker-io.art.lmru.tech/nicolaka/netshoot:latest --target=atp


#kubectl -n default run debug-pod --image=docker-remote-docker-io.art.lmru.tech/goodsmileduck/redis-cli:latest -- sleep infinity

#kubectl --namespace  default exec debug-pod -i -t -- sh -il
use helpers.nu *

export def debug-pod [
    namespace: string@list-namespaces
    name: string@list_pods_compl
    container: string
    --image="docker-remote-docker-io.art.lmru.tech/nicolaka/netshoot:latest"
] {
     ^kubectl --namespace  $namespace   debug --share-processes=true  -it $name  --image $image  --target $container
}
