{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.ActualGrammar where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Pi
open import NoGlueV2.Raw.Product
open import NoGlueV2.Raw.Sigma
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Raw.PathLine
open import NoGlueV2.Core.Pi
open import NoGlueV2.Core.Product
open import NoGlueV2.Core.Sigma
open import NoGlueV2.Core.PathP
open import NoGlueV2.Core.PathPCoe
open import NoGlueV2.Core.PathPHCom
open import NoGlueV2.Core.PathPFill
open import NoGlueV2.Syntax.Rule

data NoPrem : Set1 where

record ActualSignature : Set1 where
  field
    R : RawTarget

    piStructure : RawPi R
    productStructure : RawProduct R
    sigmaStructure : RawSigma R

    coeCore : PathPCoeCore R
    hcomCore : PathPHComCore R
    fillCore : PathPFillCore R

record PiLamInstance : Set1 where
  field
    sig : ActualSignature
    family :
      PiFamily
        (ActualSignature.R sig)
        (ActualSignature.piStructure sig)
    body :
      (a : RawTarget.RawTm
        (ActualSignature.R sig)
        (PiFamily.A family)) ->
      RawTarget.RawTm
        (ActualSignature.R sig)
        (PiFamily.B family a)

record PiAppInstance : Set1 where
  field
    sig : ActualSignature
    family :
      PiFamily
        (ActualSignature.R sig)
        (ActualSignature.piStructure sig)
    function : PiTerm family
    argument :
      RawTarget.RawTm
        (ActualSignature.R sig)
        (PiFamily.A family)

data PiTermPayload : Set1 where
  piLamPayload : PiLamInstance -> PiTermPayload
  piAppPayload : PiAppInstance -> PiTermPayload

record ProductPairInstance : Set1 where
  field
    sig : ActualSignature
    leftVal :
      RawTarget.RawTm
        (ActualSignature.R sig)
        (RawProduct.leftTy (ActualSignature.productStructure sig))
    rightVal :
      RawTarget.RawTm
        (ActualSignature.R sig)
        (RawProduct.rightTy (ActualSignature.productStructure sig))

record ProductFstInstance : Set1 where
  field
    sig : ActualSignature
    pairTerm : ProductTerm (ActualSignature.productStructure sig)

record ProductSndInstance : Set1 where
  field
    sig : ActualSignature
    pairTerm : ProductTerm (ActualSignature.productStructure sig)

data ProductTermPayload : Set1 where
  productPairPayload : ProductPairInstance -> ProductTermPayload
  productFstPayload : ProductFstInstance -> ProductTermPayload
  productSndPayload : ProductSndInstance -> ProductTermPayload

record SigmaPairInstance : Set1 where
  field
    sig : ActualSignature
    family :
      SigmaFamily
        (ActualSignature.R sig)
        (ActualSignature.sigmaStructure sig)
    fstVal :
      RawTarget.RawTm
        (ActualSignature.R sig)
        (SigmaFamily.A family)
    sndVal :
      RawTarget.RawTm
        (ActualSignature.R sig)
        (SigmaFamily.B family fstVal)

record SigmaFstInstance : Set1 where
  field
    sig : ActualSignature
    family :
      SigmaFamily
        (ActualSignature.R sig)
        (ActualSignature.sigmaStructure sig)
    pairTerm : SigmaTerm family

record SigmaSndInstance : Set1 where
  field
    sig : ActualSignature
    family :
      SigmaFamily
        (ActualSignature.R sig)
        (ActualSignature.sigmaStructure sig)
    pairTerm : SigmaTerm family

data SigmaTermPayload : Set1 where
  sigmaPairPayload : SigmaPairInstance -> SigmaTermPayload
  sigmaFstPayload : SigmaFstInstance -> SigmaTermPayload
  sigmaSndPayload : SigmaSndInstance -> SigmaTermPayload

record PathPLamInstance : Set1 where
  field
    sig : ActualSignature
    lineCoe : Raw2DCoe (ActualSignature.R sig)
    endpoints : EndpointSections (ActualSignature.R sig) lineCoe
    t : Dim
    line : PathLineAt (ActualSignature.R sig) lineCoe endpoints t

record PathPAppInstance : Set1 where
  field
    sig : ActualSignature
    lineCoe : Raw2DCoe (ActualSignature.R sig)
    family : PathPFamily (ActualSignature.R sig) lineCoe
    term : PathPTerm family
    d : Dim

record PathPCoeRuleInstance : Set1 where
  field
    sig : ActualSignature
    input : PathPCoeTermInput (ActualSignature.coeCore sig)

record PathPHComRuleInstance : Set1 where
  field
    sig : ActualSignature
    input : PathPHComInput (ActualSignature.hcomCore sig)

record PathPFillRuleInstance : Set1 where
  field
    sig : ActualSignature
    input : PathPFillInput (ActualSignature.fillCore sig)
    q : Dim

data PathPTermPayload : Set1 where
  pathPLamPayload : PathPLamInstance -> PathPTermPayload

data ActualJudg : Set1 where
  jPiTerm : PiTermPayload -> ActualJudg
  jProductTerm : ProductTermPayload -> ActualJudg
  jSigmaTerm : SigmaTermPayload -> ActualJudg
  jPathPTerm : PathPTermPayload -> ActualJudg
  jPathPApp : PathPAppInstance -> ActualJudg
  jPathPCoeTerm : PathPCoeRuleInstance -> ActualJudg
  jPathPHCom : PathPHComRuleInstance -> ActualJudg
  jPathPFill : PathPFillRuleInstance -> ActualJudg

data ActualRule : Set1 where
  rPiLam : PiLamInstance -> ActualRule
  rPiApp : PiAppInstance -> ActualRule
  rProductPair : ProductPairInstance -> ActualRule
  rProductFst : ProductFstInstance -> ActualRule
  rProductSnd : ProductSndInstance -> ActualRule
  rSigmaPair : SigmaPairInstance -> ActualRule
  rSigmaFst : SigmaFstInstance -> ActualRule
  rSigmaSnd : SigmaSndInstance -> ActualRule
  rPathPLam : PathPLamInstance -> ActualRule
  rPathPApp : PathPAppInstance -> ActualRule
  rPathPCoe : PathPCoeRuleInstance -> ActualRule
  rPathPHCom : PathPHComRuleInstance -> ActualRule
  rPathPFill : PathPFillRuleInstance -> ActualRule

ActualPremIx : ActualRule -> Set1
-- Premises are packaged in the rule instance record.
ActualPremIx _ = NoPrem

ActualPrem : (r : ActualRule) -> ActualPremIx r -> ActualJudg
ActualPrem _ ()

ActualConc : ActualRule -> ActualJudg
ActualConc (rPiLam i) = jPiTerm (piLamPayload i)
ActualConc (rPiApp i) = jPiTerm (piAppPayload i)
ActualConc (rProductPair i) = jProductTerm (productPairPayload i)
ActualConc (rProductFst i) = jProductTerm (productFstPayload i)
ActualConc (rProductSnd i) = jProductTerm (productSndPayload i)
ActualConc (rSigmaPair i) = jSigmaTerm (sigmaPairPayload i)
ActualConc (rSigmaFst i) = jSigmaTerm (sigmaFstPayload i)
ActualConc (rSigmaSnd i) = jSigmaTerm (sigmaSndPayload i)
ActualConc (rPathPLam i) = jPathPTerm (pathPLamPayload i)
ActualConc (rPathPApp i) = jPathPApp i
ActualConc (rPathPCoe i) = jPathPCoeTerm i
ActualConc (rPathPHCom i) = jPathPHCom i
ActualConc (rPathPFill i) = jPathPFill i

ActualGrammar : Grammar
ActualGrammar = record
  { Judg = ActualJudg
  ; Rule = ActualRule
  ; PremIx = ActualPremIx
  ; prem = ActualPrem
  ; conc = ActualConc
  }
