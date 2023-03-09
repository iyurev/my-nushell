#Define WERF_SECRET_KEY environment variable with values passed as first argument.
def-env wf-set-secret-key [key: string] {

let-env WERF_SECRET_KEY = $key

}


def wf-decrypt-secret-val [path: string] {
    werf helm secret values decrypt  $path
}







