export def dvd-to-mp4 [dvd_dir_path: string] {
    mut vob_files: list<string> = []
    for file_item in (ls -la $dvd_dir_path) {

        let file_name =   ($file_item | get name)
        let base_name = ($file_name | path basename )

        if $base_name == 'VIDEO_TS.VOB' {
            continue
        }
        
        let ext_name = ($file_name | path basename |  split column '.' | get column2 | get 0)
        if $ext_name == 'VOB' {
            $vob_files = ($vob_files | append  $file_name)
        }

    }
    print $vob_files

    #ffmpeg -i movie.VOB   -an -c:v h264_videotoolbox -q:v 50  -vf format=yuv420p  out2.mp4
    #-i  "concat:/Users/iyurev/Movies/media_library/movies/Bullet-1995_DeeeJ/VTS_01_1.VOB|/Users/iyurev/Movies/media_library/movies/Bullet-1995_DeeeJ/VTS_01_2.VOB|/Users/iyurev/Movies/media_library/movies/Bullet-1995_DeeeJ/VTS_01_3.VOB|/Users/iyurev/Movies/media_library/movies/Bullet-1995_DeeeJ/VTS_01_4.VOB"   -c:v h264_videotoolbox    /Users/iyurev/Movies/bullet_1995_p1.mp4
}