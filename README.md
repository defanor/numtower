# Numerical tower

Numerical tower (well, not exactly a tower, but numerical!) in
Idris. No more `fromIntegral x / fromIntegral y`!

Lifting operands to a type which is closed under a requested
operation, if paths (injective functions) to such a type exist.

Currently implemented: Fin n → ℕ → ℤ (ZZ ↔ Integer) → ℚ (the latter is
implemented quickly and poorly here, no coprimes in it); the
implemented operations are +, -, /, *, <, >, <=, >=, ==. Instances of
the latter are commented, because it takes forever to typecheck with
them; some optimization is required to move further.

It's also pretty slow to typecheck relatively big expressions now:
`foo` from the example below takes ~30 seconds to typecheck; details
of that are in `Common.idr` comments and
[there](https://github.com/idris-lang/Idris-dev/issues/1986).


# Examples

```idris
foo : Fin n -> Nat -> ZZ -> Rat -> Rat
foo f n z q@((#) (Pos Z) _ {nz}) = f + n - z - q + (f * n * z)
foo f n z q@((#) (Pos (S _)) _ {nz}) = f + n - z - q + (f * n * z) / q
foo f n z q@((#) (NegS _) _ {nz}) = f - n - z - q + (f * n * z) / q

λΠ> foo (the (Fin 3) 1) (S Z) (Pos (S Z)) (1#2)
Pos 5 # 2 : Rat

bar : Fin 10 -> Nat -> ZZ -> Bool
bar x y z = (x * z) > y

λΠ> bar 2 8 4
False : Bool

λΠ> (the (Fin 5) 3) + (the Nat 5)
8 : Nat

λΠ> (the (Fin 5) 3) - (the Nat 5)
-2 : Integer

λΠ> (the (Fin 5) 3) * (the Nat 5)
15 : Nat

λΠ> (the (Fin 5) 3) / (the Nat 5)
Pos 3 # 5 : Rat

λΠ> 10 < (the (Fin 5) 3) + (the Nat 5) * (the ZZ 2)
True : Bool

λΠ> the ZZ $ (the (Fin 5) 3) + (the Nat 5) * (the ZZ 2)
Pos 13 : ZZ

λΠ> 1 + 3 * 5 / 2 - 2
Pos 13 # 2 : Rat
```


# ToDo

Need to optimize it somehow; maybe even copypaste/generate the code
for all the operations and pairs of operands, if it'd help (it should,
but it's not nice at all, especially for extending it with custom
types and operations).

Also a better `Rat` should be implemented. `Float` could be used
instead of `Real`, and then `Complex` using `Float`, and functions
like `sqrt`. `Bits` and `Int` should be added, too.

Would be nice to make Common.idr type class definitions incremental
(plus => mult => minus => div), to make it easier to write generic
functions on numbers, and to add constraints with Algebra.idr classes,
but the current typeclass resolution makes it complicated, and
Algebra.idr provides neither semirings for natural numbers, nor fields
suitable for rational numbers.
