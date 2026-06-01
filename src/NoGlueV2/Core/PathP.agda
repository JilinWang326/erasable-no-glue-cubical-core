{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Core.PathP where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Face
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Raw.PathLine

record PathPFamily
  (R : RawTarget)
  (C : Raw2DCoe R)
  : Set1 where
  field
    endpoints : EndpointSections R C
    t : Dim

record PathPTerm
  {R : RawTarget}
  {C : Raw2DCoe R}
  (F : PathPFamily R C)
  : Set1 where
  field
    eraseLine :
      PathLineAt R C (PathPFamily.endpoints F) (PathPFamily.t F)

record PathPTermEq
  {R : RawTarget}
  {C : Raw2DCoe R}
  {F : PathPFamily R C}
  (p q : PathPTerm F)
  : Set1 where
  field
    lineEq :
      PathLineAppEq
        R
        C
        (PathPFamily.endpoints F)
        (PathPFamily.t F)
        (PathPTerm.eraseLine p)
        (PathPTerm.eraseLine q)

pathPApp :
  {R : RawTarget} ->
  {C : Raw2DCoe R} ->
  {F : PathPFamily R C} ->
  PathPTerm F ->
  (s : Dim) ->
  RawTarget.RawTm R
    (Raw2DCoe.A2 C (PathPFamily.t F) s)
pathPApp p s = PathLineAt.L (PathPTerm.eraseLine p) s

pathPAppCong :
  {R : RawTarget} ->
  {C : Raw2DCoe R} ->
  {F : PathPFamily R C} ->
  {p q : PathPTerm F} ->
  PathPTermEq {R = R} {C = C} {F = F} p q ->
  (d : Dim) ->
  RawTarget.RawEq R
    (pathPApp {R = R} {C = C} {F = F} p d)
    (pathPApp {R = R} {C = C} {F = F} q d)
pathPAppCong eq d =
  PathLineAppEq.appEq (PathPTermEq.lineEq eq) d

pathPAppCongFace :
  {R : RawTarget} ->
  {C : Raw2DCoe R} ->
  {F : PathPFamily R C} ->
  {p q : PathPTerm F} ->
  {phi : Face} ->
  FacePathLineAppEq
    R
    C
    (PathPFamily.endpoints F)
    (PathPFamily.t F)
    phi
    (PathPTerm.eraseLine p)
    (PathPTerm.eraseLine q) ->
  (d : Dim) ->
  RawTarget.FaceRawEq R phi
    (pathPApp {R = R} {C = C} {F = F} p d)
    (pathPApp {R = R} {C = C} {F = F} q d)
pathPAppCongFace eq d =
  FacePathLineAppEq.appFaceEq eq d

pathPApp-i0 :
  {R : RawTarget} ->
  {C : Raw2DCoe R} ->
  {F : PathPFamily R C} ->
  (p : PathPTerm F) ->
  RawTarget.RawEq R
    (pathPApp p i0)
    (EndpointSections.a0 (PathPFamily.endpoints F) (PathPFamily.t F))
pathPApp-i0 p = PathLineAt.eps0 (PathPTerm.eraseLine p)

pathPApp-i1 :
  {R : RawTarget} ->
  {C : Raw2DCoe R} ->
  {F : PathPFamily R C} ->
  (p : PathPTerm F) ->
  RawTarget.RawEq R
    (pathPApp p i1)
    (EndpointSections.a1 (PathPFamily.endpoints F) (PathPFamily.t F))
pathPApp-i1 p = PathLineAt.eps1 (PathPTerm.eraseLine p)

pathPLam :
  {R : RawTarget} ->
  {C : Raw2DCoe R} ->
  {E : EndpointSections R C} ->
  {t : Dim} ->
  PathLineAt R C E t ->
  PathPTerm (record { endpoints = E ; t = t })
pathPLam line = record { eraseLine = line }

pathPLamApp :
  {R : RawTarget} ->
  {C : Raw2DCoe R} ->
  {E : EndpointSections R C} ->
  {t : Dim} ->
  (line : PathLineAt R C E t) ->
  (s : Dim) ->
  RawTarget.RawEq R
    (pathPApp (pathPLam line) s)
    (PathLineAt.L line s)
pathPLamApp {R} line s = RawTarget.rawRefl R
