{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.ActualIotaReflection where

open import NoGlueV2.Prelude
open import NoGlueV2.Raw.Target
open import NoGlueV2.Core.Iota
open import NoGlueV2.Integration.ActualGrammar

actualIotaReflect :
  {sig : ActualSignature} ->
  {F : IotaFamily (ActualSignature.R sig)} ->
  {M N : IotaTerm F} ->
  IotaEq M N ->
  RawTarget.RawEq
    (ActualSignature.R sig)
    (IotaTerm.raw M)
    (IotaTerm.raw N)
actualIotaReflect = iotaReflect

record IotaReflectionCoverage : Set2 where
  field
    reflect :
      {R : RawTarget} ->
      {F : IotaFamily R} ->
      {M N : IotaTerm F} ->
      IotaEq M N ->
      RawTarget.RawEq R (IotaTerm.raw M) (IotaTerm.raw N)

iotaReflectionCoverage : IotaReflectionCoverage
iotaReflectionCoverage = record
  { reflect = iotaReflect
  }
