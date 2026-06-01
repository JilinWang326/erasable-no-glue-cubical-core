{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.DisplayedCertificates where

open import NoGlueV2.Prelude
open import NoGlueV2.Syntax.Rule

record TermSoundness (G : Grammar) : Set3 where
  field
    RouteCoh :
      {j : Grammar.Judg G} ->
      Deriv G j ->
      Set2

    PI :
      {j : Grammar.Judg G} ->
      {d e : Deriv G j} ->
      SameShape d e ->
      Set2

    localK1 :
      (r : Grammar.Rule G) ->
      (ds :
        (p : Grammar.PremIx G r) ->
        Deriv G (Grammar.prem G r p)) ->
      ((p : Grammar.PremIx G r) -> RouteCoh (ds p)) ->
      RouteCoh (node r ds)

    localK2 :
      (r : Grammar.Rule G) ->
      {ds es :
        (p : Grammar.PremIx G r) ->
        Deriv G (Grammar.prem G r p)} ->
      (sh :
        (p : Grammar.PremIx G r) ->
        SameShape (ds p) (es p)) ->
      ((p : Grammar.PremIx G r) -> PI (sh p)) ->
      PI (same-node sh)
