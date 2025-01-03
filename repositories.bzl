# Copyright 2024 github.com/zadlg
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

# Default tree-sitter-c version to use.
DEFAULT_VERSION = "0.23.4"

# SHA-256 sum of the default tree-sitter-c version GitHub archive.
DEFAULT_SHA256SUM = "b66c5043e26d84e5f17a059af71b157bcf202221069ed220aa1696d7d1d28a7a"

# Integrity in Subresource Integrity format.
# This can be obtained by doing:
# ```shell
# export DGST=384
# curl -L "${URL}" -s | shasum -a "${DGST}" | cut -f1 -d' ' | xxd -r -p | base64 | (echo -ne "sha${DGST}-" && "cat" -)
# ```
DEFAULT_INTEGRITY = "sha384-Y3gIwJmWW0qO4HsumCVtqGZ9sSuBrhKqs11gum3kT6mlpTFRUFJ6a2dzol7MTXq3"

# Format for URLs to GitHub archives.
_URL_FMT = "https://github.com/tree-sitter/tree-sitter-c/archive/refs/tags/v{version}.tar.gz"

# Format for stripping the archive prefix.
_STRIP_PREFIX_FMT = "tree-sitter-c-{version}"

def tree_sitter_c_repositories():
    # Release date: Nov 6 2023
    _VERSION = "1.5.0"
    _SHA256 = "cd55a062e763b9349921f0f5db8c3933288dc8ba4f76dd9416aac68acee3cb94"
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = _SHA256,
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/{version}/bazel-skylib-{version}.tar.gz".format(version = _VERSION),
            "https://github.com/bazelbuild/bazel-skylib/releases/download/{version}/bazel-skylib-{version}.tar.gz".format(version = _VERSION),
        ],
    )

    # Release date: Apr 23 2024
    _VERSION = "0.22.5"
    _SHA256 = "cf1cfdab42a97fb80810059a297ad57b12fbdaf29fefcf0aa2aca89795d429e2"
    maybe(
        http_archive,
        name = "tree-sitter-bazel",
        urls = ["https://github.com/zadlg/tree-sitter-bazel/archive/refs/tags/v{version}.tar.gz".format(
            version = _VERSION,
        )],
        sha256 = "cf1cfdab42a97fb80810059a297ad57b12fbdaf29fefcf0aa2aca89795d429e2",
        strip_prefix = "tree-sitter-bazel-{version}".format(
            version = _VERSION,
        ),
    )

def tree_sitter_c_build_http_archive_arguments(
        version = DEFAULT_VERSION,
        sha256 = DEFAULT_SHA256SUM,
        integrity = DEFAULT_INTEGRITY,
        url = None,
        strip_prefix = None):
    """Builds the argument for `http_archive`.

    Args:
      version: str
        Version to use.
      sha256: str
        SHA-256 sum.
      url: str
        URL.
      strip_prefix: str
        Strip prefix.

    Returns: dict
      Arguments for `http_archive`. `name` is missing.
    """
    if url == None:
        url = _URL_FMT.format(version = version)
    elif url != None and version != None:
        fail("`url` and `version` are mutually exclusive.")

    if strip_prefix == None:
        if version != None:
            strip_prefix = _STRIP_PREFIX_FMT.format(version = version)
        else:
            print("WARNING: no `strip_prefix` will be used.")

    if sha256 == None and integrity == None:
        print("WARNING: `sha256` and`integrity` SHOULD NOT be None.")

    if integrity != None:
        sha256 = None

    return {
        "urls": [url],
        "sha256": sha256,
        "integrity": integrity,
        "strip_prefix": strip_prefix,
        "build_file_content": """exports_files(glob(["src/**"]))""",
    }

def tree_sitter_c_sources(
        version = DEFAULT_VERSION,
        sha256 = DEFAULT_SHA256SUM,
        integrity = DEFAULT_INTEGRITY,
        url = None,
        strip_prefix = None):
    """Fetches the archive containing the tree-sitter-c source code.

    Args:
      version: str
        Version to use.
      sha256: str
        SHA-256 sum.
      url: str
        URL.
      strip_prefix: str
        Strip prefix.
    """
    args = tree_sitter_c_build_http_archive_arguments(
        version = version,
        sha256 = sha256,
        integrity = integrity,
        url = url,
        strip_prefix = strip_prefix,
    )

    maybe(
        http_archive,
        name = "tree-sitter-c-raw",
        **args
    )
