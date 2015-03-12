%hide Prelude.Classes.(+)
%hide Prelude.Classes.(-)
%hide Prelude.Classes.(*)
%hide Prelude.Classes.(/)

%default total

class Embedding a b where
  to : a -> b

instance Embedding a a where
  to = id


-- It would typecheck much faster, and would require a bit less
-- copypaste, if (Embedding a c, Embedding b c, ClosedPlus c) would be
-- replaced with (Embedding a c, Embedding b c), but it also would be
-- more tricky to use in such a case


-- (+)

class ClosedPlus a where
  closedPlus : a -> a -> a

class (Embedding a c, Embedding b c, ClosedPlus c) => PlusEmbedding a b c where { }

(+) : (PlusEmbedding a b c) => a -> b -> c
(+) x y = closedPlus (to x) (to y)


-- (-)

class ClosedSub a where
  closedSub : a -> a -> a

class (Embedding a c, Embedding b c, ClosedSub c) => SubEmbedding a b c where { }

(-) : (SubEmbedding a b c) => a -> b -> c
(-) x y = closedSub (to x) (to y)


-- (*)

class ClosedMult a where
  closedMult : a -> a -> a

class (Embedding a c, Embedding b c, ClosedMult c) => MultEmbedding a b c where { }

(*) : (MultEmbedding a b c) => a -> b -> c
(*) x y = closedMult (to x) (to y)


-- (/)

class ClosedDiv a where
  isZ : a -> Bool
  closedDiv : a -> (y:a) -> (p: isZ y = False) -> a

class (Embedding a c, Embedding b c, ClosedDiv c) => DivEmbedding a b c where { }

(/) : (DivEmbedding a b c) =>
    a -> (y:b) -> {default Refl p: isZ (to y) = False} -> c
(/) x y {p} = closedDiv (to x) (to y) p


-- Ord

class (Embedding a c, Embedding b c, Ord c) => OrdEmbedding a b c where { }

(<) : (OrdEmbedding a b c) => a -> b -> Bool
(<) x y = Prelude.Classes.(<) (to x) (to y)

(<=) : (OrdEmbedding a b c) => a -> b -> Bool
(<=) x y = Prelude.Classes.(<=) (to x) (to y)

(>) : (OrdEmbedding a b c) => a -> b -> Bool
(>) x y = Prelude.Classes.(>) (to x) (to y)

(>=) : (OrdEmbedding a b c) => a -> b -> Bool
(>=) x y = Prelude.Classes.(>=) (to x) (to y)


-- Eq

class (Embedding a c, Embedding b c, Eq c) => EqEmbedding a b c where { }

(==) : (EqEmbedding a b c) => a -> b -> Bool
(==) x y = Prelude.Classes.(==) (to x) (to y)
