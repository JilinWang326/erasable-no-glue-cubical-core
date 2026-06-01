{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Examples.BoundaryNonRegularityExample where

open import NoGlueV2.Prelude
open import NoGlueV2.Boundary.NonRegularity

boundaryNonRegularityExample :
  BoundaryEq boundaryH boundaryA ->
  ⊥
boundaryNonRegularityExample = boundaryNonRegular
