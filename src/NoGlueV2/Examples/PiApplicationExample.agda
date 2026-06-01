{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Examples.PiApplicationExample where

open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Pi
open import NoGlueV2.Core.Pi

piApplicationExample :
  {R : RawTarget} ->
  (P : RawPi R) ->
  (F : PiFamily R P) ->
  (f :
    (a : RawTarget.RawTm R (PiFamily.A F)) ->
    RawTarget.RawTm R (PiFamily.B F a)) ->
  (a : RawTarget.RawTm R (PiFamily.A F)) ->
  RawTarget.RawEq R
    (piApp {R = R} {P = P} {F = F} (piLam P F f) a)
    (f a)
piApplicationExample = piBetaErasure

piApplicationCongExample :
  {R : RawTarget} ->
  {P : RawPi R} ->
  {F : PiFamily R P} ->
  {f g : PiTerm F} ->
  PiTermEq {R = R} {P = P} {F = F} f g ->
  (a : RawTarget.RawTm R (PiFamily.A F)) ->
  RawTarget.RawEq R
    (piApp {R = R} {P = P} {F = F} f a)
    (piApp {R = R} {P = P} {F = F} g a)
piApplicationCongExample {R = R} {P = P} {F = F} =
  piAppCong {R = R} {P = P} {F = F}
