def gcp_zones [] {
    [
        "us-central1-a",
        "me-west1-a",
        "europe-north1-a",
        "europe-west3-a"
        "europe-west4-a"
    ]
}

def gcp_machine_types [] {
    [
        "e2-micro",
        "e2-small",
        "e2-medium",
        "n2-standard-2",
        "n2d-custom-4-8192",
        "c3-standard-4",
        "c3-highcpu-4",
        "c3-highcpu-8"
        
    ]
}

def gcp_disk_types [] {
[    
"pd-ssd",
"pd-balanced",
"pd-standard"
]
}

def gcp_disk_sizes [] {
    [
        10,
        20,
        30,
    ]
}

def gcp_list_projects [] {
    gcloud projects list --format="json" | from json | get projectId
}

def provisioning_models [] {
    [
        "STANDARD",
        "SPOT"
    ]
}
#Create compute instance.
export def create-vm [
    name: string
    --project: string@gcp_list_projects
    --zone: string@gcp_zones
    --machine_type: string@gcp_machine_types
    --provisioning_model: string@provisioning_models = "STANDARD"
    --disk_type: string@gcp_disk_types 
    --disk_size: string@gcp_disk_sizes] {
    let project_name = $project
    let image = "devops-pack-010"
    let ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmSKFjQCh1hohQQJOWvxILjBceq1E+ZmrTAE90uQ6ST developer@gmail.com"
    let username = "developer"
    let maintenance_policy = if $provisioning_model == "STANDARD" { "MIGRATE" } else { "TERMINATE" }
    gcloud compute instances create $name $"--project=($project_name)" $"--zone=($zone)" $"--machine-type=($machine_type)" --network-interface=network-tier=PREMIUM,nic-type=GVNIC,stack-type=IPV4_ONLY,subnet=default  $"--maintenance-policy=($maintenance_policy)" $"--provisioning-model=($provisioning_model)" --service-account=700122225442-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append $"--create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/gothic-concept-349709/global/images/($image),mode=rw,size=($disk_size),type=projects/gothic-concept-349709/zones/us-central1-a/diskTypes/($disk_type)" --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
}

def instance_args [] {
    ["compute", "instances"]
}

def list-vm-by-name [] {
    gcloud compute instances list --format=json | from json | get name
}

#List all compute instance in a project.
export def list-vm [--project: string@gcp_list_projects] { 
    let default_args = (instance_args | append "list")
    let args = if $project == null { $default_args } else { ($default_args | append $"--project=($project)")  } 
    gcloud $args  
}
#Start compute instance.
export def start-vm [--project: string@gcp_list_projects
                     name: string@list-vm-by-name
                     ] { 
    let args = (instance_args | append "start" | append $name | append $"--project=(default_project_name $project)")
    gcloud $args
}
#Stop compute instance.
export def stop-vm [--project: string@gcp_list_projects name: string@list-vm-by-name] { 
    let args = (instance_args | append "stop" | append $name | append $"--project=(default_project_name $project)" )
    gcloud $args
}
#Delete compute instance.
export def delete-vm [--project: string@gcp_list_projects name: string] { 
    let args = (instance_args | append "delete" | append $name | append $"--project=(default_project_name $project)")
    gcloud $args
}
#List GCP project.
export def list-projects [] {
    gcloud projects list
}
#Set project
export def set-project [project: string@gcp_list_projects] {
    gcloud config set project $project
}
#Set compute zone
export def set-zone [zone: string@gcp_zones] {
    gcloud config set compute/zone $zone
}

def default_project_name [project_name: string] {
    let name = if $project_name == null { (gcloud config get project | str trim) } else { $project_name } 
    $name

}