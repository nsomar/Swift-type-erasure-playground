//: # Bonus: Any Equatable
//: Taken from [here](https://gist.github.com/pyrtsa/f5dbf7fff53e834936470762960357a4)

// Quick hack to avoid changing the AnyEquatable implementation below.
extension Equatable { typealias EqualSelf = Self }

/// Existential wrapper around Equatable.
struct AnyEquatable : Equatable {
  let value: Any
  let isEqual: (AnyEquatable) -> Bool
  init<T : Equatable>(_ value: T) {
    self.value = value
    self.isEqual = {r in
      guard let other = r.value as? T.EqualSelf else { return false }
      return value == other
    }
  }
}

func == (l: AnyEquatable, r: AnyEquatable) -> Bool {
  return l.isEqual(r)
}

/// An Array-like class (that defines equality in terms of its `count`).
class Base : Equatable {
  let count: Int
  init(count: Int) { self.count = count }
  func isEqual(_ rhs: Base) -> Bool { return count == rhs.count }
}

func == (l: Base, r: Base) -> Bool { return l.isEqual(r) }

class Child1 : Base {}
class Child2 : Base {}

/// The test creates three equivalent instances and a single different one:
let a = AnyEquatable(Base(count: 3))
let b = AnyEquatable(Child1(count: 3))
let c = AnyEquatable(Child2(count: 3))
let d = AnyEquatable(Child2(count: 4))

/// Stdlib version (`#if false`) breaks commutativity:
///
///     true true true false
///     false true false false
///     false false true false
///     false false false true
///
/// Modified version of Equatable (`#if true`) prints:
///
///     true true true false
///     true true true false
///     true true true false
///     false false false true
print("Test:")
print(a == a, a == b, a == c, a == d)
print(b == a, b == b, b == c, b == d)
print(c == a, c == b, c == c, c == d)
print(d == a, d == b, d == c, d == d)
print()

/// A workaround is to upcast at the point of existential wrapping:
print("Workaround:")
let x = AnyEquatable(Child1(count: 3) as Base)
let y = AnyEquatable(Child2(count: 3) as Base)
print(a == a, a == x, a == y, a == d)
print(x == a, x == x, x == y, x == d)
print(y == a, y == x, y == y, y == d)
print(d == a, d == x, d == y, d == d)
print()

