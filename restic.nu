export def make-backup [
    gcs_bucket_name?: string = "backups-cd15d6c15b0f00a08"
] {
    open $"($nu.home-path)/.secrets/restic-backup.json" | load-env
    restic backup  -r $"gs:($gcs_bucket_name):/" --verbose --files-from ~/.config/restic/to-backup.list --exclude-file ~/.config/restic/exclude-from-backup.list
}