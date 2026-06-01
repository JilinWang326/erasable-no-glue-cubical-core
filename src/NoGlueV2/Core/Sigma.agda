{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Core.Sigma where

open import NoGlueV2.Prelude
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Sigma

record SigmaFamily
  (R : RawTarget)
  (S : RawSigma R)
  : Set1 where
  open RawTarget R
  field
    A : RawTy
    B : RawTm A -> RawTy

SigmaTerm :
  {R : RawTarget} ->
  {S : RawSigma R} ->
  SigmaFamily R S ->
  Set
SigmaTerm {R} {S} F =
  RawTarget.RawTm R
    (RawSigma.SigmaTy S (SigmaFamily.A F) (SigmaFamily.B F))

sigmaPair :
  {R : RawTarget} ->
  (S : RawSigma R) ->
  (F : SigmaFamily R S) ->
  (a : RawTarget.RawTm R (SigmaFamily.A F)) ->
  RawTarget.RawTm R (SigmaFamily.B F a) ->
  SigmaTerm F
sigmaPair S F a b =
  RawSigma.pair S {A = SigmaFamily.A F} {B = SigmaFamily.B F} a b

sigmaFst :
  {R : RawTarget} ->
  {S : RawSigma R} ->
  {F : SigmaFamily R S} ->
  SigmaTerm F ->
  RawTarget.RawTm R (SigmaFamily.A F)
sigmaFst {S = S} {F = F} p =
  RawSigma.fst S {A = SigmaFamily.A F} {B = SigmaFamily.B F} p

sigmaSnd :
  {R : RawTarget} ->
  {S : RawSigma R} ->
  {F : SigmaFamily R S} ->
  (p : SigmaTerm F) ->
  RawTarget.RawTm R
    (SigmaFamily.B F (sigmaFst {R = R} {S = S} {F = F} p))
sigmaSnd {S = S} {F = F} p =
  RawSigma.snd S {A = SigmaFamily.A F} {B = SigmaFamily.B F} p

sigmaFstBeta :
  {R : RawTarget} ->
  (S : RawSigma R) ->
  (F : SigmaFamily R S) ->
  (a : RawTarget.RawTm R (SigmaFamily.A F)) ->
  (b : RawTarget.RawTm R (SigmaFamily.B F a)) ->
  RawTarget.RawEq R
    (sigmaFst {R = R} {S = S} {F = F} (sigmaPair S F a b))
    a
sigmaFstBeta S F a b =
  RawSigma.fst-pair S {A = SigmaFamily.A F} {B = SigmaFamily.B F} a b

sigmaSndBetaTransported :
  {R : RawTarget} ->
  (S : RawSigma R) ->
  (F : SigmaFamily R S) ->
  (a : RawTarget.RawTm R (SigmaFamily.A F)) ->
  (b : RawTarget.RawTm R (SigmaFamily.B F a)) ->
  RawTarget.RawEq R
    (RawSigma.transport S {A = SigmaFamily.A F} {B = SigmaFamily.B F}
      (sigmaFstBeta S F a b)
      (sigmaSnd {R = R} {S = S} {F = F} (sigmaPair S F a b)))
    b
sigmaSndBetaTransported S F a b =
  RawSigma.snd-pair-transported S
    {A = SigmaFamily.A F}
    {B = SigmaFamily.B F}
    a b
