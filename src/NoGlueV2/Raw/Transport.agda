{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Raw.Transport where

open import NoGlueV2.Prelude
open import NoGlueV2.Raw.Target

record RawFamilyTransport (R : RawTarget) : Set1 where
  open RawTarget R
  field
    Base : RawTy
    Fam  : RawTm Base -> RawTy

    transport :
      {a a' : RawTm Base} ->
      RawEq a a' ->
      RawTm (Fam a) ->
      RawTm (Fam a')

    transport-id :
      {a : RawTm Base} ->
      (u : RawTm (Fam a)) ->
      RawEq (transport rawRefl u) u

    transport-cong :
      {a a' : RawTm Base} ->
      (q : RawEq a a') ->
      {u v : RawTm (Fam a)} ->
      RawEq u v ->
      RawEq (transport q u) (transport q v)

