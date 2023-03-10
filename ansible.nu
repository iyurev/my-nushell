def ansible_container_images [] {
    [
        "ghcr.io/ansible/creator-ee:v0.13.0",
        "harbor.vseinstrumenti.ru/vi/docker-ansible/docker-ansible:1.1.0"
    ]
}

export def shell [--image: string@ansible_container_images] {
    let wd = $"($env.PWD):/workspace"
    docker run -ti --rm -v $wd  -w /workspace $image sh
    
}