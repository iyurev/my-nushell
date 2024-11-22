export def set-maintenance-windows [
    cluster_name: string
    start_time: string #Time to start cluster upgrade process
    end_time: string
    week_day: string
] {

    let backup_dir = $"($env.HOME)/d8-deckhouse-mc-backups"
    mkdir $backup_dir

    let notification = {
        minimalNotificationTime: 24h
        webhook: $"http://auto-rfc-webhook-receiver.deckhouse-update-notifier.svc.($cluster_name).p.mesh/($cluster_name)"
    }

    let start_time_utc = ( $start_time | date to-timezone UTC |  format date "%H:%M")
    let end_time_utc = ( $end_time | date to-timezone UTC | format date "%H:%M")

    let update_windows = [
        {
            from: $start_time_utc,
            to: $end_time_utc,
            days: [
                $week_day
            ]
        }
    ]

    mut current_d8_mc = (^kubectl --context $cluster_name get mc deckhouse -o yaml | from yaml)

    let backup_filename = $"($backup_dir)/($cluster_name)-deckhouse-mc-backup.yaml"
    if ($backup_filename | path exists) == false {

        $current_d8_mc | save -f $backup_filename
    }


    $current_d8_mc.spec.settings.releaseChannel = "Stable"
    $current_d8_mc.spec.settings.update.mode = "Auto"
    $current_d8_mc.spec.settings.update.notification = $notification
    $current_d8_mc.spec.settings.update.windows = $update_windows

    $current_d8_mc =  ($current_d8_mc | reject status metadata.creationTimestamp metadata.generation metadata.resourceVersion metadata.uid)


    print $"Set maintanence windows for cluster - ($cluster_name)"

    $current_d8_mc | to yaml |  ^kubectl --context $cluster_name apply -f-

    return $current_d8_mc

}

export def list-releases [
    --cluster_name: string #Kubernetes cluster name
] {
    let all_releases = (^kubectl  get deckhousereleases -ojson | from json) 

    mut result = []

    for r in $all_releases.items {

        # let apply_after =  match ($r | get -i spec.applyAfter) {
        #     null => "null",

        #     _ => "default_val",
        # }

        let apply_after =  ($r | get -i spec.applyAfter)
        $apply_after | describe
        # $t | date to-timezone  "+0300"


        $result = ($result | append {name: $r.metadata.name, approved: $r.status.approved, phase: $r.status.phase, tt:  $r.status.transitionTime, apply_after: $apply_after })
        
    }
    
    return $result
}

export def edit-d8-conf [] {
    ^kubectl -n d8-system exec -ti deploy/deckhouse -c deckhouse -- deckhouse-controller edit cluster-configuration
}