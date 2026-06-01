{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.ConditionalBoundaryNonDerivability where

open import NoGlueV2.Prelude
open import NoGlueV2.Face
open import NoGlueV2.Raw.Target
open import NoGlueV2.Core.Iota
open import NoGlueV2.Boundary.NonRegularity

data BoundaryTy : Set where
  boundaryTy : BoundaryTy

BoundaryTm : BoundaryTy -> Set
BoundaryTm boundaryTy = BoundaryTerm

BoundaryRawEq :
  {A : BoundaryTy} ->
  BoundaryTm A ->
  BoundaryTm A ->
  Set
BoundaryRawEq {boundaryTy} u v = BoundaryEq u v

BoundaryFaceRawEq :
  Face ->
  {A : BoundaryTy} ->
  BoundaryTm A ->
  BoundaryTm A ->
  Set
BoundaryFaceRawEq _ {boundaryTy} u v = BoundaryEq u v

boundaryRawTarget : RawTarget
boundaryRawTarget = record
  { RawTy = BoundaryTy
  ; RawTm = BoundaryTm
  ; RawEq = BoundaryRawEq
  ; rawRefl = boundaryRawRefl
  ; rawSym = boundaryRawSym
  ; rawTrans = boundaryRawTrans
  ; FaceRawEq = BoundaryFaceRawEq
  ; faceRawRefl = boundaryFaceRawRefl
  ; faceRawTrans = boundaryFaceRawTrans
  }
  where
  boundaryRawRefl :
    {A : BoundaryTy} {u : BoundaryTm A} ->
    BoundaryRawEq u u
  boundaryRawRefl {A = boundaryTy} = brefl

  boundaryRawSym :
    {A : BoundaryTy} {u v : BoundaryTm A} ->
    BoundaryRawEq u v ->
    BoundaryRawEq v u
  boundaryRawSym {A = boundaryTy} = bsym

  boundaryRawTrans :
    {A : BoundaryTy} {u v w : BoundaryTm A} ->
    BoundaryRawEq u v ->
    BoundaryRawEq v w ->
    BoundaryRawEq u w
  boundaryRawTrans {A = boundaryTy} = btrans

  boundaryFaceRawRefl :
    (phi : Face) ->
    {A : BoundaryTy} {u : BoundaryTm A} ->
    BoundaryFaceRawEq phi u u
  boundaryFaceRawRefl phi {A = boundaryTy} = brefl

  boundaryFaceRawTrans :
    (phi : Face) ->
    {A : BoundaryTy} {u v w : BoundaryTm A} ->
    BoundaryFaceRawEq phi u v ->
    BoundaryFaceRawEq phi v w ->
    BoundaryFaceRawEq phi u w
  boundaryFaceRawTrans phi {A = boundaryTy} e f = btrans e f

boundaryIotaFamily :
  IotaFamily boundaryRawTarget
boundaryIotaFamily = record
  { A = boundaryTy
  }

boundaryHIota :
  IotaTerm boundaryIotaFamily
boundaryHIota = record
  { raw = boundaryH
  }

boundaryAIota :
  IotaTerm boundaryIotaFamily
boundaryAIota = record
  { raw = boundaryA
  }

record BoundaryIotaEq : Set1 where
  field
    embedded :
      IotaEq boundaryHIota boundaryAIota

boundaryIotaEqReflected :
  BoundaryIotaEq ->
  BoundaryEq boundaryH boundaryA
boundaryIotaEqReflected e =
  iotaReflect (BoundaryIotaEq.embedded e)

conditionalBoundaryNonDerivability :
  BoundaryIotaEq ->
  ⊥
conditionalBoundaryNonDerivability e =
  boundaryNonRegular (boundaryIotaEqReflected e)
