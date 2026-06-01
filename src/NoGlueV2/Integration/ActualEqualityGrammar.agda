{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.ActualEqualityGrammar where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Face
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Product
open import NoGlueV2.Raw.Coe
open import NoGlueV2.Raw.PathLine
open import NoGlueV2.Raw.HCom
open import NoGlueV2.Raw.Fill
open import NoGlueV2.Core.Pi
open import NoGlueV2.Core.Product
open import NoGlueV2.Core.Iota
open import NoGlueV2.Core.Sigma
open import NoGlueV2.Core.PathP
open import NoGlueV2.Core.PathPCoe
open import NoGlueV2.Core.PathPHCom
open import NoGlueV2.Core.PathPFill
open import NoGlueV2.Syntax.Rule
open import NoGlueV2.Integration.EqualitySoundness
open import NoGlueV2.Integration.ActualGrammar

record PiBetaInstance : Set1 where
  field
    lam : PiLamInstance
    argument :
      RawTarget.RawTm
        (ActualSignature.R (PiLamInstance.sig lam))
        (PiFamily.A (PiLamInstance.family lam))

record PiAppCongInstance : Set1 where
  field
    sig : ActualSignature
    family :
      PiFamily
        (ActualSignature.R sig)
        (ActualSignature.piStructure sig)
    leftFun : PiTerm family
    rightFun : PiTerm family
    funEq :
      PiTermEq
        {R = ActualSignature.R sig}
        {P = ActualSignature.piStructure sig}
        {F = family}
        leftFun
        rightFun
    argument :
      RawTarget.RawTm
        (ActualSignature.R sig)
        (PiFamily.A family)

record ProductFstBetaInstance : Set1 where
  field
    pair : ProductPairInstance

record ProductSndBetaInstance : Set1 where
  field
    pair : ProductPairInstance

record ProductFstCongInstance : Set1 where
  field
    sig : ActualSignature
    leftTerm : ProductTerm (ActualSignature.productStructure sig)
    rightTerm : ProductTerm (ActualSignature.productStructure sig)
    pairEq :
      RawTarget.RawEq
        (ActualSignature.R sig)
        leftTerm
        rightTerm

record ProductSndCongInstance : Set1 where
  field
    sig : ActualSignature
    leftTerm : ProductTerm (ActualSignature.productStructure sig)
    rightTerm : ProductTerm (ActualSignature.productStructure sig)
    pairEq :
      RawTarget.RawEq
        (ActualSignature.R sig)
        leftTerm
        rightTerm

record SigmaFstBetaInstance : Set1 where
  field
    pair : SigmaPairInstance

record SigmaSndBetaInstance : Set1 where
  field
    pair : SigmaPairInstance

record IotaReflectInstance : Set1 where
  field
    sig : ActualSignature
    family : IotaFamily (ActualSignature.R sig)
    leftTerm : IotaTerm family
    rightTerm : IotaTerm family
    embeddedEq :
      IotaEq
        {R = ActualSignature.R sig}
        {F = family}
        leftTerm
        rightTerm

record PathPAppI0Instance : Set1 where
  field
    sig : ActualSignature
    lineCoe : Raw2DCoe (ActualSignature.R sig)
    family : PathPFamily (ActualSignature.R sig) lineCoe
    term : PathPTerm family

record PathPAppI1Instance : Set1 where
  field
    sig : ActualSignature
    lineCoe : Raw2DCoe (ActualSignature.R sig)
    family : PathPFamily (ActualSignature.R sig) lineCoe
    term : PathPTerm family

record PathPAppCongInstance : Set1 where
  field
    sig : ActualSignature
    lineCoe : Raw2DCoe (ActualSignature.R sig)
    family : PathPFamily (ActualSignature.R sig) lineCoe
    leftTerm : PathPTerm family
    rightTerm : PathPTerm family
    termEq :
      PathPTermEq
        {R = ActualSignature.R sig}
        {C = lineCoe}
        {F = family}
        leftTerm
        rightTerm
    d : Dim

record PathPCoeAppInstance : Set1 where
  field
    coeTerm : PathPCoeRuleInstance
    d : Dim

record PathPCoeIdInstance : Set1 where
  field
    sig : ActualSignature
    family :
      PathPFamily
        (ActualSignature.R sig)
        (derived2D (ActualSignature.coeCore sig))
    term : PathPTerm family
    d : Dim

record HComIdInstance : Set1 where
  field
    hcomTerm : PathPHComRuleInstance
    equalRadii :
      DimEq
        (RawPathHComInput.r
          (PathPHComInput.rawInput
            (PathPHComRuleInstance.input hcomTerm)))
        (RawPathHComInput.r'
          (PathPHComInput.rawInput
            (PathPHComRuleInstance.input hcomTerm)))
    d : Dim

record ActiveSideInstance : Set1 where
  field
    hcomTerm : PathPHComRuleInstance
    k :
      RawPathHComInput.SideIx
        (PathPHComInput.rawInput
          (PathPHComRuleInstance.input hcomTerm))
    psi : Face
    sideLe :
      FaceLe psi
        (RawPathHComInput.sideFace
        (PathPHComInput.rawInput
          (PathPHComRuleInstance.input hcomTerm))
        k)
    d : Dim

record FillStartInstance : Set1 where
  field
    sig : ActualSignature
    input : PathPFillInput (ActualSignature.fillCore sig)
    d : Dim

record FillEndInstance : Set1 where
  field
    sig : ActualSignature
    input : PathPFillInput (ActualSignature.fillCore sig)
    d : Dim

record FillSideInstance : Set1 where
  field
    sig : ActualSignature
    input : PathPFillInput (ActualSignature.fillCore sig)
    k :
      RawPathFillInput.SideIx
        (PathPFillInput.rawInput input)
    psi : Face
    sideLe :
      FaceLe psi
        (RawPathFillInput.sideFace
        (PathPFillInput.rawInput input)
        k)
    q d : Dim

data ActualEqJudg : Set1 where
  eqPiBeta : PiBetaInstance -> ActualEqJudg
  eqPiAppCong : PiAppCongInstance -> ActualEqJudg
  eqProductFstBeta : ProductFstBetaInstance -> ActualEqJudg
  eqProductSndBeta : ProductSndBetaInstance -> ActualEqJudg
  eqProductFstCong : ProductFstCongInstance -> ActualEqJudg
  eqProductSndCong : ProductSndCongInstance -> ActualEqJudg
  eqSigmaFstBeta : SigmaFstBetaInstance -> ActualEqJudg
  eqSigmaSndBeta : SigmaSndBetaInstance -> ActualEqJudg
  eqIotaReflect : IotaReflectInstance -> ActualEqJudg
  eqPathPAppI0 : PathPAppI0Instance -> ActualEqJudg
  eqPathPAppI1 : PathPAppI1Instance -> ActualEqJudg
  eqPathPAppCong : PathPAppCongInstance -> ActualEqJudg
  eqPathPCoeApp : PathPCoeAppInstance -> ActualEqJudg
  eqPathPCoeId : PathPCoeIdInstance -> ActualEqJudg
  eqHComId : HComIdInstance -> ActualEqJudg
  eqActiveSide : ActiveSideInstance -> ActualEqJudg
  eqFillStart : FillStartInstance -> ActualEqJudg
  eqFillEnd : FillEndInstance -> ActualEqJudg
  eqFillSide : FillSideInstance -> ActualEqJudg

data ActualEqRule : Set1 where
  erPiBeta : PiBetaInstance -> ActualEqRule
  erPiAppCong : PiAppCongInstance -> ActualEqRule
  erProductFstBeta : ProductFstBetaInstance -> ActualEqRule
  erProductSndBeta : ProductSndBetaInstance -> ActualEqRule
  erProductFstCong : ProductFstCongInstance -> ActualEqRule
  erProductSndCong : ProductSndCongInstance -> ActualEqRule
  erSigmaFstBeta : SigmaFstBetaInstance -> ActualEqRule
  erSigmaSndBeta : SigmaSndBetaInstance -> ActualEqRule
  erIotaReflect : IotaReflectInstance -> ActualEqRule
  erPathPAppI0 : PathPAppI0Instance -> ActualEqRule
  erPathPAppI1 : PathPAppI1Instance -> ActualEqRule
  erPathPAppCong : PathPAppCongInstance -> ActualEqRule
  erPathPCoeApp : PathPCoeAppInstance -> ActualEqRule
  erPathPCoeId : PathPCoeIdInstance -> ActualEqRule
  erHComId : HComIdInstance -> ActualEqRule
  erActiveSide : ActiveSideInstance -> ActualEqRule
  erFillStart : FillStartInstance -> ActualEqRule
  erFillEnd : FillEndInstance -> ActualEqRule
  erFillSide : FillSideInstance -> ActualEqRule

ActualEqPremIx : ActualEqRule -> Set1
-- Premises are packaged in the equality rule instance record.
ActualEqPremIx _ = NoPrem

ActualEqPrem : (r : ActualEqRule) -> ActualEqPremIx r -> ActualEqJudg
ActualEqPrem _ ()

ActualTermPremIx : ActualEqRule -> Set1
-- Term premises are represented by the concrete payloads in each equality rule.
ActualTermPremIx _ = NoPrem

ActualTermPrem : (r : ActualEqRule) -> ActualTermPremIx r -> ActualJudg
ActualTermPrem _ ()

ActualEqConc : ActualEqRule -> ActualEqJudg
ActualEqConc (erPiBeta i) = eqPiBeta i
ActualEqConc (erPiAppCong i) = eqPiAppCong i
ActualEqConc (erProductFstBeta i) = eqProductFstBeta i
ActualEqConc (erProductSndBeta i) = eqProductSndBeta i
ActualEqConc (erProductFstCong i) = eqProductFstCong i
ActualEqConc (erProductSndCong i) = eqProductSndCong i
ActualEqConc (erSigmaFstBeta i) = eqSigmaFstBeta i
ActualEqConc (erSigmaSndBeta i) = eqSigmaSndBeta i
ActualEqConc (erIotaReflect i) = eqIotaReflect i
ActualEqConc (erPathPAppI0 i) = eqPathPAppI0 i
ActualEqConc (erPathPAppI1 i) = eqPathPAppI1 i
ActualEqConc (erPathPAppCong i) = eqPathPAppCong i
ActualEqConc (erPathPCoeApp i) = eqPathPCoeApp i
ActualEqConc (erPathPCoeId i) = eqPathPCoeId i
ActualEqConc (erHComId i) = eqHComId i
ActualEqConc (erActiveSide i) = eqActiveSide i
ActualEqConc (erFillStart i) = eqFillStart i
ActualEqConc (erFillEnd i) = eqFillEnd i
ActualEqConc (erFillSide i) = eqFillSide i

actualEqualityGrammar : EqualityGrammar ActualGrammar
actualEqualityGrammar = record
  { EqJudg = ActualEqJudg
  ; EqRule = ActualEqRule
  ; EqPremIx = ActualEqPremIx
  ; eqPrem = ActualEqPrem
  ; TermPremIx = ActualTermPremIx
  ; termPrem = ActualTermPrem
  ; eqConc = ActualEqConc
  }
