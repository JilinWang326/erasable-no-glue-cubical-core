{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Core.Iota where

open import NoGlueV2.Prelude
open import NoGlueV2.Raw.Target

record IotaFamily (R : RawTarget) : Set1 where
  open RawTarget R
  field
    A : RawTy

record IotaTerm
  {R : RawTarget}
  (F : IotaFamily R)
  : Set1 where
  open RawTarget R
  open IotaFamily F
  field
    raw : RawTm A

record IotaEq
  {R : RawTarget}
  {F : IotaFamily R}
  (M N : IotaTerm F)
  : Set1 where
  open RawTarget R
  open IotaFamily F
  field
    rawEq :
      RawEq (IotaTerm.raw M) (IotaTerm.raw N)

iotaReflect :
  {R : RawTarget} ->
  {F : IotaFamily R} ->
  {M N : IotaTerm F} ->
  IotaEq M N ->
  RawTarget.RawEq R (IotaTerm.raw M) (IotaTerm.raw N)
iotaReflect eq = IotaEq.rawEq eq
