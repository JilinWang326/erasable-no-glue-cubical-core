{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Core.Product where

open import NoGlueV2.Prelude
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Product

ProductTerm :
  {R : RawTarget} ->
  RawProduct R ->
  Set
ProductTerm {R} P =
  RawTarget.RawTm R (RawProduct.ProdTy P)

productPair :
  {R : RawTarget} ->
  (P : RawProduct R) ->
  RawTarget.RawTm R (RawProduct.leftTy P) ->
  RawTarget.RawTm R (RawProduct.rightTy P) ->
  ProductTerm P
productPair P u v = RawProduct.pair P u v

productFst :
  {R : RawTarget} ->
  (P : RawProduct R) ->
  ProductTerm P ->
  RawTarget.RawTm R (RawProduct.leftTy P)
productFst P p = RawProduct.fst P p

productSnd :
  {R : RawTarget} ->
  (P : RawProduct R) ->
  ProductTerm P ->
  RawTarget.RawTm R (RawProduct.rightTy P)
productSnd P p = RawProduct.snd P p

productFstBeta :
  {R : RawTarget} ->
  (P : RawProduct R) ->
  (u : RawTarget.RawTm R (RawProduct.leftTy P)) ->
  (v : RawTarget.RawTm R (RawProduct.rightTy P)) ->
  RawTarget.RawEq R
    (productFst P (productPair P u v))
    u
productFstBeta P u v = RawProduct.fst-pair P u v

productSndBeta :
  {R : RawTarget} ->
  (P : RawProduct R) ->
  (u : RawTarget.RawTm R (RawProduct.leftTy P)) ->
  (v : RawTarget.RawTm R (RawProduct.rightTy P)) ->
  RawTarget.RawEq R
    (productSnd P (productPair P u v))
    v
productSndBeta P u v = RawProduct.snd-pair P u v

productFstCong :
  {R : RawTarget} ->
  (P : RawProduct R) ->
  {p q : ProductTerm P} ->
  RawTarget.RawEq R p q ->
  RawTarget.RawEq R (productFst P p) (productFst P q)
productFstCong P eq = RawProduct.fst-cong P eq

productSndCong :
  {R : RawTarget} ->
  (P : RawProduct R) ->
  {p q : ProductTerm P} ->
  RawTarget.RawEq R p q ->
  RawTarget.RawEq R (productSnd P p) (productSnd P q)
productSndCong P eq = RawProduct.snd-cong P eq
