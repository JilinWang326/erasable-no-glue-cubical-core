{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.FinalNoGlueCore where

open import NoGlueV2.Prelude
open import NoGlueV2.Syntax.Rule
open import NoGlueV2.Integration.DisplayedCertificates
open import NoGlueV2.Integration.GlobalSoundness
open import NoGlueV2.Integration.EqualitySoundness
open import NoGlueV2.Integration.NoSilentConversion
open import NoGlueV2.Integration.ReflectionBoundary
open import NoGlueV2.Integration.ComputationSummary
open import NoGlueV2.Integration.ExtendedTheoremCoverage

record FinalNoGlueCore : Set4 where
  field
    termGrammar : Grammar
    termLocalSoundness : TermSoundness termGrammar
    termSoundness : GlobalTermSoundness termGrammar
    equalityGrammar : EqualityGrammar termGrammar
    equalityLocalSoundness :
      LocalK3 termLocalSoundness equalityGrammar
    equalitySoundness :
      GlobalEqualitySoundness termLocalSoundness equalityGrammar
    fiberSafety :
      GlobalFiberSafety termGrammar termLocalSoundness
    reflection :
      ReflectionBoundary equalitySoundness
    computationSummary : ComputationSummary
    specializationSummary : SpecializationSummary
    extendedTheoremCoverage : ExtendedTheoremCoverage
    nonClaims : Set
