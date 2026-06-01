{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.ComputationSummary where

open import NoGlueV2.Prelude

record ComputationSummary : Set2 where
  field
    piBeta : Set1
    piAppCong : Set1
    productFstBeta : Set1
    productSndBeta : Set1
    productFstCong : Set1
    productSndCong : Set1
    sigmaFstBeta : Set1
    sigmaSndBetaTransported : Set1
    iotaReflection : Set1
    pathPApp : Set1
    pathPAppCong : Set1
    pathPCoeApp : Set1
    pathPCoeIdentity : Set1
    hcomIdBoundary : Set1
    activeHComSide : Set1
    fillStartBoundary : Set1
    fillEndBoundary : Set1
    fillSideBoundary : Set1

record SpecializationSummary : Set2 where
  field
    rawTarget : Set1
    dependentTransport : Set1
    dependentPi : Set1
    ordinaryProduct : Set1
    dependentSigma : Set1
    dependentPathP : Set1
    pathPKan : Set1
    actualGrammar : Set1
