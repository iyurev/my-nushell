export def decrypt-in-place [
    file_path: string, 
    ] {
    ^sops -d -i $file_path
}

export def encrypt-in-place [
    file_path: string, 
    ] {
    ^sops -e -i $file_path
}