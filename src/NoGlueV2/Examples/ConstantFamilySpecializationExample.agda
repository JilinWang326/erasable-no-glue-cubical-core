{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Examples.ConstantFamilySpecializationExample where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.PathLine
open import NoGlueV2.Integration.ConstantFamilySpecialization

constantFamilySpecializationExample :
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
constantFamilySpecializationExample =
  constantTransportPathLineApp
