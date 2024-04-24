# Bazel repository for [`tree-sitter-c`].

This Bazel repository allows users to compile and use the [`tree-sitter-c`] [C Parser]
from their Bazel projects.


  - [Importing to some existing project](#importing)
  - [Targets](#targets)
  - [Build configuration](#build-config)

## Importing to some existing project<a name="importing"></a>

> [!IMPORTANT]
> `--experimental_cc_implementation_deps` MUST be enabled, see [`implementation_deps`].

See [INSTALL.md](INSTALL.md).

## Targets<a name="targets"></a>

The following targets are exposed by this repository:

  - `@tree-sitter-c-bazel//:tree-sitter-c`: the tree-sitter C parser.

[`tree-sitter-c`]: https://github.com/tree-sitter/tree-sitter-c
[C API]: https://github.com/tree-sitter/tree-sitter-c/blob/master/src/parser.c
[`WORKSPACE`]: https://bazel.build/concepts/build-ref
[`bazel_dep`]: https://bazel.build/rules/lib/globals/module#bazel_dep
[`archive_override`]: https://bazel.build/rules/lib/globals/module#archive_override
[`implementation_deps`]: https://bazel.build/reference/be/c-cpp#cc_library.implementation_deps
