{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Examples.PathPHComBoundaryExample where

open import NoGlueV2.Index
open import NoGlueV2.Face
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.PathLine
open import NoGlueV2.Raw.HCom
open import NoGlueV2.Core.PathP
open import NoGlueV2.Core.PathPHCom

pathPHComBoundaryExample :
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
pathPHComBoundaryExample = pathPHComIdApp

pathPHComSideExample :
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
pathPHComSideExample = pathPHComActiveSideApp
