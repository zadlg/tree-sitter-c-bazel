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

load("@tree-sitter-c-bazel//:rules.bzl", map = "in_pkg_srcs")

cc_library(
    name = "parser",
    srcs = map(["parser.c"]),
    visibility = ["@tree-sitter-c-bazel//:__pkg__"],
    deps = [
        "@tree-sitter-bazel//:tree-sitter",
        "@tree-sitter-c-bazel//src/tree_sitter:parser",
    ],
)
