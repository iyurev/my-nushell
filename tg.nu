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

export def tg-run-all-apply [] {
    ^terragrunt  run-all apply  --terragrunt-non-interactive --terragrunt-include-external-dependencies
}

export def tg-run-all-plan [] {
    ^terragrunt  run-all plan  --terragrunt-non-interactive --terragrunt-include-external-dependencies
}

export def tg-fmt [
    project_dir: string = "."
] {
    terragrunt hclfmt $project_dir
}
