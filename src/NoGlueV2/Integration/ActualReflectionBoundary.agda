{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.ActualReflectionBoundary where

open import NoGlueV2.Integration.ReflectionBoundary
open import NoGlueV2.Integration.EqualitySoundness
open import NoGlueV2.Integration.ActualEqualityGrammar
open import NoGlueV2.Integration.ActualEqualitySoundness

actualReflectionBoundary :
  ReflectionBoundary actualGlobalEqualitySoundness
actualReflectionBoundary = record
  { Signature = ActualEqRule
  ; admitsReflectedRule = RuleEraseTarget
  ; reflectedRulesAreSignatureRelative = actualEqEvidence
  ; reflectedTarget =
      GlobalEqualitySoundness.equalityErasure actualGlobalEqualitySoundness
  }
