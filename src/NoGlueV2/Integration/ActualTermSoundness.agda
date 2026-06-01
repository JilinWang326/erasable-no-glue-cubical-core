{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.ActualTermSoundness where

open import NoGlueV2.Prelude
open import NoGlueV2.Syntax.Rule
open import NoGlueV2.Integration.DisplayedCertificates
open import NoGlueV2.Integration.GlobalSoundness
open import NoGlueV2.Integration.ActualGrammar

data ActualRuleRoute : ActualRule -> Set2 where
  routePiLam : (i : PiLamInstance) -> ActualRuleRoute (rPiLam i)
  routePiApp : (i : PiAppInstance) -> ActualRuleRoute (rPiApp i)
  routeProductPair :
    (i : ProductPairInstance) -> ActualRuleRoute (rProductPair i)
  routeProductFst :
    (i : ProductFstInstance) -> ActualRuleRoute (rProductFst i)
  routeProductSnd :
    (i : ProductSndInstance) -> ActualRuleRoute (rProductSnd i)
  routeSigmaPair :
    (i : SigmaPairInstance) -> ActualRuleRoute (rSigmaPair i)
  routeSigmaFst :
    (i : SigmaFstInstance) -> ActualRuleRoute (rSigmaFst i)
  routeSigmaSnd :
    (i : SigmaSndInstance) -> ActualRuleRoute (rSigmaSnd i)
  routePathPLam :
    (i : PathPLamInstance) -> ActualRuleRoute (rPathPLam i)
  routePathPApp :
    (i : PathPAppInstance) -> ActualRuleRoute (rPathPApp i)
  routePathPCoe :
    (i : PathPCoeRuleInstance) -> ActualRuleRoute (rPathPCoe i)
  routePathPHCom :
    (i : PathPHComRuleInstance) -> ActualRuleRoute (rPathPHCom i)
  routePathPFill :
    (i : PathPFillRuleInstance) -> ActualRuleRoute (rPathPFill i)

data ActualRulePI : ActualRule -> Set2 where
  piPiLam : (i : PiLamInstance) -> ActualRulePI (rPiLam i)
  piPiApp : (i : PiAppInstance) -> ActualRulePI (rPiApp i)
  piProductPair :
    (i : ProductPairInstance) -> ActualRulePI (rProductPair i)
  piProductFst :
    (i : ProductFstInstance) -> ActualRulePI (rProductFst i)
  piProductSnd :
    (i : ProductSndInstance) -> ActualRulePI (rProductSnd i)
  piSigmaPair : (i : SigmaPairInstance) -> ActualRulePI (rSigmaPair i)
  piSigmaFst : (i : SigmaFstInstance) -> ActualRulePI (rSigmaFst i)
  piSigmaSnd : (i : SigmaSndInstance) -> ActualRulePI (rSigmaSnd i)
  piPathPLam : (i : PathPLamInstance) -> ActualRulePI (rPathPLam i)
  piPathPApp : (i : PathPAppInstance) -> ActualRulePI (rPathPApp i)
  piPathPCoe : (i : PathPCoeRuleInstance) -> ActualRulePI (rPathPCoe i)
  piPathPHCom : (i : PathPHComRuleInstance) -> ActualRulePI (rPathPHCom i)
  piPathPFill : (i : PathPFillRuleInstance) -> ActualRulePI (rPathPFill i)

routeEvidence : (r : ActualRule) -> ActualRuleRoute r
routeEvidence (rPiLam i) = routePiLam i
routeEvidence (rPiApp i) = routePiApp i
routeEvidence (rProductPair i) = routeProductPair i
routeEvidence (rProductFst i) = routeProductFst i
routeEvidence (rProductSnd i) = routeProductSnd i
routeEvidence (rSigmaPair i) = routeSigmaPair i
routeEvidence (rSigmaFst i) = routeSigmaFst i
routeEvidence (rSigmaSnd i) = routeSigmaSnd i
routeEvidence (rPathPLam i) = routePathPLam i
routeEvidence (rPathPApp i) = routePathPApp i
routeEvidence (rPathPCoe i) = routePathPCoe i
routeEvidence (rPathPHCom i) = routePathPHCom i
routeEvidence (rPathPFill i) = routePathPFill i

piEvidence : (r : ActualRule) -> ActualRulePI r
piEvidence (rPiLam i) = piPiLam i
piEvidence (rPiApp i) = piPiApp i
piEvidence (rProductPair i) = piProductPair i
piEvidence (rProductFst i) = piProductFst i
piEvidence (rProductSnd i) = piProductSnd i
piEvidence (rSigmaPair i) = piSigmaPair i
piEvidence (rSigmaFst i) = piSigmaFst i
piEvidence (rSigmaSnd i) = piSigmaSnd i
piEvidence (rPathPLam i) = piPathPLam i
piEvidence (rPathPApp i) = piPathPApp i
piEvidence (rPathPCoe i) = piPathPCoe i
piEvidence (rPathPHCom i) = piPathPHCom i
piEvidence (rPathPFill i) = piPathPFill i

data ActualRouteCoh
  : {j : ActualJudg} ->
  Deriv ActualGrammar j ->
  Set2 where
  route-node :
    {r : ActualRule}
    {ds :
      (p : ActualPremIx r) ->
      Deriv ActualGrammar (ActualPrem r p)} ->
    ActualRuleRoute r ->
    ((p : ActualPremIx r) -> ActualRouteCoh (ds p)) ->
    ActualRouteCoh (node r ds)

data ActualPICoh
  : {j : ActualJudg} ->
  {d e : Deriv ActualGrammar j} ->
  SameShape d e ->
  Set2 where
  pi-node :
    {r : ActualRule}
    {ds es :
      (p : ActualPremIx r) ->
      Deriv ActualGrammar (ActualPrem r p)} ->
    {sh :
      (p : ActualPremIx r) ->
      SameShape (ds p) (es p)} ->
    ActualRulePI r ->
    ((p : ActualPremIx r) -> ActualPICoh (sh p)) ->
    ActualPICoh (same-node sh)

actualTermSoundness : TermSoundness ActualGrammar
actualTermSoundness = record
  { RouteCoh = ActualRouteCoh
  ; PI = ActualPICoh
  ; localK1 = \ r ds premRoutes ->
      route-node (routeEvidence r) premRoutes
  ; localK2 = \ r sh premPI ->
      pi-node (piEvidence r) premPI
  }

actualGlobalTermSoundness : GlobalTermSoundness ActualGrammar
actualGlobalTermSoundness =
  makeGlobalTermSoundness actualTermSoundness
