# Note Correspondence

Module names below are relative to the internal implementation namespace unless
the public namespace is shown explicitly.

| Note section | Formal location |
| --- | --- |
| 1. Raw cubical substrate | `Raw.Target`, `Raw.Transport`, `Raw.Coe`, `Raw.Pi`, `Raw.Product`, `Raw.Sigma`, `Raw.PathLine`, `Raw.HCom`, `Raw.ActiveHCom`, `Raw.Fill`, `Boundary.NonRegularity` |
| 2. Exact embedded fragment | `Core.Iota`, `Core.Pi`, `Core.Product`, `Core.Sigma`, `Core.PathP`, `Core.PathPCoe`, `Core.PathPHCom`, `Core.PathPFill`, `Core.PathPKan` |
| 3. Structural pair equalities | `Core.Product`, `Core.Sigma`, `Integration.ActualEqualityGrammar`, `Integration.ActualEqualitySoundness` |
| 4. Certified no-Glue grammar | `Syntax.Rule`, `Integration.ActualGrammar` |
| 5. Term erasure | `Integration.DisplayedCertificates`, `Integration.GlobalSoundness`, `Integration.ActualTermSoundness` |
| 6. Face and fiber safety | `Integration.NoSilentConversion`, `Integration.ActualNoSilentConversion` |
| 7. Equality-erasure registry | `Integration.EqualitySoundness`, `Integration.ActualEqualityGrammar` |
| 8. Global equality erasure | `Integration.EqualitySoundness`, `Integration.ActualEqualitySoundness` |
| 9. No silent conversion | `Integration.NoSilentConversion`, `Integration.ActualNoSilentConversion` |
| 10. Conservative reflection boundary | `Integration.ReflectionBoundary`, `Integration.ActualReflectionBoundary`, `Integration.ActualIotaReflection` |
| 11. Computation and specialization | `Integration.ComputationSummary`, `Integration.ConstantFamilySpecialization`, `Integration.ExtendedTheoremCoverage` |
| 12. Main theorem | `NoGlueCubicalCore.MainTheorem` |

The public theorem module exposes the note-facing names
`ErasableNoGlueCore`, `coreng`, `Rng`, `Gng`, `LocalEqRegistry`,
`GlobalEqErasure`, `NoSilent`, `UnifiedPresentation`,
`GngComputationSummary`, `GngSpecializationSummary`, and `Excluded`.
