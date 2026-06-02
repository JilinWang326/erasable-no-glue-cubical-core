# Development Status

The public release API is centered on `NoGlueCubicalCore.MainTheorem`, which
exports the note-facing theorem names `ErasableNoGlueCore` and `coreng`.

The existing `NoGlueV2` namespace is retained as the internal implementation
namespace for this cleanup pass. This keeps the typechecked mathematical
development stable while providing the public `NoGlueCubicalCore` entry points
expected by the note.

The repository is intended to be checked through the direct Agda entry points
listed in the README: the public theorem module, the public index module, and
the smoke-load module.
