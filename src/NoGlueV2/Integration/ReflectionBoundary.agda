{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.ReflectionBoundary where

open import NoGlueV2.Prelude
open import NoGlueV2.Syntax.Rule
open import NoGlueV2.Integration.DisplayedCertificates
open import NoGlueV2.Integration.EqualitySoundness

record ReflectionBoundary
  {G : Grammar}
  {T : TermSoundness G}
  {EG : EqualityGrammar G}
  (GES : GlobalEqualitySoundness T EG)
  : Set3 where
  field
    Signature : Set1
    admitsReflectedRule : Signature -> Set
    reflectedRulesAreSignatureRelative :
      (sig : Signature) -> admitsReflectedRule sig
    reflectedTarget :
      {e : EqualityGrammar.EqJudg EG} ->
      (d : EqDeriv EG e) ->
      LocalK3.EqEraseTarget
        (GlobalEqualitySoundness.localK3Soundness GES)
        d
