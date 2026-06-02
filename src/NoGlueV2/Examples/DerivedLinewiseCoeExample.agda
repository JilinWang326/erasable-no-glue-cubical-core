{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Examples.DerivedLinewiseCoeExample where

open import NoGlueV2.Index
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Raw.PathLine

derivedLinewiseCoeExample :
  {R : RawTarget} ->
  (C : RawDependentCoe R) ->
  (code : Raw2DFamilyCode R C) ->
  {E : EndpointSections R (derivedRaw2DCoe C code)} ->
  {t t' : Dim} ->
  PathLineAt R (derivedRaw2DCoe C code) E t ->
  EndpointStability R (derivedRaw2DCoe C code) E t t' ->
  PathLineAt R (derivedRaw2DCoe C code) E t'
derivedLinewiseCoeExample C code =
  transportPathLine

