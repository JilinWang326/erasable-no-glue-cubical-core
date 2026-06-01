{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Examples.IotaReflectionExample where

open import NoGlueV2.Prelude
open import NoGlueV2.Raw.Target
open import NoGlueV2.Core.Iota

iotaReflectionExample :
  {R : RawTarget} ->
  {F : IotaFamily R} ->
  {M N : IotaTerm F} ->
  IotaEq M N ->
  RawTarget.RawEq R (IotaTerm.raw M) (IotaTerm.raw N)
iotaReflectionExample = iotaReflect
