def ssl-get-server-cert [host: string] {
    openssl s_client -showcerts -connect $"($host):443" 

}

def ssl-check-cert [cert_file: string] {
    openssl x509 -in  $cert_file -text 
}


def  git-time-tag [branch: string] {
    $"(date now | date format '%Y%m%d%H%M')-($branch)"
}

def ssh_xterm [host: string] {
    TERM=xterm-256color ssh $host
}

# Documentation for l
alias l = ls
#Terraform init alias
alias tf-init = terraform init
alias tf-plan = terraform plan
alias tf-apply = terraform apply -auto-approve
alias tf-make-doc = terraform-docs markdown table --output-file MODULE_README.md --output-mode inject .
alias tf-ftm = terraform fmt .
alias tf-flush-dev-workspace = rm -f ./.terraform.lock.hcl  and rm -f ./terraform.tfstate and rm -f ./terraform.tfstate.backup and rm -rf ./.terraform