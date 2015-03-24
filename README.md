# Numerical tower

Numerical tower (well, not exactly a tower, but numerical!) in
Idris. No more `fromIntegral x / fromIntegral y`!

Simply using implicit conversions, and defining operations only on
types which are closed under those operations.

Currently implemented: Fin n → ℕ → ℤ (ZZ ↔ Integer) → ℚ (the latter is
implemented quickly and poorly here, no coprimes in it); the
implemented operations are +, -, /, *.

# Examples

```idris
foo : Fin n -> Nat -> ZZ -> Rat -> Rat
foo f n z q@((#) (Pos Z) _ {nz}) = f + n - z - q + (f * n * z)
foo f n z q@((#) (Pos (S _)) _ {nz}) = f + n - z - q + (f * n * z) / q
foo f n z q@((#) (NegS _) _ {nz}) = f - n - z - q + (f * n * z) / q

λΠ> foo (the (Fin 3) 1) (S Z) (Pos (S Z)) (1#2)
Pos 5 # 2 : Rat

λΠ> (the (Fin 5) 3) - (the Nat 5) / (the Nat 3) + (the Nat 1) * (the ZZ (-3))
NegS 4 # 3 : Rat
```

# ToDo

Add more types and operations (comparison, in particular).
