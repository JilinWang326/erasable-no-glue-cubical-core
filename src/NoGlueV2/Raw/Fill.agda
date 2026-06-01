{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Raw.Fill where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Face
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Raw.PathLine

record RawPathFillInput
  (R : RawTarget)
  (C : Raw2DCoe R)
  (E : EndpointSections R C)
  : Set1 where
  field
    r r' : Dim

    cap : PathLineAt R C E r
    end : PathLineAt R C E r'

    SideIx : Set
    sideFace : SideIx -> Face
    sideLine :
      SideIx ->
      (q : Dim) ->
      PathLineAt R C E q

record RawPathFill
  (R : RawTarget)
  (C : Raw2DCoe R)
  (E : EndpointSections R C)
  : Set1 where
  open RawTarget R
  field
    fillLine :
      RawPathFillInput R C E ->
      (q : Dim) ->
      PathLineAt R C E q

    fill-start-app :
      (I : RawPathFillInput R C E) ->
      (d : Dim) ->
      RawEq
        (PathLineAt.L (fillLine I (RawPathFillInput.r I)) d)
        (PathLineAt.L (RawPathFillInput.cap I) d)

    fill-end-app :
      (I : RawPathFillInput R C E) ->
      (d : Dim) ->
      RawEq
        (PathLineAt.L (fillLine I (RawPathFillInput.r' I)) d)
        (PathLineAt.L (RawPathFillInput.end I) d)

    fill-side-app :
      (I : RawPathFillInput R C E) ->
      (k : RawPathFillInput.SideIx I) ->
      (psi : Face) ->
      FaceLe psi (RawPathFillInput.sideFace I k) ->
      (q d : Dim) ->
      FaceRawEq psi
        (PathLineAt.L (fillLine I q) d)
        (PathLineAt.L (RawPathFillInput.sideLine I k q) d)
