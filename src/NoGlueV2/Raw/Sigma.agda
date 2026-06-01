{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Raw.Sigma where

open import NoGlueV2.Prelude
open import NoGlueV2.Raw.Target

record RawSigma (R : RawTarget) : Set1 where
  open RawTarget R
  field
    SigmaTy :
      (A : RawTy) ->
      (B : RawTm A -> RawTy) ->
      RawTy

    transport :
      {A : RawTy} {B : RawTm A -> RawTy} ->
      {a a' : RawTm A} ->
      RawEq a a' ->
      RawTm (B a) ->
      RawTm (B a')

    pair :
      {A : RawTy} {B : RawTm A -> RawTy} ->
      (a : RawTm A) ->
      RawTm (B a) ->
      RawTm (SigmaTy A B)

    fst :
      {A : RawTy} {B : RawTm A -> RawTy} ->
      RawTm (SigmaTy A B) ->
      RawTm A

    snd :
      {A : RawTy} {B : RawTm A -> RawTy} ->
      (p : RawTm (SigmaTy A B)) ->
      RawTm (B (fst p))

    fst-pair :
      {A : RawTy} {B : RawTm A -> RawTy} ->
      (a : RawTm A) ->
      (b : RawTm (B a)) ->
      RawEq
        (fst {A = A} {B = B}
          (pair {A = A} {B = B} a b))
        a

    snd-pair-transported :
      {A : RawTy} {B : RawTm A -> RawTy} ->
      (a : RawTm A) ->
      (b : RawTm (B a)) ->
      RawEq
        (transport {A = A} {B = B}
          (fst-pair {A = A} {B = B} a b)
          (snd {A = A} {B = B}
            (pair {A = A} {B = B} a b)))
        b

record RawSigmaEqInput
  {R : RawTarget}
  (S : RawSigma R)
  {A : RawTarget.RawTy R}
  {B : RawTarget.RawTm R A -> RawTarget.RawTy R}
  (p q : RawTarget.RawTm R (RawSigma.SigmaTy S A B))
  : Set where
  open RawTarget R
  field
    fstEq :
      RawEq
        (RawSigma.fst S {A = A} {B = B} p)
        (RawSigma.fst S {A = A} {B = B} q)
    sndEq :
      RawEq
        (RawSigma.transport S {A = A} {B = B}
          fstEq
          (RawSigma.snd S {A = A} {B = B} p))
        (RawSigma.snd S {A = A} {B = B} q)
