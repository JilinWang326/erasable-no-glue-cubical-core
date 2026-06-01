# Erasable no-Glue Cubical Core

This repository contains an Agda formalization of the erasable no-Glue
cubical core spine described in the note "Detailed Formal Note for the
Erasable no-Glue Cubical Core". It is a deep embedding: the formalization
organizes raw cubical structure, an exact embedded fragment, structural pair
equalities, certified grammar rules, term erasure, face and fiber safety,
local and global equality erasure, the no-silent-conversion boundary,
reflection limits, computation summaries, specialization, and the packaged
main theorem.

The public theorem entry point is:

```agda
src/NoGlueCubicalCore/MainTheorem.agda

coreng : ErasableNoGlueCore
```

## Build

Requirements:

- Agda 2.9 with support for `--cubical=no-glue`
- either the local no-glue wrapper at
  `C:\Users\24539\Agda\toolchains\agda-no-glue\agda-no-glue.cmd`, or a
  compatible Agda executable supplied through `$env:AGDA`

Check the release surface and smoke test with:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check.ps1
```

## Layout

- `src/NoGlueCubicalCore/MainTheorem.agda` exposes `ErasableNoGlueCore` and
  `coreng`.
- `src/NoGlueCubicalCore/Index.agda` re-exports the public theorem surface and
  stable supporting modules.
- `src/` contains the internal Agda development for the raw target, core
  operations, grammar, erasure, safety, reflection boundary, computation, and
  specialization components.
- `tests/Smoke/LoadEverything.agda` checks that the public modules and internal
  implementation load together.
- `docs/note-correspondence.md` maps the note sections to formal modules.
- `docs/nonclaims.md` records the formal nonclaims.

## Scope And Nonclaims

The development formalizes the erasable no-Glue core spine as a deep embedding.
It does not include object-language Glue, universes, identity types,
univalence, eta rules, conversion, equality reflection, normalization, or
canonicity. Agda definitional equality is used only by the host checker while
typechecking the embedding; it is not added as an object-language conversion
rule.
