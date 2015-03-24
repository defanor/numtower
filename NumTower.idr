module Gen
import Data.Fin
import Data.ZZ

%hide Prelude.Classes.(+)
%hide Prelude.Classes.(*)
%hide Prelude.Classes.(-)
%hide Prelude.Classes.(/)

%default total

-- Fin -> Nat

implicit finNat : Fin n -> Nat
finNat = finToNat

-- Fin, Nat, Integer -> ZZ

implicit finZZ : Fin n -> ZZ
finZZ = Pos . finToNat

implicit natZZ : Nat -> ZZ
natZZ = Pos

implicit integerZZ : Integer -> ZZ
integerZZ = cast

-- Fin, Nat, ZZ -> Integer

implicit zzInteger : ZZ -> Integer
zzInteger = cast

implicit natInteger : Nat -> Integer
natInteger = zzInteger . natZZ

implicit finInteger : Fin n -> Integer
finInteger = zzInteger . finZZ


-- operations

namespace NatOp
  (+) : Nat -> Nat -> Nat
  (+) = plus
  
  (*) : Nat -> Nat -> Nat
  (*) = mult

namespace ZZOp
  (+) : ZZ -> ZZ -> ZZ
  (+) = plusZ
  
  (*) : ZZ -> ZZ -> ZZ
  (*) = multZ
  
  (-) : ZZ -> ZZ -> ZZ
  (-) = subZ

namespace IntegerOp
  (+) : Integer -> Integer -> Integer
  (+) = prim__addBigInt
  
  (*) : Integer -> Integer -> Integer
  (*) = prim__mulBigInt
  
  (-) : Integer -> Integer -> Integer
  (-) = prim__subBigInt



-- Rationals

data Rat : Type where
  (#) : ZZ -> (y:Nat) -> {default Refl nz: isZero y = False} -> Rat

infixl 9 #

nonZeroMult : (x,y: Nat) -> isZero x = False -> isZero y = False -> isZero (mult x y) = False
nonZeroMult Z y p1 p2 = void $ trueNotFalse p1
nonZeroMult (S k) Z p1 p2 = void $ trueNotFalse p2
nonZeroMult (S k) (S j) p1 p2 = Refl

isRZero : Rat -> Bool
isRZero ((#) (Pos Z) y) = True
isRZero _ = False

rPlus : Rat -> Rat -> Rat
rPlus ((#) x y {nz=p1}) ((#) x' y' {nz=p2}) =
  (#) (x * y' + x' * y) (y * y') {nz=nonZeroMult y y' p1 p2}

rSub : Rat -> Rat -> Rat
rSub ((#) x y {nz=p1}) ((#) x' y' {nz=p2}) =
  (#) (x * y' - x' * y) (y * y') {nz=nonZeroMult y y' p1 p2}

rMult : Rat -> Rat -> Rat
rMult ((#) k j {nz=p1}) ((#) i y {nz=p2}) =
  (#) (k * i) (j * y) {nz=nonZeroMult j y p1 p2}

rDiv : Rat -> (y: Rat) -> isRZero y = False -> Rat
rDiv ((#) k j {nz=p1}) ((#) (Pos Z) y {nz=p2}) rnz = void $ trueNotFalse rnz
rDiv ((#) k j {nz=p1}) ((#) (Pos (S i)) y {nz=p2}) rnz =
  (#) (k * y) (j * (S i)) {nz=nonZeroMult j (S i) p1 Refl}
rDiv ((#) (Pos Z) j {nz=p1}) ((#) (NegS i) y {nz=p2}) rnz = 0#1
rDiv ((#) (Pos (S k)) j {nz=p1}) ((#) (NegS i) y {nz=p2}) rnz =
  (#) ((NegS k) * y) (j * (S i)) {nz=nonZeroMult j (S i) p1 Refl}
rDiv ((#) (NegS k) j {nz=p1}) ((#) (NegS i) y {nz=p2}) rnz =
  (#) ((S k) * y) (j * (S i)) {nz=nonZeroMult j (S i) p1 Refl}


-- Fin, Nat, ZZ, Integer -> Rat

implicit zzRat : ZZ -> Rat
zzRat = (# 1)

implicit integerRat : Integer -> Rat
integerRat = zzRat . integerZZ

implicit natRat : Nat -> Rat
natRat = zzRat . natZZ

implicit finRat : Fin n -> Rat
finRat = zzRat . finZZ

namespace RatOp
  (+) : Rat -> Rat -> Rat
  (+) = rPlus
  
  (*) : Rat -> Rat -> Rat
  (*) = rMult
  
  (-) : Rat -> Rat -> Rat
  (-) = rSub
  
  (/) : Rat -> (y: Rat) -> {default Refl nz: isRZero y = False} -> Rat
  (/) x y {nz} = rDiv x y nz

