{-# OPTIONS --cubical=no-glue --safe #-}
module Smoke.LoadEverything where

open import NoGlueCubicalCore.MainTheorem
open import NoGlueCubicalCore.Index
open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Face
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Transport
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Raw.Pi
open import NoGlueV2.Raw.Product
open import NoGlueV2.Raw.Sigma
open import NoGlueV2.Raw.PathLine
open import NoGlueV2.Raw.HCom
open import NoGlueV2.Raw.ActiveHCom
open import NoGlueV2.Raw.Fill
open import NoGlueV2.Core.Pi
open import NoGlueV2.Core.Product
open import NoGlueV2.Core.Iota
open import NoGlueV2.Core.Sigma
open import NoGlueV2.Core.PathP
open import NoGlueV2.Core.PathPCoe
open import NoGlueV2.Core.PathPHCom
open import NoGlueV2.Core.PathPFill
open import NoGlueV2.Core.PathPKan
open import NoGlueV2.Boundary.NonRegularity
open import NoGlueV2.Syntax.Rule
open import NoGlueV2.Integration.DisplayedCertificates
open import NoGlueV2.Integration.GlobalSoundness
open import NoGlueV2.Integration.EqualitySoundness
open import NoGlueV2.Integration.NoSilentConversion
open import NoGlueV2.Integration.ReflectionBoundary
open import NoGlueV2.Integration.ComputationSummary
open import NoGlueV2.Integration.ExtendedTheoremCoverage
open import NoGlueV2.Integration.ActualGrammar
open import NoGlueV2.Integration.ActualTermSoundness
open import NoGlueV2.Integration.ActualEqualityGrammar
open import NoGlueV2.Integration.ActualEqualitySoundness
open import NoGlueV2.Integration.ActualIotaReflection
open import NoGlueV2.Integration.ConditionalBoundaryNonDerivability
open import NoGlueV2.Integration.ConstantFamilySpecialization
open import NoGlueV2.Integration.ActualNoSilentConversion
open import NoGlueV2.Integration.ActualReflectionBoundary
open import NoGlueV2.Integration.FinalNoGlueCore
open import NoGlueV2.Integration.ActualNoGlueCore
open import NoGlueV2.Examples.LinewiseCoeExample
open import NoGlueV2.Examples.DerivedLinewiseCoeExample
open import NoGlueV2.Examples.SigmaFiberExample
open import NoGlueV2.Examples.PiApplicationExample
open import NoGlueV2.Examples.ProductExample
open import NoGlueV2.Examples.IotaReflectionExample
open import NoGlueV2.Examples.BoundaryNonRegularityExample
open import NoGlueV2.Examples.ConstantFamilySpecializationExample
open import NoGlueV2.Examples.PathPCoeObjectExample
open import NoGlueV2.Examples.PathPHComBoundaryExample
open import NoGlueV2.Examples.PathPFillBoundaryExample
open import NoGlueV2.Examples.SourceTaggedGrammarExample
open import NoGlueV2.Examples.EqualitySoundnessExample
open import NoGlueV2.Examples.ActualNoGlueCoreExample

smokeAssumption3Eliminated :
  BoundaryEq boundaryH boundaryA ->
  ⊥
smokeAssumption3Eliminated = Assumption3Eliminated

smokeLiftedBoundaryNonDerivability :
  BoundaryIotaEq ->
  ⊥
smokeLiftedBoundaryNonDerivability = LiftedBoundaryNonDerivability
