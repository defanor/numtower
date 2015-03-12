import public NumTower.Common
import public NumTower.Nat
import public Data.Fin
import public Data.ZZ


%default total

-- Grouping embeddings

instance (Embedding a Integer, Embedding b Integer, ClosedPlus Integer) => PlusEmbedding a b Integer where { }
instance (Embedding a Integer, Embedding b Integer, ClosedSub Integer) => SubEmbedding a b Integer where { }
instance (Embedding a Integer, Embedding b Integer, ClosedMult Integer) => MultEmbedding a b Integer where { }
instance (Embedding a Integer, Embedding b Integer) => OrdEmbedding a b Integer where { }
-- instance (Embedding a Integer, Embedding b Integer) => EqEmbedding a b Integer where { }

-- Operations

instance ClosedPlus Integer where
  closedPlus = prim__addBigInt

instance ClosedMult Integer where
  closedMult = prim__mulBigInt

instance ClosedSub Integer where
  closedSub = prim__subBigInt

-- Embeddings

instance Embedding (Fin n) Integer where
  to = cast

instance Embedding Nat Integer where
  to = cast

instance Embedding ZZ Integer where
  to = cast
