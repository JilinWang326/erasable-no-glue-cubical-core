{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.ActualEqualitySoundness where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Face
open import NoGlueV2.Raw.Target
open import NoGlueV2.Raw.Pi
open import NoGlueV2.Raw.Product
open import NoGlueV2.Raw.Sigma
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
open import NoGlueV2.Integration.ActualTermSoundness
open import NoGlueV2.Integration.ActualEqualityGrammar

PiBetaTarget : PiBetaInstance -> Set
PiBetaTarget i =
  let lam = PiBetaInstance.lam i in
  let sig = PiLamInstance.sig lam in
  RawTarget.RawEq (ActualSignature.R sig)
    (piApp
      {P = ActualSignature.piStructure sig}
      {F = PiLamInstance.family lam}
      (piLam
        (ActualSignature.piStructure sig)
        (PiLamInstance.family lam)
        (PiLamInstance.body lam))
        (PiBetaInstance.argument i))
    (PiLamInstance.body lam (PiBetaInstance.argument i))

PiAppCongTarget : PiAppCongInstance -> Set
PiAppCongTarget i =
  RawTarget.RawEq (ActualSignature.R (PiAppCongInstance.sig i))
    (piApp
      {P = ActualSignature.piStructure (PiAppCongInstance.sig i)}
      {F = PiAppCongInstance.family i}
      (PiAppCongInstance.leftFun i)
      (PiAppCongInstance.argument i))
    (piApp
      {P = ActualSignature.piStructure (PiAppCongInstance.sig i)}
      {F = PiAppCongInstance.family i}
      (PiAppCongInstance.rightFun i)
      (PiAppCongInstance.argument i))

ProductFstBetaTarget : ProductFstBetaInstance -> Set
ProductFstBetaTarget i =
  let pair = ProductFstBetaInstance.pair i in
  let sig = ProductPairInstance.sig pair in
  let P = ActualSignature.productStructure sig in
  RawTarget.RawEq (ActualSignature.R sig)
    (productFst P
      (productPair
        P
        (ProductPairInstance.leftVal pair)
        (ProductPairInstance.rightVal pair)))
    (ProductPairInstance.leftVal pair)

ProductSndBetaTarget : ProductSndBetaInstance -> Set
ProductSndBetaTarget i =
  let pair = ProductSndBetaInstance.pair i in
  let sig = ProductPairInstance.sig pair in
  let P = ActualSignature.productStructure sig in
  RawTarget.RawEq (ActualSignature.R sig)
    (productSnd P
      (productPair
        P
        (ProductPairInstance.leftVal pair)
        (ProductPairInstance.rightVal pair)))
    (ProductPairInstance.rightVal pair)

ProductFstCongTarget : ProductFstCongInstance -> Set
ProductFstCongTarget i =
  let sig = ProductFstCongInstance.sig i in
  let P = ActualSignature.productStructure sig in
  RawTarget.RawEq (ActualSignature.R sig)
    (productFst P (ProductFstCongInstance.leftTerm i))
    (productFst P (ProductFstCongInstance.rightTerm i))

ProductSndCongTarget : ProductSndCongInstance -> Set
ProductSndCongTarget i =
  let sig = ProductSndCongInstance.sig i in
  let P = ActualSignature.productStructure sig in
  RawTarget.RawEq (ActualSignature.R sig)
    (productSnd P (ProductSndCongInstance.leftTerm i))
    (productSnd P (ProductSndCongInstance.rightTerm i))

SigmaFstBetaTarget : SigmaFstBetaInstance -> Set
SigmaFstBetaTarget i =
  let pair = SigmaFstBetaInstance.pair i in
  let sig = SigmaPairInstance.sig pair in
  RawTarget.RawEq (ActualSignature.R sig)
    (sigmaFst
      {S = ActualSignature.sigmaStructure sig}
      {F = SigmaPairInstance.family pair}
      (sigmaPair
        (ActualSignature.sigmaStructure sig)
        (SigmaPairInstance.family pair)
        (SigmaPairInstance.fstVal pair)
        (SigmaPairInstance.sndVal pair)))
    (SigmaPairInstance.fstVal pair)

SigmaSndBetaTarget : SigmaSndBetaInstance -> Set
SigmaSndBetaTarget i =
  let pair = SigmaSndBetaInstance.pair i in
  let sig = SigmaPairInstance.sig pair in
  RawTarget.RawEq (ActualSignature.R sig)
    (RawSigma.transport
      (ActualSignature.sigmaStructure sig)
      {A = SigmaFamily.A (SigmaPairInstance.family pair)}
      {B = SigmaFamily.B (SigmaPairInstance.family pair)}
      (sigmaFstBeta
        (ActualSignature.sigmaStructure sig)
        (SigmaPairInstance.family pair)
        (SigmaPairInstance.fstVal pair)
        (SigmaPairInstance.sndVal pair))
      (sigmaSnd
        {S = ActualSignature.sigmaStructure sig}
        {F = SigmaPairInstance.family pair}
        (sigmaPair
          (ActualSignature.sigmaStructure sig)
          (SigmaPairInstance.family pair)
          (SigmaPairInstance.fstVal pair)
          (SigmaPairInstance.sndVal pair))))
    (SigmaPairInstance.sndVal pair)

IotaReflectTarget : IotaReflectInstance -> Set
IotaReflectTarget i =
  RawTarget.RawEq (ActualSignature.R (IotaReflectInstance.sig i))
    (IotaTerm.raw (IotaReflectInstance.leftTerm i))
    (IotaTerm.raw (IotaReflectInstance.rightTerm i))

PathPAppI0Target : PathPAppI0Instance -> Set
PathPAppI0Target i =
  RawTarget.RawEq (ActualSignature.R (PathPAppI0Instance.sig i))
    (pathPApp (PathPAppI0Instance.term i) i0)
    (EndpointSections.a0
      (PathPFamily.endpoints (PathPAppI0Instance.family i))
      (PathPFamily.t (PathPAppI0Instance.family i)))

PathPAppI1Target : PathPAppI1Instance -> Set
PathPAppI1Target i =
  RawTarget.RawEq (ActualSignature.R (PathPAppI1Instance.sig i))
    (pathPApp (PathPAppI1Instance.term i) i1)
    (EndpointSections.a1
      (PathPFamily.endpoints (PathPAppI1Instance.family i))
      (PathPFamily.t (PathPAppI1Instance.family i)))

PathPAppCongTarget : PathPAppCongInstance -> Set
PathPAppCongTarget i =
  RawTarget.RawEq (ActualSignature.R (PathPAppCongInstance.sig i))
    (pathPApp
      {R = ActualSignature.R (PathPAppCongInstance.sig i)}
      {C = PathPAppCongInstance.lineCoe i}
      {F = PathPAppCongInstance.family i}
      (PathPAppCongInstance.leftTerm i)
      (PathPAppCongInstance.d i))
    (pathPApp
      {R = ActualSignature.R (PathPAppCongInstance.sig i)}
      {C = PathPAppCongInstance.lineCoe i}
      {F = PathPAppCongInstance.family i}
      (PathPAppCongInstance.rightTerm i)
      (PathPAppCongInstance.d i))

PathPCoeAppTarget : PathPCoeAppInstance -> Set
PathPCoeAppTarget i =
  let coeTerm = PathPCoeAppInstance.coeTerm i in
  let sig = PathPCoeRuleInstance.sig coeTerm in
  let P = ActualSignature.coeCore sig in
  let I = PathPCoeRuleInstance.input coeTerm in
  RawTarget.RawEq (ActualSignature.R sig)
    (pathPApp (pathPCoeTermFromTerm P I) (PathPCoeAppInstance.d i))
    (Raw2DCoe.coe2 (derived2D P) (PathPCoeAppInstance.d i)
      (PathPCoeTermInput.t I)
      (PathPCoeTermInput.t' I)
      (pathPApp
        (PathPCoeTermInput.sourceTerm I)
        (PathPCoeAppInstance.d i)))

PathPCoeIdTarget : PathPCoeIdInstance -> Set
PathPCoeIdTarget i =
  let sig = PathPCoeIdInstance.sig i in
  let P = ActualSignature.coeCore sig in
  RawTarget.RawEq (ActualSignature.R sig)
    (pathPApp
      (pathPCoeTermFromTerm P
        (pathPCoeIdInput P
          (PathPCoeIdInstance.family i)
          (PathPCoeIdInstance.term i)))
      (PathPCoeIdInstance.d i))
    (pathPApp (PathPCoeIdInstance.term i) (PathPCoeIdInstance.d i))

HComIdTarget : HComIdInstance -> Set
HComIdTarget i =
  let hcomTerm = HComIdInstance.hcomTerm i in
  let sig = PathPHComRuleInstance.sig hcomTerm in
  let H = ActualSignature.hcomCore sig in
  let I = PathPHComRuleInstance.input hcomTerm in
  RawTarget.RawEq (ActualSignature.R sig)
    (pathPApp (pathPHComTerm H I) (HComIdInstance.d i))
    (PathLineAt.L
      (RawPathHComInput.cap (PathPHComInput.rawInput I))
      (HComIdInstance.d i))

ActiveSideTarget : ActiveSideInstance -> Set
ActiveSideTarget i =
  let hcomTerm = ActiveSideInstance.hcomTerm i in
  let sig = PathPHComRuleInstance.sig hcomTerm in
  let H = ActualSignature.hcomCore sig in
  let I = PathPHComRuleInstance.input hcomTerm in
  RawTarget.FaceRawEq (ActualSignature.R sig) (ActiveSideInstance.psi i)
    (pathPApp (pathPHComTerm H I) (ActiveSideInstance.d i))
    (PathLineAt.L
      (RawPathHComInput.sideLine
        (PathPHComInput.rawInput I)
        (ActiveSideInstance.k i))
      (ActiveSideInstance.d i))

FillStartTarget : FillStartInstance -> Set
FillStartTarget i =
  let F = ActualSignature.fillCore (FillStartInstance.sig i) in
  let I = FillStartInstance.input i in
  RawTarget.RawEq (ActualSignature.R (FillStartInstance.sig i))
    (pathPApp
      (pathPFillTerm F I
        (RawPathFillInput.r (PathPFillInput.rawInput I)))
      (FillStartInstance.d i))
    (PathLineAt.L
      (RawPathFillInput.cap (PathPFillInput.rawInput I))
      (FillStartInstance.d i))

FillEndTarget : FillEndInstance -> Set
FillEndTarget i =
  let F = ActualSignature.fillCore (FillEndInstance.sig i) in
  let I = FillEndInstance.input i in
  RawTarget.RawEq (ActualSignature.R (FillEndInstance.sig i))
    (pathPApp
      (pathPFillTerm F I
        (RawPathFillInput.r' (PathPFillInput.rawInput I)))
      (FillEndInstance.d i))
    (PathLineAt.L
      (RawPathFillInput.end (PathPFillInput.rawInput I))
      (FillEndInstance.d i))

FillSideTarget : FillSideInstance -> Set
FillSideTarget i =
  let F = ActualSignature.fillCore (FillSideInstance.sig i) in
  let I = FillSideInstance.input i in
  RawTarget.FaceRawEq (ActualSignature.R (FillSideInstance.sig i))
    (FillSideInstance.psi i)
    (pathPApp
      (pathPFillTerm F I (FillSideInstance.q i))
      (FillSideInstance.d i))
    (PathLineAt.L
      (RawPathFillInput.sideLine
        (PathPFillInput.rawInput I)
        (FillSideInstance.k i)
        (FillSideInstance.q i))
      (FillSideInstance.d i))

RuleEraseTarget : ActualEqRule -> Set
RuleEraseTarget (erPiBeta i) = PiBetaTarget i
RuleEraseTarget (erPiAppCong i) = PiAppCongTarget i
RuleEraseTarget (erProductFstBeta i) = ProductFstBetaTarget i
RuleEraseTarget (erProductSndBeta i) = ProductSndBetaTarget i
RuleEraseTarget (erProductFstCong i) = ProductFstCongTarget i
RuleEraseTarget (erProductSndCong i) = ProductSndCongTarget i
RuleEraseTarget (erSigmaFstBeta i) = SigmaFstBetaTarget i
RuleEraseTarget (erSigmaSndBeta i) = SigmaSndBetaTarget i
RuleEraseTarget (erIotaReflect i) = IotaReflectTarget i
RuleEraseTarget (erPathPAppI0 i) = PathPAppI0Target i
RuleEraseTarget (erPathPAppI1 i) = PathPAppI1Target i
RuleEraseTarget (erPathPAppCong i) = PathPAppCongTarget i
RuleEraseTarget (erPathPCoeApp i) = PathPCoeAppTarget i
RuleEraseTarget (erPathPCoeId i) = PathPCoeIdTarget i
RuleEraseTarget (erHComId i) = HComIdTarget i
RuleEraseTarget (erActiveSide i) = ActiveSideTarget i
RuleEraseTarget (erFillStart i) = FillStartTarget i
RuleEraseTarget (erFillEnd i) = FillEndTarget i
RuleEraseTarget (erFillSide i) = FillSideTarget i

ActualEqEraseTarget :
  {e : ActualEqJudg} ->
  EqDeriv actualEqualityGrammar e ->
  Set
ActualEqEraseTarget (eqnode r eqs terms) = RuleEraseTarget r

record PiBetaLemma : Set1 where
  constructor piBetaLemma
  field runPiBeta : (i : PiBetaInstance) -> PiBetaTarget i

record PiAppCongLemma : Set1 where
  constructor piAppCongLemma
  field runPiAppCong : (i : PiAppCongInstance) -> PiAppCongTarget i

record ProductFstBetaLemma : Set1 where
  constructor productFstBetaLemma
  field runProductFstBeta :
          (i : ProductFstBetaInstance) -> ProductFstBetaTarget i

record ProductSndBetaLemma : Set1 where
  constructor productSndBetaLemma
  field runProductSndBeta :
          (i : ProductSndBetaInstance) -> ProductSndBetaTarget i

record ProductFstCongLemma : Set1 where
  constructor productFstCongLemma
  field runProductFstCong :
          (i : ProductFstCongInstance) -> ProductFstCongTarget i

record ProductSndCongLemma : Set1 where
  constructor productSndCongLemma
  field runProductSndCong :
          (i : ProductSndCongInstance) -> ProductSndCongTarget i

record SigmaFstBetaLemma : Set1 where
  constructor sigmaFstBetaLemma
  field runSigmaFstBeta :
          (i : SigmaFstBetaInstance) -> SigmaFstBetaTarget i

record SigmaSndBetaLemma : Set1 where
  constructor sigmaSndBetaLemma
  field runSigmaSndBeta :
          (i : SigmaSndBetaInstance) -> SigmaSndBetaTarget i

record IotaReflectLemma : Set1 where
  constructor iotaReflectLemma
  field runIotaReflect :
          (i : IotaReflectInstance) -> IotaReflectTarget i

record PathPAppI0Lemma : Set1 where
  constructor pathPAppI0Lemma
  field runPathPAppI0 : (i : PathPAppI0Instance) -> PathPAppI0Target i

record PathPAppI1Lemma : Set1 where
  constructor pathPAppI1Lemma
  field runPathPAppI1 : (i : PathPAppI1Instance) -> PathPAppI1Target i

record PathPAppEndpointLemmas : Set1 where
  constructor pathPAppEndpointLemmas
  field
    i0Lemma : PathPAppI0Lemma
    i1Lemma : PathPAppI1Lemma

record PathPAppCongLemma : Set1 where
  constructor pathPAppCongLemma
  field runPathPAppCong :
          (i : PathPAppCongInstance) -> PathPAppCongTarget i

record PathPCoeAppLemma : Set1 where
  constructor pathPCoeAppLemma
  field runPathPCoeApp :
          (i : PathPCoeAppInstance) -> PathPCoeAppTarget i

record PathPCoeIdLemma : Set1 where
  constructor pathPCoeIdLemma
  field runPathPCoeId : (i : PathPCoeIdInstance) -> PathPCoeIdTarget i

record HComIdLemma : Set1 where
  constructor hcomIdLemma
  field runHComId : (i : HComIdInstance) -> HComIdTarget i

record ActiveSideLemma : Set1 where
  constructor activeSideLemma
  field runActiveSide : (i : ActiveSideInstance) -> ActiveSideTarget i

record FillStartLemma : Set1 where
  constructor fillStartLemma
  field runFillStart : (i : FillStartInstance) -> FillStartTarget i

record FillEndLemma : Set1 where
  constructor fillEndLemma
  field runFillEnd : (i : FillEndInstance) -> FillEndTarget i

record FillSideLemma : Set1 where
  constructor fillSideLemma
  field runFillSide : (i : FillSideInstance) -> FillSideTarget i

piBetaEvidence : PiBetaLemma
piBetaEvidence = record
  { runPiBeta = \ i ->
      let lam = PiBetaInstance.lam i in
      let sig = PiLamInstance.sig lam in
      piBetaErasure
        (ActualSignature.piStructure sig)
        (PiLamInstance.family lam)
        (PiLamInstance.body lam)
        (PiBetaInstance.argument i)
  }

piAppCongEvidence : PiAppCongLemma
piAppCongEvidence = record
  { runPiAppCong = \ i ->
      piAppCong
        (PiAppCongInstance.funEq i)
        (PiAppCongInstance.argument i)
  }

productFstEvidence : ProductFstBetaLemma
productFstEvidence = record
  { runProductFstBeta = \ i ->
      let pair = ProductFstBetaInstance.pair i in
      let P = ActualSignature.productStructure (ProductPairInstance.sig pair) in
      productFstBeta
        P
        (ProductPairInstance.leftVal pair)
        (ProductPairInstance.rightVal pair)
  }

productSndEvidence : ProductSndBetaLemma
productSndEvidence = record
  { runProductSndBeta = \ i ->
      let pair = ProductSndBetaInstance.pair i in
      let P = ActualSignature.productStructure (ProductPairInstance.sig pair) in
      productSndBeta
        P
        (ProductPairInstance.leftVal pair)
        (ProductPairInstance.rightVal pair)
  }

productFstCongEvidence : ProductFstCongLemma
productFstCongEvidence = record
  { runProductFstCong = \ i ->
      productFstCong
        (ActualSignature.productStructure (ProductFstCongInstance.sig i))
        (ProductFstCongInstance.pairEq i)
  }

productSndCongEvidence : ProductSndCongLemma
productSndCongEvidence = record
  { runProductSndCong = \ i ->
      productSndCong
        (ActualSignature.productStructure (ProductSndCongInstance.sig i))
        (ProductSndCongInstance.pairEq i)
  }

sigmaFstEvidence : SigmaFstBetaLemma
sigmaFstEvidence = record
  { runSigmaFstBeta = \ i ->
      let pair = SigmaFstBetaInstance.pair i in
      let sig = SigmaPairInstance.sig pair in
      sigmaFstBeta
        (ActualSignature.sigmaStructure sig)
        (SigmaPairInstance.family pair)
        (SigmaPairInstance.fstVal pair)
        (SigmaPairInstance.sndVal pair)
  }

sigmaSndEvidence : SigmaSndBetaLemma
sigmaSndEvidence = record
  { runSigmaSndBeta = \ i ->
      let pair = SigmaSndBetaInstance.pair i in
      let sig = SigmaPairInstance.sig pair in
      sigmaSndBetaTransported
        (ActualSignature.sigmaStructure sig)
        (SigmaPairInstance.family pair)
        (SigmaPairInstance.fstVal pair)
        (SigmaPairInstance.sndVal pair)
  }

iotaReflectEvidence : IotaReflectLemma
iotaReflectEvidence = record
  { runIotaReflect = \ i ->
      iotaReflect (IotaReflectInstance.embeddedEq i)
  }

pathPAppI0Evidence : PathPAppI0Lemma
pathPAppI0Evidence = record
  { runPathPAppI0 = \ i -> pathPApp-i0 (PathPAppI0Instance.term i) }

pathPAppI1Evidence : PathPAppI1Lemma
pathPAppI1Evidence = record
  { runPathPAppI1 = \ i -> pathPApp-i1 (PathPAppI1Instance.term i) }

pathPAppEndpointEvidence : PathPAppEndpointLemmas
pathPAppEndpointEvidence = record
  { i0Lemma = pathPAppI0Evidence
  ; i1Lemma = pathPAppI1Evidence
  }

pathPAppCongEvidence : PathPAppCongLemma
pathPAppCongEvidence = record
  { runPathPAppCong = \ i ->
      pathPAppCong
        (PathPAppCongInstance.termEq i)
        (PathPAppCongInstance.d i)
  }

pathPCoeAppEvidence : PathPCoeAppLemma
pathPCoeAppEvidence = record
  { runPathPCoeApp = \ i ->
      let coeTerm = PathPCoeAppInstance.coeTerm i in
      let P = ActualSignature.coeCore (PathPCoeRuleInstance.sig coeTerm) in
      pathPCoeAppErasure
        P
        (PathPCoeRuleInstance.input coeTerm)
        (PathPCoeAppInstance.d i)
  }

pathPCoeIdEvidence : PathPCoeIdLemma
pathPCoeIdEvidence = record
  { runPathPCoeId = \ i ->
      let P = ActualSignature.coeCore (PathPCoeIdInstance.sig i) in
      pathPCoeIdApp
        P
        (PathPCoeIdInstance.family i)
        (PathPCoeIdInstance.term i)
        (PathPCoeIdInstance.d i)
  }

hcomIdEvidence : HComIdLemma
hcomIdEvidence = record
  { runHComId = \ i ->
      let hcomTerm = HComIdInstance.hcomTerm i in
      pathPHComIdApp
        (ActualSignature.hcomCore (PathPHComRuleInstance.sig hcomTerm))
        (PathPHComRuleInstance.input hcomTerm)
        (HComIdInstance.equalRadii i)
        (HComIdInstance.d i)
  }

activeSideEvidence : ActiveSideLemma
activeSideEvidence = record
  { runActiveSide = \ i ->
      let hcomTerm = ActiveSideInstance.hcomTerm i in
      pathPHComActiveSideApp
        (ActualSignature.hcomCore (PathPHComRuleInstance.sig hcomTerm))
        (PathPHComRuleInstance.input hcomTerm)
        (ActiveSideInstance.k i)
        (ActiveSideInstance.psi i)
        (ActiveSideInstance.sideLe i)
        (ActiveSideInstance.d i)
  }

fillStartEvidence : FillStartLemma
fillStartEvidence = record
  { runFillStart = \ i ->
      pathPFillStartApp
        (ActualSignature.fillCore (FillStartInstance.sig i))
        (FillStartInstance.input i)
        (FillStartInstance.d i)
  }

fillEndEvidence : FillEndLemma
fillEndEvidence = record
  { runFillEnd = \ i ->
      pathPFillEndApp
        (ActualSignature.fillCore (FillEndInstance.sig i))
        (FillEndInstance.input i)
        (FillEndInstance.d i)
  }

fillSideEvidence : FillSideLemma
fillSideEvidence = record
  { runFillSide = \ i ->
      pathPFillSideApp
        (ActualSignature.fillCore (FillSideInstance.sig i))
        (FillSideInstance.input i)
        (FillSideInstance.k i)
        (FillSideInstance.psi i)
        (FillSideInstance.sideLe i)
        (FillSideInstance.q i)
        (FillSideInstance.d i)
  }

actualEqEvidence : (r : ActualEqRule) -> RuleEraseTarget r
actualEqEvidence (erPiBeta i) = PiBetaLemma.runPiBeta piBetaEvidence i
actualEqEvidence (erPiAppCong i) =
  PiAppCongLemma.runPiAppCong piAppCongEvidence i
actualEqEvidence (erProductFstBeta i) =
  ProductFstBetaLemma.runProductFstBeta productFstEvidence i
actualEqEvidence (erProductSndBeta i) =
  ProductSndBetaLemma.runProductSndBeta productSndEvidence i
actualEqEvidence (erProductFstCong i) =
  ProductFstCongLemma.runProductFstCong productFstCongEvidence i
actualEqEvidence (erProductSndCong i) =
  ProductSndCongLemma.runProductSndCong productSndCongEvidence i
actualEqEvidence (erSigmaFstBeta i) =
  SigmaFstBetaLemma.runSigmaFstBeta sigmaFstEvidence i
actualEqEvidence (erSigmaSndBeta i) =
  SigmaSndBetaLemma.runSigmaSndBeta sigmaSndEvidence i
actualEqEvidence (erIotaReflect i) =
  IotaReflectLemma.runIotaReflect iotaReflectEvidence i
actualEqEvidence (erPathPAppI0 i) =
  PathPAppI0Lemma.runPathPAppI0 pathPAppI0Evidence i
actualEqEvidence (erPathPAppI1 i) =
  PathPAppI1Lemma.runPathPAppI1 pathPAppI1Evidence i
actualEqEvidence (erPathPAppCong i) =
  PathPAppCongLemma.runPathPAppCong pathPAppCongEvidence i
actualEqEvidence (erPathPCoeApp i) =
  PathPCoeAppLemma.runPathPCoeApp pathPCoeAppEvidence i
actualEqEvidence (erPathPCoeId i) =
  PathPCoeIdLemma.runPathPCoeId pathPCoeIdEvidence i
actualEqEvidence (erHComId i) = HComIdLemma.runHComId hcomIdEvidence i
actualEqEvidence (erActiveSide i) =
  ActiveSideLemma.runActiveSide activeSideEvidence i
actualEqEvidence (erFillStart i) =
  FillStartLemma.runFillStart fillStartEvidence i
actualEqEvidence (erFillEnd i) =
  FillEndLemma.runFillEnd fillEndEvidence i
actualEqEvidence (erFillSide i) =
  FillSideLemma.runFillSide fillSideEvidence i

actualLocalK3 :
  LocalK3 actualTermSoundness actualEqualityGrammar
actualLocalK3 = record
  { EqEraseTarget = ActualEqEraseTarget
  ; SideCond = RuleEraseTarget
  ; sideCond = actualEqEvidence
  ; localK3 = \ r eqs terms premErase termSupport evidence -> evidence
  }

actualGlobalEqualitySoundness :
  GlobalEqualitySoundness actualTermSoundness actualEqualityGrammar
actualGlobalEqualitySoundness =
  makeGlobalEqualitySoundness actualLocalK3
