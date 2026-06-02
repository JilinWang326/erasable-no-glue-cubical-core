{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Raw.Coe where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Raw.Target

record RawDependentCoe (R : RawTarget) : Set1 where
  open RawTarget R
  field
    Fam : Set
    El  : Fam -> Dim -> RawTy

    coe :
      (B : Fam) ->
      (t t' : Dim) ->
      RawTm (El B t) ->
      RawTm (El B t')

    coe-id :
      (B : Fam) ->
      (t : Dim) ->
      (u : RawTm (El B t)) ->
      RawEq (coe B t t u) u

    coe-cong :
      (B : Fam) ->
      (t t' : Dim) ->
      {u v : RawTm (El B t)} ->
      RawEq u v ->
      RawEq (coe B t t' u) (coe B t t' v)

record Raw2DFamilyCode
  (R : RawTarget)
  (C : RawDependentCoe R)
  : Set1 where
  open RawDependentCoe C
  field
    A2Code : Dim -> Fam

record Raw2DCoe (R : RawTarget) : Set1 where
  open RawTarget R
  field
    A2 : Dim -> Dim -> RawTy

    coe2 :
      (s : Dim) ->
      (t t' : Dim) ->
      RawTm (A2 t s) ->
      RawTm (A2 t' s)

    coe2-id :
      (s t : Dim) ->
      (u : RawTm (A2 t s)) ->
      RawEq (coe2 s t t u) u

    coe2-cong :
      (s t t' : Dim) ->
      {u v : RawTm (A2 t s)} ->
      RawEq u v ->
      RawEq (coe2 s t t' u) (coe2 s t t' v)

derivedRaw2DCoe :
  {R : RawTarget} ->
  (C : RawDependentCoe R) ->
  Raw2DFamilyCode R C ->
  Raw2DCoe R
derivedRaw2DCoe {R} C code = record
  { A2 = λ x s -> RawDependentCoe.El C (Raw2DFamilyCode.A2Code code s) x
  ; coe2 = λ s t t' u ->
      RawDependentCoe.coe C (Raw2DFamilyCode.A2Code code s) t t' u
  ; coe2-id = λ s t u ->
      RawDependentCoe.coe-id C (Raw2DFamilyCode.A2Code code s) t u
  ; coe2-cong = λ s t t' eq ->
      RawDependentCoe.coe-cong C (Raw2DFamilyCode.A2Code code s) t t' eq
  }

