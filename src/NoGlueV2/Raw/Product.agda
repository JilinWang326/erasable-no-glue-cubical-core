{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Raw.Product where

open import NoGlueV2.Prelude
open import NoGlueV2.Raw.Target

record RawProduct (R : RawTarget) : Set1 where
  open RawTarget R
  field
    leftTy  : RawTy
    rightTy : RawTy
    ProdTy  : RawTy

    pair :
      RawTm leftTy ->
      RawTm rightTy ->
      RawTm ProdTy

    fst :
      RawTm ProdTy ->
      RawTm leftTy

    snd :
      RawTm ProdTy ->
      RawTm rightTy

    fst-pair :
      (u : RawTm leftTy) ->
      (v : RawTm rightTy) ->
      RawEq (fst (pair u v)) u

    snd-pair :
      (u : RawTm leftTy) ->
      (v : RawTm rightTy) ->
      RawEq (snd (pair u v)) v

    fst-cong :
      {p q : RawTm ProdTy} ->
      RawEq p q ->
      RawEq (fst p) (fst q)

    snd-cong :
      {p q : RawTm ProdTy} ->
      RawEq p q ->
      RawEq (snd p) (snd q)
