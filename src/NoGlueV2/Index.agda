{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Index where

open import NoGlueV2.Prelude

data Dim : Set where
  i0 i1 : Dim

data DimEq : Dim -> Dim -> Set where
  dimRefl : {d : Dim} -> DimEq d d

record Route : Set where
  constructor route
  field
    from : Dim
    to : Dim
