{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.ActualNoGlueCore where

open import NoGlueV2.Prelude
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Transport
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Raw.Pi
open import NoGlueV2.Raw.Product
open import NoGlueV2.Raw.Sigma
open import NoGlueV2.Core.PathP
open import NoGlueV2.Core.PathPKan
open import NoGlueV2.Syntax.Rule
open import NoGlueV2.Integration.ComputationSummary
open import NoGlueV2.Integration.FinalNoGlueCore
open import NoGlueV2.Integration.ActualGrammar
open import NoGlueV2.Integration.ActualTermSoundness
open import NoGlueV2.Integration.ActualEqualityGrammar
open import NoGlueV2.Integration.ActualEqualitySoundness
open import NoGlueV2.Integration.ActualNoSilentConversion
open import NoGlueV2.Integration.ActualReflectionBoundary
open import NoGlueV2.Integration.ExtendedTheoremCoverage

actualComputationSummary : ComputationSummary
actualComputationSummary = record
  { piBeta = PiBetaLemma
  ; piAppCong = PiAppCongLemma
  ; productFstBeta = ProductFstBetaLemma
  ; productSndBeta = ProductSndBetaLemma
  ; productFstCong = ProductFstCongLemma
  ; productSndCong = ProductSndCongLemma
  ; sigmaFstBeta = SigmaFstBetaLemma
  ; sigmaSndBetaTransported = SigmaSndBetaLemma
  ; iotaReflection = IotaReflectLemma
  ; pathPApp = PathPAppEndpointLemmas
  ; pathPAppCong = PathPAppCongLemma
  ; pathPCoeApp = PathPCoeAppLemma
  ; pathPCoeIdentity = PathPCoeIdLemma
  ; hcomIdBoundary = HComIdLemma
  ; activeHComSide = ActiveSideLemma
  ; fillStartBoundary = FillStartLemma
  ; fillEndBoundary = FillEndLemma
  ; fillSideBoundary = FillSideLemma
  }

actualSpecializationSummary : SpecializationSummary
actualSpecializationSummary = record
  { rawTarget = RawTarget
  ; dependentTransport = (R : RawTarget) -> RawFamilyTransport R
  ; dependentPi = (R : RawTarget) -> RawPi R
  ; ordinaryProduct = (R : RawTarget) -> RawProduct R
  ; dependentSigma = (R : RawTarget) -> RawSigma R
  ; dependentPathP = (R : RawTarget) -> Raw2DCoe R
  ; pathPKan = (R : RawTarget) -> PathPKanCore R
  ; actualGrammar = ActualJudg
  }

actualNoGlueCore : FinalNoGlueCore
actualNoGlueCore = record
  { termGrammar = ActualGrammar
  ; termLocalSoundness = actualTermSoundness
  ; termSoundness = actualGlobalTermSoundness
  ; equalityGrammar = actualEqualityGrammar
  ; equalityLocalSoundness = actualLocalK3
  ; equalitySoundness = actualGlobalEqualitySoundness
  ; fiberSafety = actualFiberSafety
  ; reflection = actualReflectionBoundary
  ; computationSummary = actualComputationSummary
  ; specializationSummary = actualSpecializationSummary
  ; extendedTheoremCoverage = actualExtendedTheoremCoverage
  ; nonClaims = One
  }
