{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Examples.ProductExample where

open import NoGlueV2.Prelude
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Product
open import NoGlueV2.Core.Product

productFstExample :
  {R : RawTarget} ->
  (P : RawProduct R) ->
  (u : RawTarget.RawTm R (RawProduct.leftTy P)) ->
  (v : RawTarget.RawTm R (RawProduct.rightTy P)) ->
  RawTarget.RawEq R
    (productFst P (productPair P u v))
    u
productFstExample = productFstBeta

productProjectionCongExample :
  {R : RawTarget} ->
  (P : RawProduct R) ->
  {p q : ProductTerm P} ->
  RawTarget.RawEq R p q ->
  RawTarget.RawEq R (productSnd P p) (productSnd P q)
productProjectionCongExample = productSndCong
