{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.ExtendedTheoremCoverage where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Pi
open import NoGlueV2.Raw.Product
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Raw.PathLine
open import NoGlueV2.Core.Product
open import NoGlueV2.Core.Iota
open import NoGlueV2.Core.Pi
open import NoGlueV2.Core.PathP
open import NoGlueV2.Core.PathPCoe
open import NoGlueV2.Boundary.NonRegularity
open import NoGlueV2.Integration.ActualIotaReflection
  renaming (iotaReflectionCoverage to actualIotaReflectionCoverage)
open import NoGlueV2.Integration.ConditionalBoundaryNonDerivability
open import NoGlueV2.Integration.ConstantFamilySpecialization

record ProductCoverage : Set2 where
  field
    fstBeta :
      {R : RawTarget} ->
      (P : RawProduct R) ->
      (u : RawTarget.RawTm R (RawProduct.leftTy P)) ->
      (v : RawTarget.RawTm R (RawProduct.rightTy P)) ->
      RawTarget.RawEq R
        (productFst P (productPair P u v))
        u
    sndBeta :
      {R : RawTarget} ->
      (P : RawProduct R) ->
      (u : RawTarget.RawTm R (RawProduct.leftTy P)) ->
      (v : RawTarget.RawTm R (RawProduct.rightTy P)) ->
      RawTarget.RawEq R
        (productSnd P (productPair P u v))
        v
    fstCong :
      {R : RawTarget} ->
      (P : RawProduct R) ->
      {p q : ProductTerm P} ->
      RawTarget.RawEq R p q ->
      RawTarget.RawEq R (productFst P p) (productFst P q)
    sndCong :
      {R : RawTarget} ->
      (P : RawProduct R) ->
      {p q : ProductTerm P} ->
      RawTarget.RawEq R p q ->
      RawTarget.RawEq R (productSnd P p) (productSnd P q)

actualProductCoverage : ProductCoverage
actualProductCoverage = record
  { fstBeta = productFstBeta
  ; sndBeta = productSndBeta
  ; fstCong = productFstCong
  ; sndCong = productSndCong
  }

record BoundaryNonRegularityCoverage : Set where
  field
    nonRegular :
      BoundaryEq boundaryH boundaryA ->
      ⊥

actualBoundaryNonRegularityCoverage : BoundaryNonRegularityCoverage
actualBoundaryNonRegularityCoverage = record
  { nonRegular = boundaryNonRegular
  }

record ConditionalBoundaryNonDerivabilityCoverage : Set1 where
  field
    impossible :
      BoundaryIotaEq ->
      ⊥

actualConditionalBoundaryNonDerivabilityCoverage :
  ConditionalBoundaryNonDerivabilityCoverage
actualConditionalBoundaryNonDerivabilityCoverage = record
  { impossible = conditionalBoundaryNonDerivability
  }

record ConstantFamilySpecializationCoverage : Set2 where
  field
    transportApp :
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
    pathPCoeIdentity :
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

actualConstantFamilySpecializationCoverage :
  ConstantFamilySpecializationCoverage
actualConstantFamilySpecializationCoverage = record
  { transportApp = constantTransportPathLineApp
  ; pathPCoeIdentity = constantPathPCoeIdApp
  }

record PiCongruenceCoverage : Set2 where
  field
    appCong :
      {R : RawTarget} ->
      {P : RawPi R} ->
      {F : PiFamily R P} ->
      {f g : PiTerm F} ->
      PiTermEq {R = R} {P = P} {F = F} f g ->
      (a : RawTarget.RawTm R (PiFamily.A F)) ->
      RawTarget.RawEq R
        (piApp {R = R} {P = P} {F = F} f a)
        (piApp {R = R} {P = P} {F = F} g a)

actualPiCongruenceCoverage : PiCongruenceCoverage
actualPiCongruenceCoverage = record
  { appCong = piAppCong
  }

record PathPCongruenceCoverage : Set2 where
  field
    appCong :
      {R : RawTarget} ->
      {C : Raw2DCoe R} ->
      {F : PathPFamily R C} ->
      {p q : PathPTerm F} ->
      PathPTermEq {R = R} {C = C} {F = F} p q ->
      (d : Dim) ->
      RawTarget.RawEq R
        (pathPApp {R = R} {C = C} {F = F} p d)
        (pathPApp {R = R} {C = C} {F = F} q d)

actualPathPCongruenceCoverage : PathPCongruenceCoverage
actualPathPCongruenceCoverage = record
  { appCong = pathPAppCong
  }

record ExtendedTheoremCoverage : Set3 where
  field
    productCoverage : ProductCoverage
    iotaReflectionCoverage : IotaReflectionCoverage
    boundaryNonRegularityCoverage : BoundaryNonRegularityCoverage
    conditionalBoundaryNonDerivabilityCoverage :
      ConditionalBoundaryNonDerivabilityCoverage
    constantFamilySpecializationCoverage :
      ConstantFamilySpecializationCoverage
    piCongruenceCoverage : PiCongruenceCoverage
    pathPCongruenceCoverage : PathPCongruenceCoverage

actualExtendedTheoremCoverage : ExtendedTheoremCoverage
actualExtendedTheoremCoverage = record
  { productCoverage = actualProductCoverage
  ; iotaReflectionCoverage = actualIotaReflectionCoverage
  ; boundaryNonRegularityCoverage = actualBoundaryNonRegularityCoverage
  ; conditionalBoundaryNonDerivabilityCoverage =
      actualConditionalBoundaryNonDerivabilityCoverage
  ; constantFamilySpecializationCoverage =
      actualConstantFamilySpecializationCoverage
  ; piCongruenceCoverage = actualPiCongruenceCoverage
  ; pathPCongruenceCoverage = actualPathPCongruenceCoverage
  }
