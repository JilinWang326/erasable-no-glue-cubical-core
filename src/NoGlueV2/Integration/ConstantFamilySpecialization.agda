{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.ConstantFamilySpecialization where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Raw.PathLine
open import NoGlueV2.Core.PathP
open import NoGlueV2.Core.PathPCoe

constantRaw2DCoe :
  {R : RawTarget} ->
  RawTarget.RawTy R ->
  Raw2DCoe R
constantRaw2DCoe {R} A = record
  { A2 = \ t s -> A
  ; coe2 = \ s t t' u -> u
  ; coe2-id = \ s t u -> RawTarget.rawRefl R
  ; coe2-cong = \ s t t' q -> q
  }

record ConstantEndpointSections
  (R : RawTarget)
  (A : RawTarget.RawTy R)
  : Set1 where
  open RawTarget R
  field
    a0c : RawTm A
    a1c : RawTm A

constantEndpointSections :
  {R : RawTarget} ->
  {A : RawTarget.RawTy R} ->
  ConstantEndpointSections R A ->
  EndpointSections R (constantRaw2DCoe A)
constantEndpointSections E = record
  { a0 = \ t -> ConstantEndpointSections.a0c E
  ; a1 = \ t -> ConstantEndpointSections.a1c E
  }

constantEndpointStability :
  {R : RawTarget} ->
  {A : RawTarget.RawTy R} ->
  (E : ConstantEndpointSections R A) ->
  (t t' : Dim) ->
  EndpointStability
    R
    (constantRaw2DCoe A)
    (constantEndpointSections E)
    t
    t'
constantEndpointStability {R} E t t' = record
  { kappa0 = RawTarget.rawRefl R
  ; kappa1 = RawTarget.rawRefl R
  }

constantTransportPathLineApp :
  {R : RawTarget} ->
  {A : RawTarget.RawTy R} ->
  (E : ConstantEndpointSections R A) ->
  {t t' : Dim} ->
  (source :
    PathLineAt R
      (constantRaw2DCoe A)
      (constantEndpointSections E)
      t) ->
  (d : Dim) ->
  RawTarget.RawEq R
    (PathLineAt.L
      (transportPathLine
        source
        (constantEndpointStability E t t'))
      d)
    (PathLineAt.L source d)
constantTransportPathLineApp {R} E source d =
  RawTarget.rawRefl R

constantRawDependentCoe :
  {R : RawTarget} ->
  RawTarget.RawTy R ->
  RawDependentCoe R
constantRawDependentCoe {R} A = record
  { Fam = One
  ; El = \ c t -> A
  ; coe = \ c t t' u -> u
  ; coe-id = \ c t u -> RawTarget.rawRefl R
  ; coe-cong = \ c t t' q -> q
  }

constant2DFamilyCode :
  {R : RawTarget} ->
  (A : RawTarget.RawTy R) ->
  Raw2DFamilyCode R (constantRawDependentCoe A)
constant2DFamilyCode A = record
  { A2Code = \ s -> only
  }

constantPathPCoeCore :
  {R : RawTarget} ->
  RawTarget.RawTy R ->
  PathPCoeCore R
constantPathPCoeCore A = record
  { rawCoe = constantRawDependentCoe A
  ; familyCode = constant2DFamilyCode A
  }

constantPathPCoeIdApp :
  {R : RawTarget} ->
  (A : RawTarget.RawTy R) ->
  (F : PathPFamily R (derived2D (constantPathPCoeCore A))) ->
  (p : PathPTerm F) ->
  (d : Dim) ->
  RawTarget.RawEq R
    (pathPApp
      (pathPCoeTermFromTerm
        (constantPathPCoeCore A)
        (pathPCoeIdInput (constantPathPCoeCore A) F p))
      d)
    (pathPApp p d)
constantPathPCoeIdApp A =
  pathPCoeIdApp (constantPathPCoeCore A)
