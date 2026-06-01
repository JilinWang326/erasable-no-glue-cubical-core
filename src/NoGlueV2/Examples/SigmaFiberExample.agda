{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Examples.SigmaFiberExample where

open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Sigma
open import NoGlueV2.Core.Sigma

sigmaFiberExample :
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
sigmaFiberExample = sigmaSndBetaTransported
