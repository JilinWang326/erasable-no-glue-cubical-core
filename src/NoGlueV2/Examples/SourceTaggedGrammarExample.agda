{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Examples.SourceTaggedGrammarExample where

open import NoGlueV2.Syntax.Rule
open import NoGlueV2.Integration.GlobalSoundness
open import NoGlueV2.Integration.ActualGrammar
open import NoGlueV2.Integration.ActualTermSoundness

sourceTaggedRouteExample :
  {j : ActualJudg} ->
  (d : Deriv ActualGrammar j) ->
  ActualRouteCoh d
sourceTaggedRouteExample =
  globalRoute actualTermSoundness

