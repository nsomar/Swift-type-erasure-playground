//: # Erasing the Box but keeping the internal type

import UIKit

//: In the sample we have a Box that contains a type `InsideType`
//: Three implementations
//: - `IntBox` contains an Int
//: - `AnotherIntBox` contains an Int. Another one
//: - `StringBox` contains an String
protocol Box {
  associatedtype InsideType
  func unpack() -> InsideType
}

struct IntBox: Box {
  func unpack() -> Int {
    return 42
  }
}

struct AnotherIntBox: Box {
  func unpack() -> Int {
    return 21
  }
}

struct StringBox: Box {
  func unpack() -> String {
    return "Hello"
  }
}

//: ## An array of Boxes that Contain Integers
//: How can I have an array that contains boxes with ints
//: ```
//: var boxesWithInts: [Box] = []
//: ```
//: i.e A wrapper that erases the container only
//:
//: Steps
//: - Create a class that has a generic type and is a `Box`
//: - init takes in the `Box` and make sure that `B.InsideType == Type`
//: - `AnyBox` has a closure var for each `Box` function
//: - `AnyBox` delegates calls to these closures
class AnyBox<Type>: Box {

  let unpackFunction: () -> Type

  init<B: Box>(box: B) where B.InsideType == Type {
    self.unpackFunction = box.unpack
  }

  func unpack() -> Type {
    return unpackFunction()
  }
}

//: Then we can have an array that contains Int boxes
let boxesWithInts = [
  AnyBox(box: IntBox()),
  AnyBox(box: IntBox()),
  AnyBox(box: AnotherIntBox()),
]

//: and then use it like so
boxesWithInts[0].unpack()
boxesWithInts[1].unpack()
boxesWithInts[2].unpack()

//: [Next](@next)
