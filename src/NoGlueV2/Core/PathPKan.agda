{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Core.PathPKan where

open import NoGlueV2.Prelude
open import NoGlueV2.Raw.Target
open import NoGlueV2.Core.PathPCoe
open import NoGlueV2.Core.PathPHCom
open import NoGlueV2.Core.PathPFill

record PathPKanCore (R : RawTarget) : Set1 where
  field
    coeCore : PathPCoeCore R
    fillCore : PathPFillCore R
    hcomCore : PathPHComCore R

