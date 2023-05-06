#Prepare your working directory for other commands

def init_flags [] {
    [
    {value: "-backend", description: "Disable backend or Terraform Cloud initialization for this configuration and use what was previously initialized instead."}
    {value: "-backend-config", description: "Configuration to be merged with what is in the configuration file's 'backend' block."}
    ]
}

export extern "terraform init" [
    ...options: string@init_flags
#   -backend-config=path    Configuration to be merged with what is in the
#                           configuration file's 'backend' block. This can be
#                           either a path to an HCL file with key/value
#                           assignments (same format as terraform.tfvars) or a
#                           'key=value' format, and can be specified multiple
#                           times. The backend type must be in the configuration
#                           itself.

#   -force-copy             Suppress prompts about copying state data when
#                           initializating a new state backend. This is
#                           equivalent to providing a "yes" to all confirmation
#                           prompts.

#   -from-module=SOURCE     Copy the contents of the given module into the target
#                           directory before initialization.

#   -get=false              Disable downloading modules for this configuration.

#   -input=false            Disable interactive prompts. Note that some actions may
#                           require interactive prompts and will error if input is
#                           disabled.

#   -lock=false             Don't hold a state lock during backend migration.
#                           This is dangerous if others might concurrently run
#                           commands against the same workspace.

#   -lock-timeout=0s        Duration to retry a state lock.

#   -no-color               If specified, output won't contain any color.

#   -plugin-dir             Directory containing plugin binaries. This overrides all
#                           default search paths for plugins, and prevents the
#                           automatic installation of plugins. This flag can be used
#                           multiple times.

#   -reconfigure            Reconfigure a backend, ignoring any saved
#                           configuration.

#   -migrate-state          Reconfigure a backend, and attempt to migrate any
#                           existing state.

#   -upgrade                Install the latest module and provider versions
#                           allowed within configured constraints, overriding the
#                           default behavior of selecting exactly the version
#                           recorded in the dependency lockfile.

#   -lockfile=MODE          Set a dependency lockfile mode.
#                           Currently only "readonly" is valid.

#   -ignore-remote-version  A rare option used for Terraform Cloud and the remote backend
#                           only. Set this to ignore checking that the local and remote
#                           Terraform versions use compatible state representations, making
#                           an operation proceed even when there is a potential mismatch.
#                           See the documentation on configuring Terraform with
#                           Terraform Cloud for more information.
]

extern "terraform" [
    param: string, 
    ]