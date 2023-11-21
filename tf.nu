export def-env tf-init-gitlab-baclend [  gitlab_hostname: string,
                                         gitlab_project_id: int,
                                         gitlab_username: string,
                                         gitlab_token: string,
                                         state_name: string] {
    let gitlab_api_url = $"https://($gitlab_hostname)/api/v4"

    $env.TF_HTTP_ADDRESS = $"($gitlab_api_url)/projects/($gitlab_project_id)/terraform/state/($state_name)"
    $env.TF_HTTP_LOCK_ADDRESS = $"($gitlab_api_url)/projects/($gitlab_project_id)/terraform/state/($state_name)/lock"
    $env.TF_HTTP_UNLOCK_ADDRESS = $"($gitlab_api_url)/projects/($gitlab_project_id)/terraform/state/($state_name)/lock"

    $env.TF_HTTP_USERNAME = $gitlab_username
    $env.TF_HTTP_PASSWORD = $gitlab_token

    $env.TF_HTTP_LOCK_METHOD = "POST"
    $env.TF_HTTP_UNLOCK_METHOD = "DELETE"
    $env.TF_HTTP_RETRY_WAIT_MIN = "5"
    print $"Backend address: ($"($gitlab_api_url)/projects/($gitlab_project_id)/terraform/state/($state_name)")"

    terraform init
}

export def tf-megalinter [
    project_dir?: string
    --image: string =  "docker.io/oxsecurity/megalinter:v6" #oxsecurity/megalinter/flavors/terraform@v6.22.2
    --flush_reports
] {
    let project_dir = if $project_dir == null {$env.PWD} else {$project_dir}
    if $flush_reports {
        sudo rm -rf $"($project_dir)/megalinter-reports"
    }
    docker run -ti --rm -v $"($project_dir):/workspace" -e "ENABLE=TERRAFORM" -e "DEFAULT_WORKSPACE=/workspace" $image 
}

export def tf-make-doc [
    project_dir?: string
    --image: string = "quay.io/terraform-docs/terraform-docs:0.16.0"
 ] {
    let project_dir = if $project_dir == null {$env.PWD} else {$project_dir}
    docker run --rm --volume $"($project_dir):/terraform-docs" -u $"(id -u)" $image markdown /terraform-docs  --output-file /terraform-docs/MODULE_README.md
}

export def tf-fmt [
    project_dir: string = "."
] {
    ^terraform fmt -recursive $project_dir
}

export def  tf-flush-dev-workspace [] {
    ^rm -f ./.terraform.lock.hcl
    ^rm -f ./terraform.tfstate
    ^rm -f ./terraform.tfstate.backup
    ^rm -rf ./.terraform
}

