workspace(name = "com_google_jsinterop_generator")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_BAZEL_COMMON_VERSION = "227a23a508a2fab0fa67ffe2d9332ae536a40edc"

http_archive(
    name = "google_bazel_common",
    strip_prefix = "bazel-common-%s" % _BAZEL_COMMON_VERSION,
    urls = ["https://github.com/google/bazel-common/archive/%s.zip" % _BAZEL_COMMON_VERSION],
)

# Load J2CL separately
_J2CL_VERSION = "master"

http_archive(
    name = "com_google_j2cl",
    strip_prefix = "j2cl-%s" % _J2CL_VERSION,
    url = "https://github.com/google/j2cl/archive/%s.zip" % _J2CL_VERSION,
)

load("@com_google_j2cl//build_defs:repository.bzl", "load_j2cl_repo_deps")

load_j2cl_repo_deps()

load("@com_google_j2cl//build_defs:rules.bzl", "setup_j2cl_workspace")

setup_j2cl_workspace()

# Load the other dependencies
load("//build_defs:repository.bzl", "load_jsinterop_generator_repo_deps")

load_jsinterop_generator_repo_deps()

load("//build_defs:rules.bzl", "setup_jsinterop_generator_workspace")

setup_jsinterop_generator_workspace()
