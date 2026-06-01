{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Raw.ActiveHCom where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Face
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Raw.PathLine
open import NoGlueV2.Raw.HCom

record RawPathActiveHCom
  {R : RawTarget}
  {C : Raw2DCoe R}
  {E : EndpointSections R C}
  {t : Dim}
  (H : RawPathHCom R C E t)
  : Set1 where
  open RawTarget R
  field
    active-side-app :
      (I : RawPathHComInput R C E t) ->
      (k : RawPathHComInput.SideIx I) ->
      (psi : Face) ->
      FaceLe psi (RawPathHComInput.sideFace I k) ->
      (d : Dim) ->
      FaceRawEq psi
        (PathLineAt.L (RawPathHCom.hcomLine H I) d)
        (PathLineAt.L (RawPathHComInput.sideLine I k) d)
