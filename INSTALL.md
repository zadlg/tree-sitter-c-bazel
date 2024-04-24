# Importing to some existing project<a name="importing"></a>

> [!IMPORTANT]
> `--experimental_cc_implementation_deps` MUST be enabled, see [`implementation_deps`].

## Using Bazel 6 **without** Bzlmod<a name="bazel-6-no-bzlmod"></a>

Add the following to your `WORKSPACE` file:

```starlark
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

_VERSION_TAG = "x.y.z"
maybe(
  http_archive,
  name = "tree-sitter-c-bazel",
  urls = ["https://github.com/zadlg/tree-sitter-c-bazel/archive/refs/tags/v{version}.tar.gz".format(
      version = _VERSION_TAG,
  )],
  sha256 = "", # Set the SHA-256 sum of the archive.
  strip_prefix = "tree-sitter-bazel-{version}".format(
      version = _VERSION_TAG,
  ),
)

# Fetches tree-sitter dependencies (bazel_skylib)
load("@tree-sitter-c-bazel//:repositories.bzl", "tree_sitter_c_repositories")

tree_sitter_c_repositories()

# Fetches the source code of tree-sitter.
load("@tree-sitter-c-bazel//:repositories.bzl", "tree_sitter_c_sources")

tree_sitter_c_sources()

# Fetches tree-sitter dependencies.
load("@tree-sitter-bazel//:repositories.bzl", "tree_sitter_repositories", "tree_sitter_sources")

tree_sitter_repositories()

tree_sitter_sources()

# Loads tree-sitter dependencies (bazel_skylib)
load("@tree-sitter-c-bazel//:deps.bzl", "tree_sitter_c_dependencies")

tree_sitter_c_dependencies()

load("@tree-sitter-bazel//:deps.bzl", "tree_sitter_dependencies")

tree_sitter_dependencies()

```

## Using with Bazel >=6 **with** Bzlmod<a name="bazel-with-bzlmod"></a>

Ensure that `common --enable_bzlmod` is set in your `.bazelrc` file.

(See [`bazel_dep`] and [`archive_override`]).

Add the following to your `MODULE.bazel` file:

```starlark
_VERSION_TAG = "x.y.z"
bazel_dep(name = "tree-sitter-c-bazel", version = _VERSION_TAG)
archive_override("tree-sitter-c-bazel",
    urls = ["https://github.com/zadlg/tree-sitter-bazel/archive/refs/tags/v{version}.tar.gz".format(
        version = _VERSION_TAG,
    )],
    integrity = "", #  The expected checksum of the archive file, in Subresource Integrity format.
    strip_prefix = "tree-sitter-c-bazel-{version}".format(
        version = _VERSION_TAG,
    ),
)
```
