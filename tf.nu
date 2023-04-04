export def-env tf-init-gitlab-baclend [  gitlab_hostname: string,
                                         gitlab_project_id: int,
                                         gitlab_username: string,
                                         gitlab_token: string,
                                         state_name: string] {
    let gitlab_api_url = $"https://($gitlab_hostname)/api/v4"

    let-env TF_HTTP_ADDRESS = $"($gitlab_api_url)/projects/($gitlab_project_id)/terraform/state/($state_name)"
    let-env TF_HTTP_LOCK_ADDRESS = $"($gitlab_api_url)/projects/($gitlab_project_id)/terraform/state/($state_name)/lock"
    let-env TF_HTTP_UNLOCK_ADDRESS = $"($gitlab_api_url)/projects/($gitlab_project_id)/terraform/state/($state_name)/lock"

    let-env TF_HTTP_USERNAME = $gitlab_username
    let-env TF_HTTP_PASSWORD = $gitlab_token

    let-env TF_HTTP_LOCK_METHOD = "POST"
    let-env TF_HTTP_UNLOCK_METHOD = "DELETE"
    let-env TF_HTTP_RETRY_WAIT_MIN = "5"
    print $"Backend address: ($"($gitlab_api_url)/projects/($gitlab_project_id)/terraform/state/($state_name)")"

    terraform init
}