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

_DEFAULT_ROOT_LABEL = Label("@tree-sitter-c-raw")

def in_srcs(filepaths, root = _DEFAULT_ROOT_LABEL):
    """Maps the input paths to their corresponding paths under the tree-sitter-c
    source repository.

    Args:
      filepaths: list[str]
        Paths from the root directory of the tree-sitter-c source repository.
      root: Label
        The tree-sitter-c source repository name.

    Returns: list[Label]
      The corresponding paths lying under the tree-sitter-c source repository.
    """
    return [Label("@{root}//:{filepath}".format(root = root.name, filepath = filepath)) for filepath in filepaths]

def in_pkg_srcs(filepaths, root = _DEFAULT_ROOT_LABEL):
    """Maps the input paths to their corresponding paths under the tree-sitter-c
    source repository by preserving the package directories.

    Acts like `in_srcs`, except that the caller package is used to construct
    the paths that lie under the tree-sitter-c source repository.

    For example, a rule defined in `src/BUILD.bazel` may use `in_pkg_srcs`
    using the following inputs:
    ```starlark
    load("//:rules.bzl", "in_pkg_srcs")

    cc_library(
        name = "lib",
        srcs = in_pkg_srcs(["lib.c"]),
        hdrs = in_pkg_srcs(["lib.h"]),
    )
    ```

    The rule belongs to the Bazel package `src`, thus `in_pkg_srcs` will
    use that package to build the output path:
      `lib.c` becomes `src/lib.c`
      `lib.h` becomes `src/lib.h`.

    This rule is useful to preserve the original source code layout and split
    definitions across multiple files.

    Args:
      filepaths: list[str]
        Paths from the current package directory of the tree-sitter-c source repository.
      root: Label
        The tree-sitter-c source repository name.

    Returns: list[Label]
      The corresponding paths lying under the tree-sitter-c source repository.
    """
    package_name = native.package_name()
    return in_srcs(["{package_name}/{filepath}".format(
        package_name = package_name,
        filepath = filepath,
    ) for filepath in filepaths], root)
