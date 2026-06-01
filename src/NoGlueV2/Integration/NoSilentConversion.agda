{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.NoSilentConversion where

open import NoGlueV2.Prelude
open import NoGlueV2.Syntax.Rule
open import NoGlueV2.Integration.DisplayedCertificates

record LocalFiberSafety
  (G : Grammar)
  (T : TermSoundness G)
  : Set3 where
  field
    FiberSafe :
      {j : Grammar.Judg G} ->
      Deriv G j ->
      Set2

    localSafe :
      (r : Grammar.Rule G) ->
      (ds :
        (p : Grammar.PremIx G r) ->
        Deriv G (Grammar.prem G r p)) ->
      ((p : Grammar.PremIx G r) -> FiberSafe (ds p)) ->
      FiberSafe (node r ds)

globalSafe :
  {G : Grammar} ->
  {T : TermSoundness G} ->
  (L : LocalFiberSafety G T) ->
  {j : Grammar.Judg G} ->
  (d : Deriv G j) ->
  LocalFiberSafety.FiberSafe L d
globalSafe L (node r ds) =
  LocalFiberSafety.localSafe L r ds (λ p -> globalSafe L (ds p))

record GlobalFiberSafety
  (G : Grammar)
  (T : TermSoundness G)
  : Set3 where
  field
    localFiberSafety : LocalFiberSafety G T
    fiberSafety :
      {j : Grammar.Judg G} ->
      (d : Deriv G j) ->
      LocalFiberSafety.FiberSafe localFiberSafety d

makeGlobalFiberSafety :
  {G : Grammar} ->
  {T : TermSoundness G} ->
  LocalFiberSafety G T ->
  GlobalFiberSafety G T
makeGlobalFiberSafety L = record
  { localFiberSafety = L
  ; fiberSafety = globalSafe L
  }
