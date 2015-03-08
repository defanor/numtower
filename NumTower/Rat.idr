import public NumTower.ZZ

%default total

-- A quick implementation, no coprimes; and even worse – a lot of
-- multiplication

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



-- Grouping embeddings

instance (Embedding a Rat, Embedding b Rat, ClosedPlus Rat) => PlusEmbedding a b Rat where { }
instance (Embedding a Rat, Embedding b Rat, ClosedMult Rat) => MultEmbedding a b Rat where { }
instance (Embedding a Rat, Embedding b Rat, ClosedSub Rat) => SubEmbedding a b Rat where { }
instance (Embedding a Rat, Embedding b Rat, ClosedDiv Rat) => DivEmbedding a b Rat where { }

-- Operations

instance ClosedPlus Rat where
  closedPlus = rPlus

instance ClosedSub Rat where
  closedSub = rSub

instance ClosedMult Rat where
  closedMult = rMult

instance ClosedDiv Rat where
  isZ = isRZero
  closedDiv x y {p} = rDiv x y p
  
-- Embeddings

instance Embedding (Fin n) Rat where
  to x = (to x) # 1

instance Embedding Nat Rat where
  to x = (to x) # 1

instance Embedding ZZ Rat where
  to x = x # 1
