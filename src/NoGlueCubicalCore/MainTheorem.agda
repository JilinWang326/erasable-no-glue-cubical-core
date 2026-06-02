{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueCubicalCore.MainTheorem where

open import NoGlueV2.Prelude public using (One; ⊥)
open import NoGlueV2.Raw.Target public using (RawTarget)
open import NoGlueV2.Syntax.Rule public using (Grammar; Deriv; SameShape)
open import NoGlueV2.Integration.DisplayedCertificates public using (TermSoundness)
open import NoGlueV2.Integration.GlobalSoundness public using (GlobalTermSoundness)
open import NoGlueV2.Integration.EqualitySoundness public
  using
    ( EqualityGrammar
    ; EqDeriv
    ; LocalK3
    ; GlobalEqualitySoundness
    )
open import NoGlueV2.Integration.NoSilentConversion public
  using (LocalFiberSafety; GlobalFiberSafety)
open import NoGlueV2.Integration.ReflectionBoundary public
  using (ReflectionBoundary)
open import NoGlueV2.Integration.ComputationSummary public
  using (ComputationSummary; SpecializationSummary)
open import NoGlueV2.Integration.ExtendedTheoremCoverage public
  using
    ( ExtendedTheoremCoverage
    ; actualExtendedTheoremCoverage
    ; Assumption3EliminationCoverage
    ; actualAssumption3EliminationCoverage
    )
open import NoGlueV2.Boundary.NonRegularity public
  using
    ( BoundaryTerm
    ; boundaryH
    ; boundaryA
    ; BoundaryEq
    ; boundaryNonRegular
    )
open import NoGlueV2.Integration.ConditionalBoundaryNonDerivability public
  using
    ( BoundaryIotaEq
    ; conditionalBoundaryNonDerivability
    ; liftedBoundaryNonDerivability
    )
open import NoGlueV2.Integration.ActualGrammar public
  using (ActualGrammar; ActualJudg; ActualRule)
open import NoGlueV2.Integration.ActualTermSoundness public
  using (actualTermSoundness; actualGlobalTermSoundness)
open import NoGlueV2.Integration.ActualEqualityGrammar public
  using (actualEqualityGrammar)
open import NoGlueV2.Integration.ActualEqualitySoundness public
  using (actualLocalK3; actualGlobalEqualitySoundness)
open import NoGlueV2.Integration.ActualNoSilentConversion public
  using (actualFiberSafety)
open import NoGlueV2.Integration.ActualReflectionBoundary public
  using (actualReflectionBoundary)
open import NoGlueV2.Integration.FinalNoGlueCore public
  renaming (FinalNoGlueCore to ErasableNoGlueCore)
open import NoGlueV2.Integration.ActualNoGlueCore public
  using (actualNoGlueCore; actualComputationSummary; actualSpecializationSummary)

coreng : ErasableNoGlueCore
coreng = actualNoGlueCore

Rng : Set1
Rng = RawTarget

RawNoGlueTarget : Set1
RawNoGlueTarget = RawTarget

Gng : Grammar
Gng = ActualGrammar

NoGlueExactGrammar : Grammar
NoGlueExactGrammar = ActualGrammar

Judg : Set1
Judg = ActualJudg

JudgGamma : Set1
JudgGamma = ActualJudg

RuleGng : Set1
RuleGng = ActualRule

LocalTermSoundness : TermSoundness Gng
LocalTermSoundness = actualTermSoundness

GngTermSoundness : GlobalTermSoundness Gng
GngTermSoundness = actualGlobalTermSoundness

GngEqualityGrammar : EqualityGrammar Gng
GngEqualityGrammar = actualEqualityGrammar

LocalEqRegistry : LocalK3 actualTermSoundness actualEqualityGrammar
LocalEqRegistry = actualLocalK3

GlobalEqErasure : GlobalEqualitySoundness actualTermSoundness actualEqualityGrammar
GlobalEqErasure = actualGlobalEqualitySoundness

NoSilent : GlobalFiberSafety Gng actualTermSoundness
NoSilent = actualFiberSafety

GngReflectionBoundary : ReflectionBoundary actualGlobalEqualitySoundness
GngReflectionBoundary = actualReflectionBoundary

GngComputationSummary : ComputationSummary
GngComputationSummary = actualComputationSummary

GngSpecializationSummary : SpecializationSummary
GngSpecializationSummary = actualSpecializationSummary

UnifiedPresentation : ExtendedTheoremCoverage
UnifiedPresentation = actualExtendedTheoremCoverage

Assumption3Eliminated :
  BoundaryEq boundaryH boundaryA ->
  ⊥
Assumption3Eliminated = boundaryNonRegular

LiftedBoundaryNonDerivability :
  BoundaryIotaEq ->
  ⊥
LiftedBoundaryNonDerivability = conditionalBoundaryNonDerivability

Excluded : Set
Excluded = One
