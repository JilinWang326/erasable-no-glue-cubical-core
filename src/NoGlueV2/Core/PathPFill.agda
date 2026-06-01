{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Core.PathPFill where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Face
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Raw.PathLine
open import NoGlueV2.Raw.Fill
open import NoGlueV2.Core.PathP

record PathPFillCore (R : RawTarget) : Set1 where
  field
    lineCoe : Raw2DCoe R
    rawFill :
      {E : EndpointSections R lineCoe} ->
      RawPathFill R lineCoe E

record PathPFillInput
  {R : RawTarget}
  (F : PathPFillCore R)
  : Set1 where
  field
    endpoints : EndpointSections R (PathPFillCore.lineCoe F)
    rawInput :
      RawPathFillInput
        R
        (PathPFillCore.lineCoe F)
        endpoints

pathPFillTerm :
  {R : RawTarget} ->
  (F : PathPFillCore R) ->
  (I : PathPFillInput F) ->
  (q : Dim) ->
  PathPTerm
    (record
      { endpoints = PathPFillInput.endpoints I
      ; t = q
      })
pathPFillTerm F I q =
  pathPLam
    (RawPathFill.fillLine
      (PathPFillCore.rawFill F)
      (PathPFillInput.rawInput I)
      q)

pathPFillStartApp :
  {R : RawTarget} ->
  (F : PathPFillCore R) ->
  (I : PathPFillInput F) ->
  (d : Dim) ->
  RawTarget.RawEq R
    (pathPApp
      (pathPFillTerm F I
        (RawPathFillInput.r (PathPFillInput.rawInput I)))
      d)
    (PathLineAt.L
      (RawPathFillInput.cap (PathPFillInput.rawInput I))
      d)
pathPFillStartApp F I d =
  RawPathFill.fill-start-app
    (PathPFillCore.rawFill F)
    (PathPFillInput.rawInput I)
    d

pathPFillEndApp :
  {R : RawTarget} ->
  (F : PathPFillCore R) ->
  (I : PathPFillInput F) ->
  (d : Dim) ->
  RawTarget.RawEq R
    (pathPApp
      (pathPFillTerm F I
        (RawPathFillInput.r' (PathPFillInput.rawInput I)))
      d)
    (PathLineAt.L
      (RawPathFillInput.end (PathPFillInput.rawInput I))
      d)
pathPFillEndApp F I d =
  RawPathFill.fill-end-app
    (PathPFillCore.rawFill F)
    (PathPFillInput.rawInput I)
    d

pathPFillSideApp :
  {R : RawTarget} ->
  (F : PathPFillCore R) ->
  (I : PathPFillInput F) ->
  (k : RawPathFillInput.SideIx (PathPFillInput.rawInput I)) ->
  (psi : Face) ->
  FaceLe psi (RawPathFillInput.sideFace (PathPFillInput.rawInput I) k) ->
  (q d : Dim) ->
  RawTarget.FaceRawEq R psi
    (pathPApp (pathPFillTerm F I q) d)
    (PathLineAt.L
      (RawPathFillInput.sideLine (PathPFillInput.rawInput I) k q)
      d)
pathPFillSideApp F I k psi le q d =
  RawPathFill.fill-side-app
    (PathPFillCore.rawFill F)
    (PathPFillInput.rawInput I)
    k
    psi
    le
    q
    d
