{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Examples.PathPFillBoundaryExample where

open import NoGlueV2.Index
open import NoGlueV2.Face
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.PathLine
open import NoGlueV2.Raw.Fill
open import NoGlueV2.Core.PathP
open import NoGlueV2.Core.PathPFill

pathPFillStartExample :
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
pathPFillStartExample = pathPFillStartApp

pathPFillEndExample :
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
pathPFillEndExample = pathPFillEndApp

pathPFillSideExample :
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
pathPFillSideExample = pathPFillSideApp
