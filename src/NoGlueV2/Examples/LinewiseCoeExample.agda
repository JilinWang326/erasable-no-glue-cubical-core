{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Examples.LinewiseCoeExample where

open import NoGlueV2.Index
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Raw.PathLine

linewiseCoeExample :
  {R : RawTarget} ->
  {C : Raw2DCoe R} ->
  {E : EndpointSections R C} ->
  {t t' : Dim} ->
  PathLineAt R C E t ->
  EndpointStability R C E t t' ->
  PathLineAt R C E t'
linewiseCoeExample = transportPathLine

