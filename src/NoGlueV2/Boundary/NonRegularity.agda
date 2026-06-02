{-# OPTIONS --cubical=no-glue --safe #-}
module NoGlueV2.Boundary.NonRegularity where

open import NoGlueV2.Prelude

data End : Set where
  e0 e1 : End

data EndEq : End -> End -> Set where
  endRefl : {e : End} -> EndEq e e

data EndNe : End -> End -> Set where
  ne01 : EndNe e0 e1
  ne10 : EndNe e1 e0

data Bit : Set where
  b0 b1 : Bit

data BitEq : Bit -> Bit -> Set where
  bitRefl0 : BitEq b0 b0
  bitRefl1 : BitEq b1 b1

bitEqRefl : {b : Bit} -> BitEq b b
bitEqRefl {b0} = bitRefl0
bitEqRefl {b1} = bitRefl1

bitEqSym : {b c : Bit} -> BitEq b c -> BitEq c b
bitEqSym bitRefl0 = bitRefl0
bitEqSym bitRefl1 = bitRefl1

bitEqTrans :
  {b c d : Bit} ->
  BitEq b c ->
  BitEq c d ->
  BitEq b d
bitEqTrans bitRefl0 bitRefl0 = bitRefl0
bitEqTrans bitRefl1 bitRefl1 = bitRefl1

data BitInspect (b : Bit) : Set where
  revealBit : (c : Bit) -> BitEq b c -> BitInspect b

inspectBit : (b : Bit) -> BitInspect b
inspectBit b0 = revealBit b0 bitRefl0
inspectBit b1 = revealBit b1 bitRefl1

andBit : Bit -> Bit -> Bit
andBit b0 _ = b0
andBit b1 b = b

orBit : Bit -> Bit -> Bit
orBit b0 b = b
orBit b1 _ = b1

data DimName : Set where
  dimI : DimName

Val : Set
Val = DimName -> Bit

data BFace : Set where
  fTop : BFace
  fBot : BFace
  eq0 : DimName -> BFace
  eq1 : DimName -> BFace
  fAnd : BFace -> BFace -> BFace
  fOr : BFace -> BFace -> BFace

evalFace : Val -> BFace -> Bit
evalFace ρ fTop = b1
evalFace ρ fBot = b0
evalFace ρ (eq0 x) with ρ x
... | b0 = b1
... | b1 = b0
evalFace ρ (eq1 x) with ρ x
... | b0 = b0
... | b1 = b1
evalFace ρ (fAnd φ ψ) = andBit (evalFace ρ φ) (evalFace ρ ψ)
evalFace ρ (fOr φ ψ) = orBit (evalFace ρ φ) (evalFace ρ ψ)

Entails : BFace -> BFace -> Set
Entails φ ψ =
  (ρ : Val) ->
  BitEq (evalFace ρ φ) b1 ->
  BitEq (evalFace ρ ψ) b1

andBitSat :
  {b c : Bit} ->
  BitEq b b1 ->
  BitEq c b1 ->
  BitEq (andBit b c) b1
andBitSat bitRefl1 bitRefl1 = bitRefl1

andFaceSat :
  {ρ : Val} {φ ψ : BFace} ->
  BitEq (evalFace ρ φ) b1 ->
  BitEq (evalFace ρ ψ) b1 ->
  BitEq (evalFace ρ (fAnd φ ψ)) b1
andFaceSat p q = andBitSat p q

andFaceSatBit :
  {ρ : Val} {φ ψ : BFace} ->
  BitEq (evalFace ρ ψ) b1 ->
  BitEq (evalFace ρ φ) b1 ->
  BitEq (evalFace ρ (fAnd φ ψ)) b1
andFaceSatBit {ρ = ρ} {φ = φ} {ψ = ψ} ψsat sat =
  andFaceSat {ρ = ρ} {φ = φ} {ψ = ψ} sat ψsat

data BoundaryTerm : Set where
  boundaryA : BoundaryTerm
  hcomB :
    End ->
    End ->
    BFace ->
    BoundaryTerm ->
    BoundaryTerm ->
    BoundaryTerm

boundaryH : BoundaryTerm
boundaryH = hcomB e0 e1 (eq0 dimI) boundaryA boundaryA

data BoundaryEqAt : BFace -> BoundaryTerm -> BoundaryTerm -> Set where
  brefl :
    {φ : BFace} {u : BoundaryTerm} ->
    BoundaryEqAt φ u u

  bsym :
    {φ : BFace} {u v : BoundaryTerm} ->
    BoundaryEqAt φ u v ->
    BoundaryEqAt φ v u

  btrans :
    {φ : BFace} {u v w : BoundaryTerm} ->
    BoundaryEqAt φ u v ->
    BoundaryEqAt φ v w ->
    BoundaryEqAt φ u w

  bface-mono :
    {φ φ' : BFace} {u v : BoundaryTerm} ->
    Entails φ' φ ->
    BoundaryEqAt φ u v ->
    BoundaryEqAt φ' u v

  bhcom-end :
    {φ ψ : BFace} {d : End} {u v : BoundaryTerm} ->
    BoundaryEqAt φ (hcomB d d ψ u v) v

  bhcom-face :
    {φ ψ : BFace} {d d' : End} {u v : BoundaryTerm} ->
    EndNe d d' ->
    Entails φ ψ ->
    BoundaryEqAt φ (hcomB d d' ψ u v) u

  bhcom-cong :
    {φ ψ : BFace} {d d' : End} ->
    {u u' v v' : BoundaryTerm} ->
    BoundaryEqAt (fAnd φ ψ) u u' ->
    BoundaryEqAt φ v v' ->
    BoundaryEqAt φ
      (hcomB d d' ψ u v)
      (hcomB d d' ψ u' v')

BoundaryEq : BoundaryTerm -> BoundaryTerm -> Set
BoundaryEq u v = BoundaryEqAt fTop u v

data Value : Set where
  atomA : Value
  neHCom : End -> End -> BFace -> Value -> Value

data ValueEq : Value -> Value -> Set where
  veAtom : ValueEq atomA atomA
  veNe :
    {d d' : End} {ψ : BFace} {v v' : Value} ->
    ValueEq v v' ->
    ValueEq (neHCom d d' ψ v) (neHCom d d' ψ v')

valueEqRefl : {v : Value} -> ValueEq v v
valueEqRefl {atomA} = veAtom
valueEqRefl {neHCom d d' ψ v} = veNe valueEqRefl

valueEqSym : {v v' : Value} -> ValueEq v v' -> ValueEq v' v
valueEqSym veAtom = veAtom
valueEqSym (veNe e) = veNe (valueEqSym e)

valueEqTrans :
  {v v' v'' : Value} ->
  ValueEq v v' ->
  ValueEq v' v'' ->
  ValueEq v v''
valueEqTrans veAtom veAtom = veAtom
valueEqTrans (veNe e) (veNe f) = veNe (valueEqTrans e f)

noNeHComToAtom :
  {d d' : End} {ψ : BFace} {v : Value} ->
  ValueEq (neHCom d d' ψ v) atomA ->
  ⊥
noNeHComToAtom ()

mutual
  interp : Val -> BoundaryTerm -> Value
  interp ρ boundaryA = atomA
  interp ρ (hcomB d d' ψ u v) = interpHCom ρ d d' ψ u v

  interpHCom :
    Val ->
    End ->
    End ->
    BFace ->
    BoundaryTerm ->
    BoundaryTerm ->
    Value
  interpHCom ρ e0 e0 ψ u v = interp ρ v
  interpHCom ρ e1 e1 ψ u v = interp ρ v
  interpHCom ρ e0 e1 ψ u v with evalFace ρ ψ
  ... | b1 = interp ρ u
  ... | b0 = neHCom e0 e1 ψ (interp ρ v)
  interpHCom ρ e1 e0 ψ u v with evalFace ρ ψ
  ... | b1 = interp ρ u
  ... | b0 = neHCom e1 e0 ψ (interp ρ v)

ValidAt : BFace -> BoundaryTerm -> BoundaryTerm -> Set
ValidAt φ u v =
  (ρ : Val) ->
  BitEq (evalFace ρ φ) b1 ->
  ValueEq (interp ρ u) (interp ρ v)

hcomActiveDiff :
  {ρ : Val} {d d' : End} {ψ : BFace} {u v : BoundaryTerm} ->
  EndNe d d' ->
  BitEq (evalFace ρ ψ) b1 ->
  ValueEq (interpHCom ρ d d' ψ u v) (interp ρ u)
hcomActiveDiff {ρ = ρ} {ψ = ψ} ne01 ψsat
  with evalFace ρ ψ | ψsat
... | b1 | bitRefl1 = valueEqRefl
... | b0 | ()
hcomActiveDiff {ρ = ρ} {ψ = ψ} ne10 ψsat
  with evalFace ρ ψ | ψsat
... | b1 | bitRefl1 = valueEqRefl
... | b0 | ()

hcomInactiveDiff :
  {ρ : Val} {d d' : End} {ψ : BFace} {u v : BoundaryTerm} ->
  EndNe d d' ->
  BitEq (evalFace ρ ψ) b0 ->
  ValueEq
    (interpHCom ρ d d' ψ u v)
    (neHCom d d' ψ (interp ρ v))
hcomInactiveDiff {ρ = ρ} {ψ = ψ} ne01 ψsat
  with evalFace ρ ψ | ψsat
... | b0 | bitRefl0 = valueEqRefl
... | b1 | ()
hcomInactiveDiff {ρ = ρ} {ψ = ψ} ne10 ψsat
  with evalFace ρ ψ | ψsat
... | b0 | bitRefl0 = valueEqRefl
... | b1 | ()

boundarySound :
  {φ : BFace} {u v : BoundaryTerm} ->
  BoundaryEqAt φ u v ->
  ValidAt φ u v
boundarySound brefl ρ sat = valueEqRefl
boundarySound (bsym e) ρ sat =
  valueEqSym (boundarySound e ρ sat)
boundarySound (btrans e f) ρ sat =
  valueEqTrans (boundarySound e ρ sat) (boundarySound f ρ sat)
boundarySound (bface-mono ent e) ρ sat =
  boundarySound e ρ (ent ρ sat)
boundarySound (bhcom-end {d = e0}) ρ sat = valueEqRefl
boundarySound (bhcom-end {d = e1}) ρ sat = valueEqRefl
boundarySound (bhcom-face {ψ = ψ} {d = e0} {d' = e1} ne01 ent) ρ sat
  with evalFace ρ ψ | ent ρ sat
... | b1 | bitRefl1 = valueEqRefl
... | b0 | ()
boundarySound (bhcom-face {ψ = ψ} {d = e1} {d' = e0} ne10 ent) ρ sat
  with evalFace ρ ψ | ent ρ sat
... | b1 | bitRefl1 = valueEqRefl
... | b0 | ()
boundarySound
  (bhcom-cong {d = e0} {d' = e0} tube cap)
  ρ sat =
  boundarySound cap ρ sat
boundarySound
  (bhcom-cong {d = e1} {d' = e1} tube cap)
  ρ sat =
  boundarySound cap ρ sat
boundarySound
  (bhcom-cong
    {φ = φ} {ψ = ψ} {d = e0} {d' = e1}
    {u = u} {u' = u'} {v = v} {v' = v'}
    tube cap)
  ρ sat
  with inspectBit (evalFace ρ ψ)
... | revealBit b1 ψsat =
  valueEqTrans
    (hcomActiveDiff
      {ρ = ρ} {d = e0} {d' = e1} {ψ = ψ} {u = u} {v = v}
      ne01 ψsat)
    (valueEqTrans
      (boundarySound tube ρ
        (andFaceSatBit {ρ = ρ} {φ = φ} {ψ = ψ} ψsat sat))
      (valueEqSym
        (hcomActiveDiff
          {ρ = ρ} {d = e0} {d' = e1} {ψ = ψ} {u = u'} {v = v'}
          ne01 ψsat)))
... | revealBit b0 ψsat =
  valueEqTrans
    (hcomInactiveDiff
      {ρ = ρ} {d = e0} {d' = e1} {ψ = ψ} {u = u} {v = v}
      ne01 ψsat)
    (valueEqTrans
      (veNe {d = e0} {d' = e1} {ψ = ψ} (boundarySound cap ρ sat))
      (valueEqSym
        (hcomInactiveDiff
          {ρ = ρ} {d = e0} {d' = e1} {ψ = ψ} {u = u'} {v = v'}
          ne01 ψsat)))
boundarySound
  (bhcom-cong
    {φ = φ} {ψ = ψ} {d = e1} {d' = e0}
    {u = u} {u' = u'} {v = v} {v' = v'}
    tube cap)
  ρ sat
  with inspectBit (evalFace ρ ψ)
... | revealBit b1 ψsat =
  valueEqTrans
    (hcomActiveDiff
      {ρ = ρ} {d = e1} {d' = e0} {ψ = ψ} {u = u} {v = v}
      ne10 ψsat)
    (valueEqTrans
      (boundarySound tube ρ
        (andFaceSatBit {ρ = ρ} {φ = φ} {ψ = ψ} ψsat sat))
      (valueEqSym
        (hcomActiveDiff
          {ρ = ρ} {d = e1} {d' = e0} {ψ = ψ} {u = u'} {v = v'}
          ne10 ψsat)))
... | revealBit b0 ψsat =
  valueEqTrans
    (hcomInactiveDiff
      {ρ = ρ} {d = e1} {d' = e0} {ψ = ψ} {u = u} {v = v}
      ne10 ψsat)
    (valueEqTrans
      (veNe {d = e1} {d' = e0} {ψ = ψ} (boundarySound cap ρ sat))
      (valueEqSym
        (hcomInactiveDiff
          {ρ = ρ} {d = e1} {d' = e0} {ψ = ψ} {u = u'} {v = v'}
          ne10 ψsat)))

valI1 : Val
valI1 dimI = b1

notEq0AtI1 :
  BitEq (evalFace valI1 (eq0 dimI)) b1 ->
  ⊥
notEq0AtI1 ()

boundaryNonRegular :
  BoundaryEq boundaryH boundaryA ->
  ⊥
boundaryNonRegular e =
  noNeHComToAtom (boundarySound e valI1 bitRefl1)
