{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Core.Pi where

open import NoGlueV2.Prelude
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Pi

record PiFamily
  (R : RawTarget)
  (P : RawPi R)
  : Set1 where
  open RawTarget R
  field
    A : RawTy
    B : RawTm A -> RawTy

PiTerm :
  {R : RawTarget} ->
  {P : RawPi R} ->
  PiFamily R P ->
  Set
PiTerm {R} {P} F =
  RawTarget.RawTm R
    (RawPi.PiTy P (PiFamily.A F) (PiFamily.B F))

record PiTermEq
  {R : RawTarget}
  {P : RawPi R}
  {F : PiFamily R P}
  (f g : PiTerm F)
  : Set where
  field
    rawFunEq : RawTarget.RawEq R f g

piLam :
  {R : RawTarget} ->
  (P : RawPi R) ->
  (F : PiFamily R P) ->
  ((a : RawTarget.RawTm R (PiFamily.A F)) ->
    RawTarget.RawTm R (PiFamily.B F a)) ->
  PiTerm F
piLam {R} P F f =
  RawPi.lam P {A = PiFamily.A F} {B = PiFamily.B F} f

piApp :
  {R : RawTarget} ->
  {P : RawPi R} ->
  {F : PiFamily R P} ->
  PiTerm F ->
  (a : RawTarget.RawTm R (PiFamily.A F)) ->
  RawTarget.RawTm R (PiFamily.B F a)
piApp {P = P} {F = F} u a =
  RawPi.app P {A = PiFamily.A F} {B = PiFamily.B F} u a

piBetaErasure :
  {R : RawTarget} ->
  (P : RawPi R) ->
  (F : PiFamily R P) ->
  (f : (a : RawTarget.RawTm R (PiFamily.A F)) ->
    RawTarget.RawTm R (PiFamily.B F a)) ->
  (a : RawTarget.RawTm R (PiFamily.A F)) ->
  RawTarget.RawEq R
    (piApp {R = R} {P = P} {F = F} (piLam P F f) a)
    (f a)
piBetaErasure P F f a =
  RawPi.beta P {A = PiFamily.A F} {B = PiFamily.B F} f a

piAppCong :
  {R : RawTarget} ->
  {P : RawPi R} ->
  {F : PiFamily R P} ->
  {f g : PiTerm F} ->
  PiTermEq {R = R} {P = P} {F = F} f g ->
  (a : RawTarget.RawTm R (PiFamily.A F)) ->
  RawTarget.RawEq R
    (piApp {R = R} {P = P} {F = F} f a)
    (piApp {R = R} {P = P} {F = F} g a)
piAppCong {R = R} {P = P} {F = F} {f = f} {g = g} eq a =
  RawPi.app-cong P
    {A = PiFamily.A F}
    {B = PiFamily.B F}
    {f = f}
    {g = g}
    (PiTermEq.rawFunEq eq)
    a
