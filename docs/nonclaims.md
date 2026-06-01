# Nonclaims

The formalization is intentionally scoped to the erasable no-Glue cubical core
spine as a deep embedding. It does not claim to formalize full cubical type
theory or a complete metatheory for normalization or canonicity.

The object language does not include Glue, universes, identity types,
univalence, eta principles, conversion, equality reflection, normalization, or
canonicity rules. In particular, there is no object-language Glue type, no
univalence rule, no Glue or univalence computation principle, no exact-typing
conversion rule, and no implicit conversion between dependent fibers.

The reflection boundary is signature-relative. Reflected rules are accounted
for only through the explicit boundary interface, not by adding equality
reflection or silent conversion to the object language.

Agda definitional equality is used by the host typechecker to verify the deep
embedding. It is not represented as an object-language conversion rule and is
not used to identify distinct dependent fibers inside the embedded theory.
