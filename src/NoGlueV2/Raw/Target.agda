{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Raw.Target where

open import NoGlueV2.Prelude
open import NoGlueV2.Face

record RawTarget : Set1 where
  field
    RawTy : Set
    RawTm : RawTy -> Set
    RawEq : {A : RawTy} -> RawTm A -> RawTm A -> Set

    rawRefl :
      {A : RawTy} {u : RawTm A} ->
      RawEq u u

    rawSym :
      {A : RawTy} {u v : RawTm A} ->
      RawEq u v -> RawEq v u

    rawTrans :
      {A : RawTy} {u v w : RawTm A} ->
      RawEq u v -> RawEq v w -> RawEq u w

    FaceRawEq :
      Face ->
      {A : RawTy} ->
      RawTm A -> RawTm A -> Set

    faceRawRefl :
      (ψ : Face) ->
      {A : RawTy} {u : RawTm A} ->
      FaceRawEq ψ u u

    faceRawTrans :
      (ψ : Face) ->
      {A : RawTy} {u v w : RawTm A} ->
      FaceRawEq ψ u v ->
      FaceRawEq ψ v w ->
      FaceRawEq ψ u w

