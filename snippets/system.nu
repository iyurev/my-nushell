export def find-process-by-name [name] {
    ps | where name  =~ $name 
}
 