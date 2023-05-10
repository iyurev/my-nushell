alias ll = ls -la
alias l = ls
alias edit-nu-conf = code $nu.config-path
alias edit-nu-env = code $nu.env-path
alias edit-my-nushell = code $"($nu.home-path)/.nu"
alias kc = kubectl
alias dtc = detect columns
alias nv = nvim



#Terraform init alias
alias tf-init = terraform init
alias tf-plan = terraform plan
alias tf-apply = terraform apply -auto-approve
alias tf-make-doc = terraform-docs markdown table --output-file MODULE_README.md --output-mode inject .
alias tf-fmt = terraform fmt .
alias tf-flush-dev-workspace = rm -f ./.terraform.lock.hcl  and rm -f ./terraform.tfstate and rm -f ./terraform.tfstate.backup and rm -rf ./.terraform

#Git
#alias git-init-myself =  git config --global user.name "Igor Yurev"; git config --global user.email idyurev@gmail.com
