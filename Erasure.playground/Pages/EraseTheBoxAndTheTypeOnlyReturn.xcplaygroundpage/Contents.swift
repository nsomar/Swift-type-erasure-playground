//: # Erasing the Box and also the `InsideType`

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

//: ## An array of Boxes that Contain `Any`
//: How can I have an array that contains boxes with any
//: ```
//: var boxesWithAny: [Box] = []
//: ```
//: i.e A wrapper that erases the container and the inside type
//:
//: Steps
//: - Create a class that is a `Box`
//: - init takes in the `Box`
//: - `AnyBox` has a closure var for each `Box` function. Closures return Any
//: - `AnyBox` delegates calls to these closures
class AnyBox: Box {

  let unpackFunction: () -> Any

  init<B: Box>(box: B) {
    self.unpackFunction = box.unpack
  }

  func unpack() -> Any {
    return unpackFunction()
  }
}

//: Then we can have an array that contains Int boxes
let boxesWithAnything = [
  AnyBox(box: IntBox()),
  AnyBox(box: AnotherIntBox()),
  AnyBox(box: StringBox()),
]

//: and then
boxesWithAnything[0].unpack()
boxesWithAnything[1].unpack()
boxesWithAnything[2].unpack()

//: [Next](@next)
