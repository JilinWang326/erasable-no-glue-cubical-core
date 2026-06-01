{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Examples.EqualitySoundnessExample where

open import NoGlueV2.Integration.EqualitySoundness
open import NoGlueV2.Integration.ActualEqualityGrammar
open import NoGlueV2.Integration.ActualEqualitySoundness

equalitySoundnessExample :
  {e : ActualEqJudg} ->
  (d : EqDeriv actualEqualityGrammar e) ->
  ActualEqEraseTarget d
equalitySoundnessExample =
  globalEqErase actualLocalK3
