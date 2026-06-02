{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Examples.PathPCoeObjectExample where

open import NoGlueV2.Index
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Core.PathP
open import NoGlueV2.Core.PathPCoe

pathPCoeObjectExample :
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
pathPCoeObjectExample = pathPCoeAppErasure

pathPCoeIdentityExample :
  {R : RawTarget} ->
  (P : PathPCoeCore R) ->
  (F : PathPFamily R (derived2D P)) ->
  (p : PathPTerm F) ->
  (s : Dim) ->
  RawTarget.RawEq R
    (pathPApp (pathPCoeTermFromTerm P (pathPCoeIdInput P F p)) s)
    (pathPApp p s)
pathPCoeIdentityExample = pathPCoeIdApp

