{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Face where

open import NoGlueV2.Prelude

data Face : Set where
  top : Face
  faceAnd : Face -> Face -> Face

record FaceLe (psi phi : Face) : Set where
  constructor faceLe
