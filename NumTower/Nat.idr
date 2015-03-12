import public NumTower.Fin
import public NumTower.Common
import public Data.Fin

%default total

-- Grouping embeddings (helping Idris to resolve instances)

instance (Embedding a Nat, Embedding b Nat, ClosedPlus Nat) => PlusEmbedding a b Nat where { }
instance (Embedding a Nat, Embedding b Nat, ClosedMult Nat) => MultEmbedding a b Nat where { }
instance (Embedding a Nat, Embedding b Nat) => OrdEmbedding a b Nat where { }
-- instance (Embedding a Nat, Embedding b Nat) => EqEmbedding a b Nat where { }

-- Operations

instance ClosedPlus Nat where
  closedPlus = plus

instance ClosedMult Nat where
  closedMult = mult


-- Embeddings

instance Embedding (Fin n) Nat where
  to = cast

