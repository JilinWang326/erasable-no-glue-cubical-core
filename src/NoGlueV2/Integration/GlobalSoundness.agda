{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.GlobalSoundness where

open import NoGlueV2.Prelude
open import NoGlueV2.Syntax.Rule
open import NoGlueV2.Integration.DisplayedCertificates

globalRoute :
  {G : Grammar} ->
  (T : TermSoundness G) ->
  {j : Grammar.Judg G} ->
  (d : Deriv G j) ->
  TermSoundness.RouteCoh T d
globalRoute T (node r ds) =
  TermSoundness.localK1 T r ds (λ p -> globalRoute T (ds p))

globalPI :
  {G : Grammar} ->
  (T : TermSoundness G) ->
  {j : Grammar.Judg G} ->
  {d e : Deriv G j} ->
  (sh : SameShape d e) ->
  TermSoundness.PI T sh
globalPI T (same-node {r = r} sh) =
  TermSoundness.localK2 T r sh (λ p -> globalPI T (sh p))

record GlobalTermSoundness (G : Grammar) : Set3 where
  field
    localSoundness : TermSoundness G
    routeSoundness :
      {j : Grammar.Judg G} ->
      (d : Deriv G j) ->
      TermSoundness.RouteCoh localSoundness d
    shapeSoundness :
      {j : Grammar.Judg G} ->
      {d e : Deriv G j} ->
      (sh : SameShape d e) ->
      TermSoundness.PI localSoundness sh

makeGlobalTermSoundness :
  {G : Grammar} ->
  TermSoundness G ->
  GlobalTermSoundness G
makeGlobalTermSoundness T = record
  { localSoundness = T
  ; routeSoundness = globalRoute T
  ; shapeSoundness = globalPI T
  }
