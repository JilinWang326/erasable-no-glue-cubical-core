# Development Status

The public release API is centered on `NoGlueCubicalCore.MainTheorem`, which
exports the note-facing theorem names `ErasableNoGlueCore` and `coreng`.

The existing `NoGlueV2` namespace is retained as the internal implementation
namespace for this cleanup pass. This keeps the typechecked mathematical
development stable while providing the public `NoGlueCubicalCore` entry points
expected by the note.

The release check script scans all Agda sources under `src` and `tests` for
holes, postulates, unsafe termination pragmas, trust escapes, incomplete-match
flags, incomplete-meta flags, and publication cleanup markers before
typechecking the public theorem module, public index module, and smoke test.
