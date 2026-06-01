{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Syntax.Rule where

open import NoGlueV2.Prelude

record Grammar : Set2 where
  field
    Judg : Set1
    Rule : Set1
    PremIx : Rule -> Set1
    prem : (r : Rule) -> PremIx r -> Judg
    conc : Rule -> Judg

data Deriv (G : Grammar) : Grammar.Judg G -> Set2 where
  node :
    (r : Grammar.Rule G) ->
    ((p : Grammar.PremIx G r) ->
      Deriv G (Grammar.prem G r p)) ->
    Deriv G (Grammar.conc G r)

data SameShape
  {G : Grammar}
  : {j : Grammar.Judg G} ->
  Deriv G j ->
  Deriv G j ->
  Set2 where
  same-node :
    {r : Grammar.Rule G}
    {ds es :
      (p : Grammar.PremIx G r) ->
      Deriv G (Grammar.prem G r p)} ->
    ((p : Grammar.PremIx G r) -> SameShape (ds p) (es p)) ->
    SameShape (node r ds) (node r es)
