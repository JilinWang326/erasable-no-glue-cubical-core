{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Raw.Pi where

open import NoGlueV2.Prelude
open import NoGlueV2.Raw.Target

record RawPi (R : RawTarget) : Set1 where
  open RawTarget R
  field
    PiTy :
      (A : RawTy) ->
      (B : RawTm A -> RawTy) ->
      RawTy

    lam :
      {A : RawTy} {B : RawTm A -> RawTy} ->
      ((a : RawTm A) -> RawTm (B a)) ->
      RawTm (PiTy A B)

    app :
      {A : RawTy} {B : RawTm A -> RawTy} ->
      RawTm (PiTy A B) ->
      (a : RawTm A) ->
      RawTm (B a)

    beta :
      {A : RawTy} {B : RawTm A -> RawTy} ->
      (f : (a : RawTm A) -> RawTm (B a)) ->
      (a : RawTm A) ->
      RawEq (app (lam f) a) (f a)

    app-cong :
      {A : RawTy} {B : RawTm A -> RawTy} ->
      {f g : RawTm (PiTy A B)} ->
      RawEq f g ->
      (a : RawTm A) ->
      RawEq (app f a) (app g a)
