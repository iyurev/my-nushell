use ../helpers.nu *


def main [] {

  let test_ns = (get_namespace_from_ctx "k  debug pod  test-preprod atp-79788946c8-8zp8c")
  print $test_ns

  let test_kind = (get_kind_from_ctx "k  debug pod  test-preprod atp-79788946c8-8zp8c")
  print $test_kind

}




