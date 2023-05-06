#Shortcut for terragrunt init subcomand
export def tg-init [] {
    ^terragrunt init 
 }

#Shortcut for terragrunt plan subcomand
export def tg-plan [] {
    ^terragrunt plan
}

#Shortcut for terragrunt apply -auto-apporve
export def tg-apply-force [] {
    ^terragrunt apply -auto-approve
}