{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Core.PathPCoe where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Raw.PathLine
open import NoGlueV2.Core.PathP

record PathPCoeCore (R : RawTarget) : Set1 where
  field
    rawCoe : RawDependentCoe R
    familyCode : Raw2DFamilyCode R rawCoe

derived2D : {R : RawTarget} -> PathPCoeCore R -> Raw2DCoe R
derived2D P =
  derivedRaw2DCoe (PathPCoeCore.rawCoe P) (PathPCoeCore.familyCode P)

record PathPCoeInput
  {R : RawTarget}
  (P : PathPCoeCore R)
  : Set1 where
  field
    endpoints : EndpointSections R (derived2D P)
    t t' : Dim
    source : PathLineAt R (derived2D P) endpoints t
    stability : EndpointStability R (derived2D P) endpoints t t'

pathPCoe :
  {R : RawTarget} ->
  (P : PathPCoeCore R) ->
  (I : PathPCoeInput P) ->
  PathLineAt R
    (derived2D P)
    (PathPCoeInput.endpoints I)
    (PathPCoeInput.t' I)
pathPCoe P I =
  transportPathLine
    (PathPCoeInput.source I)
    (PathPCoeInput.stability I)

pathPCoeLine :
  {R : RawTarget} ->
  (P : PathPCoeCore R) ->
  (I : PathPCoeInput P) ->
  (s : Dim) ->
  RawTarget.RawTm R
    (Raw2DCoe.A2 (derived2D P) (PathPCoeInput.t' I) s)
pathPCoeLine P I s = PathLineAt.L (pathPCoe P I) s

pathPCoeEps0 :
  {R : RawTarget} ->
  (P : PathPCoeCore R) ->
  (I : PathPCoeInput P) ->
  RawTarget.RawEq R
    (pathPCoeLine P I i0)
    (EndpointSections.a0 (PathPCoeInput.endpoints I) (PathPCoeInput.t' I))
pathPCoeEps0 P I = PathLineAt.eps0 (pathPCoe P I)

pathPCoeEps1 :
  {R : RawTarget} ->
  (P : PathPCoeCore R) ->
  (I : PathPCoeInput P) ->
  RawTarget.RawEq R
    (pathPCoeLine P I i1)
    (EndpointSections.a1 (PathPCoeInput.endpoints I) (PathPCoeInput.t' I))
pathPCoeEps1 P I = PathLineAt.eps1 (pathPCoe P I)

pathPCoeFamilyAt :
  {R : RawTarget} ->
  {P : PathPCoeCore R} ->
  EndpointSections R (derived2D P) ->
  Dim ->
  PathPFamily R (derived2D P)
pathPCoeFamilyAt E t = record { endpoints = E ; t = t }

record PathPCoeTermInput
  {R : RawTarget}
  (P : PathPCoeCore R)
  : Set1 where
  field
    endpoints : EndpointSections R (derived2D P)
    t t' : Dim
    sourceTerm : PathPTerm (pathPCoeFamilyAt {P = P} endpoints t)
    stability : EndpointStability R (derived2D P) endpoints t t'

sourceFamilyOfTermInput :
  {R : RawTarget} ->
  {P : PathPCoeCore R} ->
  PathPCoeTermInput P ->
  PathPFamily R (derived2D P)
sourceFamilyOfTermInput {P = P} I =
  pathPCoeFamilyAt {P = P}
    (PathPCoeTermInput.endpoints I)
    (PathPCoeTermInput.t I)

targetFamilyOfTermInput :
  {R : RawTarget} ->
  {P : PathPCoeCore R} ->
  PathPCoeTermInput P ->
  PathPFamily R (derived2D P)
targetFamilyOfTermInput {P = P} I =
  pathPCoeFamilyAt {P = P}
    (PathPCoeTermInput.endpoints I)
    (PathPCoeTermInput.t' I)

pathPCoeInputFromTerm :
  {R : RawTarget} ->
  (P : PathPCoeCore R) ->
  PathPCoeTermInput P ->
  PathPCoeInput P
pathPCoeInputFromTerm P I = record
  { endpoints = PathPCoeTermInput.endpoints I
  ; t = PathPCoeTermInput.t I
  ; t' = PathPCoeTermInput.t' I
  ; source = PathPTerm.eraseLine (PathPCoeTermInput.sourceTerm I)
  ; stability = PathPCoeTermInput.stability I
  }

pathPCoeTermFromTerm :
  {R : RawTarget} ->
  (P : PathPCoeCore R) ->
  (I : PathPCoeTermInput P) ->
  PathPTerm (targetFamilyOfTermInput I)
pathPCoeTermFromTerm P I =
  pathPLam (pathPCoe P (pathPCoeInputFromTerm P I))

pathPCoeAppErasure :
  {R : RawTarget} ->
  (P : PathPCoeCore R) ->
  (I : PathPCoeTermInput P) ->
  (s : Dim) ->
  RawTarget.RawEq R
    (pathPApp (pathPCoeTermFromTerm P I) s)
    (Raw2DCoe.coe2 (derived2D P) s
      (PathPCoeTermInput.t I)
      (PathPCoeTermInput.t' I)
      (pathPApp (PathPCoeTermInput.sourceTerm I) s))
pathPCoeAppErasure {R} P I s = RawTarget.rawRefl R

identityEndpointStability :
  {R : RawTarget} ->
  (P : PathPCoeCore R) ->
  (E : EndpointSections R (derived2D P)) ->
  (t : Dim) ->
  EndpointStability R (derived2D P) E t t
identityEndpointStability P E t = record
  { kappa0 =
      Raw2DCoe.coe2-id (derived2D P) i0 t
        (EndpointSections.a0 E t)
  ; kappa1 =
      Raw2DCoe.coe2-id (derived2D P) i1 t
        (EndpointSections.a1 E t)
  }

pathPCoeIdInput :
  {R : RawTarget} ->
  (P : PathPCoeCore R) ->
  (F : PathPFamily R (derived2D P)) ->
  (p : PathPTerm F) ->
  PathPCoeTermInput P
pathPCoeIdInput P F p = record
  { endpoints = PathPFamily.endpoints F
  ; t = PathPFamily.t F
  ; t' = PathPFamily.t F
  ; sourceTerm = p
  ; stability =
      identityEndpointStability P
        (PathPFamily.endpoints F)
        (PathPFamily.t F)
  }

pathPCoeIdApp :
  {R : RawTarget} ->
  (P : PathPCoeCore R) ->
  (F : PathPFamily R (derived2D P)) ->
  (p : PathPTerm F) ->
  (s : Dim) ->
  RawTarget.RawEq R
    (pathPApp (pathPCoeTermFromTerm P (pathPCoeIdInput P F p)) s)
    (pathPApp p s)
pathPCoeIdApp P F p s =
  Raw2DCoe.coe2-id (derived2D P) s (PathPFamily.t F) (pathPApp p s)

pathPCoeTermEndpoint0 :
  {R : RawTarget} ->
  (P : PathPCoeCore R) ->
  (I : PathPCoeTermInput P) ->
  RawTarget.RawEq R
    (pathPApp (pathPCoeTermFromTerm P I) i0)
    (EndpointSections.a0
      (PathPCoeTermInput.endpoints I)
      (PathPCoeTermInput.t' I))
pathPCoeTermEndpoint0 P I =
  pathPApp-i0 (pathPCoeTermFromTerm P I)

pathPCoeTermEndpoint1 :
  {R : RawTarget} ->
  (P : PathPCoeCore R) ->
  (I : PathPCoeTermInput P) ->
  RawTarget.RawEq R
    (pathPApp (pathPCoeTermFromTerm P I) i1)
    (EndpointSections.a1
      (PathPCoeTermInput.endpoints I)
      (PathPCoeTermInput.t' I))
pathPCoeTermEndpoint1 P I =
  pathPApp-i1 (pathPCoeTermFromTerm P I)

