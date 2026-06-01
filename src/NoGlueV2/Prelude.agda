{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Prelude where

open import Agda.Primitive public using (Level; lzero; lsuc; _⊔_)

variable
  ℓ ℓ₁ ℓ₂ ℓ₃ : Level

record ⊤ : Set where
  constructor tt

data ⊥ : Set where

record _×_ (A : Set ℓ₁) (B : Set ℓ₂) : Set (ℓ₁ ⊔ ℓ₂) where
  constructor _,_
  field
    fst : A
    snd : B

infixr 4 _,_
infixr 2 _×_

data Zero : Set where

record One : Set where
  constructor only

data Two : Set where
  first second : Two
