{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.EqualitySoundness where

open import NoGlueV2.Prelude
open import NoGlueV2.Syntax.Rule
open import NoGlueV2.Integration.DisplayedCertificates
open import NoGlueV2.Integration.GlobalSoundness

record EqualityGrammar (G : Grammar) : Set2 where
  field
    EqJudg : Set1
    EqRule : Set1
    EqPremIx : EqRule -> Set1
    eqPrem : (r : EqRule) -> EqPremIx r -> EqJudg
    TermPremIx : EqRule -> Set1
    termPrem : (r : EqRule) -> TermPremIx r -> Grammar.Judg G
    eqConc : EqRule -> EqJudg

data EqDeriv
  {G : Grammar}
  (EG : EqualityGrammar G)
  : EqualityGrammar.EqJudg EG ->
  Set2 where
  eqnode :
    (r : EqualityGrammar.EqRule EG) ->
    ((p : EqualityGrammar.EqPremIx EG r) ->
      EqDeriv EG (EqualityGrammar.eqPrem EG r p)) ->
    ((p : EqualityGrammar.TermPremIx EG r) ->
      Deriv G (EqualityGrammar.termPrem EG r p)) ->
    EqDeriv EG (EqualityGrammar.eqConc EG r)

record EqPremErase
  {G : Grammar}
  {EG : EqualityGrammar G}
  (EqEraseTarget :
    {e : EqualityGrammar.EqJudg EG} ->
    EqDeriv EG e ->
    Set)
  (r : EqualityGrammar.EqRule EG)
  (eqs :
    (p : EqualityGrammar.EqPremIx EG r) ->
    EqDeriv EG (EqualityGrammar.eqPrem EG r p))
  : Set2 where
  constructor mkEqPremErase
  field
    eqPremErase :
      (p : EqualityGrammar.EqPremIx EG r) ->
      EqEraseTarget (eqs p)

record TermSupport
  {G : Grammar}
  (T : TermSoundness G)
  {EG : EqualityGrammar G}
  (r : EqualityGrammar.EqRule EG)
  (terms :
    (p : EqualityGrammar.TermPremIx EG r) ->
    Deriv G (EqualityGrammar.termPrem EG r p))
  : Set2 where
  constructor mkTermSupport
  field
    termRoute :
      (p : EqualityGrammar.TermPremIx EG r) ->
      TermSoundness.RouteCoh T (terms p)

record LocalK3
  {G : Grammar}
  (T : TermSoundness G)
  (EG : EqualityGrammar G)
  : Set3 where
  field
    EqEraseTarget :
      {e : EqualityGrammar.EqJudg EG} ->
      EqDeriv EG e ->
      Set

    SideCond : EqualityGrammar.EqRule EG -> Set

    sideCond :
      (r : EqualityGrammar.EqRule EG) ->
      SideCond r

    localK3 :
      (r : EqualityGrammar.EqRule EG) ->
      (eqs :
        (p : EqualityGrammar.EqPremIx EG r) ->
        EqDeriv EG (EqualityGrammar.eqPrem EG r p)) ->
      (terms :
        (p : EqualityGrammar.TermPremIx EG r) ->
        Deriv G (EqualityGrammar.termPrem EG r p)) ->
      EqPremErase {EG = EG} EqEraseTarget r eqs ->
      TermSupport T {EG = EG} r terms ->
      SideCond r ->
      EqEraseTarget (eqnode r eqs terms)

globalEqErase :
  {G : Grammar} ->
  {T : TermSoundness G} ->
  {EG : EqualityGrammar G} ->
  (K : LocalK3 T EG) ->
  {e : EqualityGrammar.EqJudg EG} ->
  (d : EqDeriv EG e) ->
  LocalK3.EqEraseTarget K d
globalEqErase {T = T} {EG = EG} K (eqnode r eqs terms) =
  LocalK3.localK3 K r eqs terms
    (mkEqPremErase {EG = EG} (λ p -> globalEqErase K (eqs p)))
    (mkTermSupport {EG = EG} (λ p -> globalRoute T (terms p)))
    (LocalK3.sideCond K r)

record GlobalEqualitySoundness
  {G : Grammar}
  (T : TermSoundness G)
  (EG : EqualityGrammar G)
  : Set3 where
  field
    localK3Soundness : LocalK3 T EG
    equalityErasure :
      {e : EqualityGrammar.EqJudg EG} ->
      (d : EqDeriv EG e) ->
      LocalK3.EqEraseTarget localK3Soundness d

makeGlobalEqualitySoundness :
  {G : Grammar} ->
  {T : TermSoundness G} ->
  {EG : EqualityGrammar G} ->
  LocalK3 T EG ->
  GlobalEqualitySoundness T EG
makeGlobalEqualitySoundness K = record
  { localK3Soundness = K
  ; equalityErasure = globalEqErase K
  }
