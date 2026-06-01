{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Raw.HCom where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Face
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Raw.PathLine

record RawPathHComInput
  (R : RawTarget)
  (C : Raw2DCoe R)
  (E : EndpointSections R C)
  (t : Dim)
  : Set1 where
  field
    r r' : Dim
    cap : PathLineAt R C E t

    SideIx : Set
    sideFace : SideIx -> Face
    sideLine : SideIx -> PathLineAt R C E t

record RawPathHCom
  (R : RawTarget)
  (C : Raw2DCoe R)
  (E : EndpointSections R C)
  (t : Dim)
  : Set1 where
  open RawTarget R
  field
    hcomLine :
      RawPathHComInput R C E t ->
      PathLineAt R C E t

    hcom-id-app :
      (I : RawPathHComInput R C E t) ->
      DimEq (RawPathHComInput.r I) (RawPathHComInput.r' I) ->
      (d : Dim) ->
      RawEq
        (PathLineAt.L (hcomLine I) d)
        (PathLineAt.L (RawPathHComInput.cap I) d)
