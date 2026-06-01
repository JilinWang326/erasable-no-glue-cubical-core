{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Boundary.NonRegularity where

open import NoGlueV2.Prelude

data BoundaryTerm : Set where
  boundaryH : BoundaryTerm
  boundaryA : BoundaryTerm

data BoundaryCode : Set where
  codeH : BoundaryCode
  codeA : BoundaryCode

code : BoundaryTerm -> BoundaryCode
code boundaryH = codeH
code boundaryA = codeA

data CodeEq : BoundaryCode -> BoundaryCode -> Set where
  codeReflH : CodeEq codeH codeH
  codeReflA : CodeEq codeA codeA

data BoundaryEq : BoundaryTerm -> BoundaryTerm -> Set where
  brefl :
    {u : BoundaryTerm} ->
    BoundaryEq u u

  bsym :
    {u v : BoundaryTerm} ->
    BoundaryEq u v ->
    BoundaryEq v u

  btrans :
    {u v w : BoundaryTerm} ->
    BoundaryEq u v ->
    BoundaryEq v w ->
    BoundaryEq u w

codeEqSym :
  {a b : BoundaryCode} ->
  CodeEq a b ->
  CodeEq b a
codeEqSym codeReflH = codeReflH
codeEqSym codeReflA = codeReflA

codeEqTrans :
  {a b c : BoundaryCode} ->
  CodeEq a b ->
  CodeEq b c ->
  CodeEq a c
codeEqTrans codeReflH codeReflH = codeReflH
codeEqTrans codeReflA codeReflA = codeReflA

boundaryEqCodeSound :
  {u v : BoundaryTerm} ->
  BoundaryEq u v ->
  CodeEq (code u) (code v)
boundaryEqCodeSound {u = boundaryH} brefl = codeReflH
boundaryEqCodeSound {u = boundaryA} brefl = codeReflA
boundaryEqCodeSound (bsym e) =
  codeEqSym (boundaryEqCodeSound e)
boundaryEqCodeSound (btrans e f) =
  codeEqTrans (boundaryEqCodeSound e) (boundaryEqCodeSound f)

noCodeHtoA : CodeEq codeH codeA -> ⊥
noCodeHtoA ()

boundaryNonRegular :
  BoundaryEq boundaryH boundaryA ->
  ⊥
boundaryNonRegular e =
  noCodeHtoA (boundaryEqCodeSound e)
