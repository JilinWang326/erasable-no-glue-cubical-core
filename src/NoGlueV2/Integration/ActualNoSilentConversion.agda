{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Integration.ActualNoSilentConversion where

open import NoGlueV2.Prelude
open import NoGlueV2.Index
open import NoGlueV2.Raw.HCom
open import NoGlueV2.Raw.Fill
open import NoGlueV2.Core.PathPHCom
open import NoGlueV2.Core.PathPFill
open import NoGlueV2.Syntax.Rule
open import NoGlueV2.Integration.NoSilentConversion
open import NoGlueV2.Integration.ActualGrammar
open import NoGlueV2.Integration.ActualTermSoundness
open import NoGlueV2.Integration.ActualEqualityGrammar
open import NoGlueV2.Integration.ActualEqualitySoundness

data FiberMoveKind : Set where
  sameFiber : FiberMoveKind
  familyTransport : FiberMoveKind
  sigmaSecondTransport : FiberMoveKind
  pathPCoeMove : FiberMoveKind
  hcomBoundaryMove : FiberMoveKind
  activeFaceBoundary : FiberMoveKind
  fillBoundaryMove : FiberMoveKind
  fillFaceBoundary : FiberMoveKind

record FiberMoveEvidence : Set2 where
  field
    kind : FiberMoveKind
    sourceJudg : ActualJudg
    targetJudg : ActualJudg
    evidence : Set

sameFiberMove : ActualJudg -> FiberMoveEvidence
sameFiberMove j = record
  { kind = sameFiber
  ; sourceJudg = j
  ; targetJudg = j
  ; evidence = One
  }

PathPCoeMoveEvidence : PathPCoeRuleInstance -> Set
PathPCoeMoveEvidence i =
  (d : Dim) ->
  PathPCoeAppTarget (record { coeTerm = i ; d = d })

HComBoundaryEvidence : PathPHComRuleInstance -> Set
HComBoundaryEvidence i =
  (eq :
    DimEq
      (RawPathHComInput.r
        (PathPHComInput.rawInput
          (PathPHComRuleInstance.input i)))
      (RawPathHComInput.r'
        (PathPHComInput.rawInput
          (PathPHComRuleInstance.input i)))) ->
  (d : Dim) ->
  HComIdTarget (record { hcomTerm = i ; equalRadii = eq ; d = d })

FillBoundaryEvidence : PathPFillRuleInstance -> Set
FillBoundaryEvidence i =
  (d : Dim) ->
  FillStartTarget
    (record
      { sig = PathPFillRuleInstance.sig i
      ; input = PathPFillRuleInstance.input i
      ; d = d
      })

termRuleFiberMove : (r : ActualRule) -> FiberMoveEvidence
termRuleFiberMove (rPiLam i) = sameFiberMove (ActualConc (rPiLam i))
termRuleFiberMove (rPiApp i) = sameFiberMove (ActualConc (rPiApp i))
termRuleFiberMove (rProductPair i) = sameFiberMove (ActualConc (rProductPair i))
termRuleFiberMove (rProductFst i) = sameFiberMove (ActualConc (rProductFst i))
termRuleFiberMove (rProductSnd i) = sameFiberMove (ActualConc (rProductSnd i))
termRuleFiberMove (rSigmaPair i) = sameFiberMove (ActualConc (rSigmaPair i))
termRuleFiberMove (rSigmaFst i) = sameFiberMove (ActualConc (rSigmaFst i))
termRuleFiberMove (rSigmaSnd i) = record
  { kind = sigmaSecondTransport
  ; sourceJudg = ActualConc (rSigmaSnd i)
  ; targetJudg = ActualConc (rSigmaSnd i)
  ; evidence = One
  }
termRuleFiberMove (rPathPLam i) = sameFiberMove (ActualConc (rPathPLam i))
termRuleFiberMove (rPathPApp i) = sameFiberMove (ActualConc (rPathPApp i))
termRuleFiberMove (rPathPCoe i) = record
  { kind = pathPCoeMove
  ; sourceJudg = ActualConc (rPathPCoe i)
  ; targetJudg = ActualConc (rPathPCoe i)
  ; evidence = PathPCoeMoveEvidence i
  }
termRuleFiberMove (rPathPHCom i) = record
  { kind = hcomBoundaryMove
  ; sourceJudg = ActualConc (rPathPHCom i)
  ; targetJudg = ActualConc (rPathPHCom i)
  ; evidence = HComBoundaryEvidence i
  }
termRuleFiberMove (rPathPFill i) = record
  { kind = fillBoundaryMove
  ; sourceJudg = ActualConc (rPathPFill i)
  ; targetJudg = ActualConc (rPathPFill i)
  ; evidence = FillBoundaryEvidence i
  }

termRuleFiberProof :
  (r : ActualRule) ->
  FiberMoveEvidence.evidence (termRuleFiberMove r)
termRuleFiberProof (rPiLam i) = only
termRuleFiberProof (rPiApp i) = only
termRuleFiberProof (rProductPair i) = only
termRuleFiberProof (rProductFst i) = only
termRuleFiberProof (rProductSnd i) = only
termRuleFiberProof (rSigmaPair i) = only
termRuleFiberProof (rSigmaFst i) = only
termRuleFiberProof (rSigmaSnd i) = only
termRuleFiberProof (rPathPLam i) = only
termRuleFiberProof (rPathPApp i) = only
termRuleFiberProof (rPathPCoe i) d =
  actualEqEvidence (erPathPCoeApp (record { coeTerm = i ; d = d }))
termRuleFiberProof (rPathPHCom i) eq d =
  actualEqEvidence
    (erHComId (record { hcomTerm = i ; equalRadii = eq ; d = d }))
termRuleFiberProof (rPathPFill i) d =
  actualEqEvidence
    (erFillStart
      (record
        { sig = PathPFillRuleInstance.sig i
        ; input = PathPFillRuleInstance.input i
        ; d = d
        }))

eqRuleFiberMoveKind : ActualEqRule -> FiberMoveKind
eqRuleFiberMoveKind (erPiBeta i) = sameFiber
eqRuleFiberMoveKind (erPiAppCong i) = sameFiber
eqRuleFiberMoveKind (erProductFstBeta i) = sameFiber
eqRuleFiberMoveKind (erProductSndBeta i) = sameFiber
eqRuleFiberMoveKind (erProductFstCong i) = sameFiber
eqRuleFiberMoveKind (erProductSndCong i) = sameFiber
eqRuleFiberMoveKind (erSigmaFstBeta i) = sameFiber
eqRuleFiberMoveKind (erSigmaSndBeta i) = sigmaSecondTransport
eqRuleFiberMoveKind (erIotaReflect i) = sameFiber
eqRuleFiberMoveKind (erPathPAppI0 i) = sameFiber
eqRuleFiberMoveKind (erPathPAppI1 i) = sameFiber
eqRuleFiberMoveKind (erPathPAppCong i) = sameFiber
eqRuleFiberMoveKind (erPathPCoeApp i) = pathPCoeMove
eqRuleFiberMoveKind (erPathPCoeId i) = pathPCoeMove
eqRuleFiberMoveKind (erHComId i) = hcomBoundaryMove
eqRuleFiberMoveKind (erActiveSide i) = activeFaceBoundary
eqRuleFiberMoveKind (erFillStart i) = fillBoundaryMove
eqRuleFiberMoveKind (erFillEnd i) = fillBoundaryMove
eqRuleFiberMoveKind (erFillSide i) = fillFaceBoundary

data ActualFiberSafe
  : {j : ActualJudg} ->
  Deriv ActualGrammar j ->
  Set2 where
  fiber-node :
    {r : ActualRule}
    {ds :
      (p : ActualPremIx r) ->
      Deriv ActualGrammar (ActualPrem r p)} ->
    (move : FiberMoveEvidence) ->
    FiberMoveEvidence.evidence move ->
    ((p : ActualPremIx r) -> ActualFiberSafe (ds p)) ->
    ActualFiberSafe (node r ds)

actualLocalFiberSafety :
  LocalFiberSafety ActualGrammar actualTermSoundness
actualLocalFiberSafety = record
  { FiberSafe = ActualFiberSafe
  ; localSafe = \ r ds premSafe ->
      fiber-node (termRuleFiberMove r) (termRuleFiberProof r) premSafe
  }

actualFiberSafety :
  GlobalFiberSafety ActualGrammar actualTermSoundness
actualFiberSafety =
  makeGlobalFiberSafety actualLocalFiberSafety
