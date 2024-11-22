#istioctl proxy-config  endpoints  -n keycloak-partner-prod-2 infinispan-0 | grep infinispan | grep jgroups
#istioctl -i d8-istio  experimental  describe pod -n keycloak-partner-prod-2 infinispan-0