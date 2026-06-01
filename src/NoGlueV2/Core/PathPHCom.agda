{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Core.PathPHCom where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Face
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Raw.PathLine
open import NoGlueV2.Raw.HCom
open import NoGlueV2.Raw.ActiveHCom
open import NoGlueV2.Core.PathP

record PathPHComCore (R : RawTarget) : Set1 where
  field
    lineCoe : Raw2DCoe R
    rawHCom :
      {E : EndpointSections R lineCoe} ->
      (t : Dim) ->
      RawPathHCom R lineCoe E t
    activeHCom :
      {E : EndpointSections R lineCoe} ->
      {t : Dim} ->
      RawPathActiveHCom (rawHCom {E = E} t)

record PathPHComInput
  {R : RawTarget}
  (H : PathPHComCore R)
  : Set1 where
  field
    endpoints : EndpointSections R (PathPHComCore.lineCoe H)
    t : Dim
    rawInput :
      RawPathHComInput
        R
        (PathPHComCore.lineCoe H)
        endpoints
        t

pathPHComTerm :
  {R : RawTarget} ->
  (H : PathPHComCore R) ->
  (I : PathPHComInput H) ->
  PathPTerm
    (record
      { endpoints = PathPHComInput.endpoints I
      ; t = PathPHComInput.t I
      })
pathPHComTerm H I =
  pathPLam
    (RawPathHCom.hcomLine
      (PathPHComCore.rawHCom H (PathPHComInput.t I))
      (PathPHComInput.rawInput I))

pathPHComIdApp :
  {R : RawTarget} ->
  (H : PathPHComCore R) ->
  (I : PathPHComInput H) ->
  DimEq
    (RawPathHComInput.r (PathPHComInput.rawInput I))
    (RawPathHComInput.r' (PathPHComInput.rawInput I)) ->
  (d : Dim) ->
  RawTarget.RawEq R
    (pathPApp (pathPHComTerm H I) d)
    (PathLineAt.L
      (RawPathHComInput.cap (PathPHComInput.rawInput I))
      d)
pathPHComIdApp H I eq d =
  RawPathHCom.hcom-id-app
    (PathPHComCore.rawHCom H (PathPHComInput.t I))
    (PathPHComInput.rawInput I)
    eq
    d

pathPHComActiveSideApp :
  {R : RawTarget} ->
  (H : PathPHComCore R) ->
  (I : PathPHComInput H) ->
  (k : RawPathHComInput.SideIx (PathPHComInput.rawInput I)) ->
  (psi : Face) ->
  FaceLe psi (RawPathHComInput.sideFace (PathPHComInput.rawInput I) k) ->
  (d : Dim) ->
  RawTarget.FaceRawEq R psi
    (pathPApp (pathPHComTerm H I) d)
    (PathLineAt.L
      (RawPathHComInput.sideLine (PathPHComInput.rawInput I) k)
      d)
pathPHComActiveSideApp H I k psi le d =
  RawPathActiveHCom.active-side-app
    (PathPHComCore.activeHCom H)
    (PathPHComInput.rawInput I)
    k
    psi
    le
    d
