import public NumTower.Nat
import public Data.ZZ

%default total

-- Grouping embeddings

instance (Embedding a ZZ, Embedding b ZZ, ClosedPlus ZZ) => PlusEmbedding a b ZZ where { }
instance (Embedding a ZZ, Embedding b ZZ, ClosedMult ZZ) => MultEmbedding a b ZZ where { }
instance (Embedding a ZZ, Embedding b ZZ, ClosedSub ZZ) => SubEmbedding a b ZZ where { }

-- Operations

instance ClosedPlus ZZ where
  closedPlus = plusZ

instance ClosedMult ZZ where
  closedMult = multZ

instance ClosedSub ZZ where
  closedSub = subZ

-- Embeddings

instance Embedding Nat ZZ where
  to = cast

instance Embedding (Fin n) ZZ where
  to = to . to {b=Nat}
