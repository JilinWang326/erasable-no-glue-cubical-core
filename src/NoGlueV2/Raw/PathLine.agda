{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Raw.PathLine where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Face
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Coe

record EndpointSections
  (R : RawTarget)
  (C : Raw2DCoe R)
  : Set1 where
  open RawTarget R
  open Raw2DCoe C
  field
    a0 : (t : Dim) -> RawTm (A2 t i0)
    a1 : (t : Dim) -> RawTm (A2 t i1)

record PathLineAt
  (R : RawTarget)
  (C : Raw2DCoe R)
  (E : EndpointSections R C)
  (t : Dim)
  : Set1 where
  open RawTarget R
  open Raw2DCoe C
  field
    L : (s : Dim) -> RawTm (A2 t s)
    eps0 : RawEq (L i0) (EndpointSections.a0 E t)
    eps1 : RawEq (L i1) (EndpointSections.a1 E t)

record EndpointStability
  (R : RawTarget)
  (C : Raw2DCoe R)
  (E : EndpointSections R C)
  (t t' : Dim)
  : Set1 where
  open RawTarget R
  open Raw2DCoe C
  field
    kappa0 :
      RawEq
        (coe2 i0 t t' (EndpointSections.a0 E t))
        (EndpointSections.a0 E t')
    kappa1 :
      RawEq
        (coe2 i1 t t' (EndpointSections.a1 E t))
        (EndpointSections.a1 E t')

record PathLineAppEq
  (R : RawTarget)
  (C : Raw2DCoe R)
  (E : EndpointSections R C)
  (t : Dim)
  (p q : PathLineAt R C E t)
  : Set1 where
  open RawTarget R
  field
    appEq : (s : Dim) -> RawEq (PathLineAt.L p s) (PathLineAt.L q s)

record FacePathLineAppEq
  (R : RawTarget)
  (C : Raw2DCoe R)
  (E : EndpointSections R C)
  (t : Dim)
  (ψ : Face)
  (p q : PathLineAt R C E t)
  : Set1 where
  open RawTarget R
  field
    appFaceEq :
      (s : Dim) -> FaceRawEq ψ (PathLineAt.L p s) (PathLineAt.L q s)

transportPathLine :
  {R : RawTarget} ->
  {C : Raw2DCoe R} ->
  {E : EndpointSections R C} ->
  {t t' : Dim} ->
  PathLineAt R C E t ->
  EndpointStability R C E t t' ->
  PathLineAt R C E t'
transportPathLine {R} {C} {E} {t} {t'} line stable = record
  { L = λ s -> Raw2DCoe.coe2 C s t t' (PathLineAt.L line s)
  ; eps0 =
      RawTarget.rawTrans R
        (Raw2DCoe.coe2-cong C i0 t t' (PathLineAt.eps0 line))
        (EndpointStability.kappa0 stable)
  ; eps1 =
      RawTarget.rawTrans R
        (Raw2DCoe.coe2-cong C i1 t t' (PathLineAt.eps1 line))
        (EndpointStability.kappa1 stable)
  }
