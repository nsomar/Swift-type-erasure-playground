//: # Erasing the Box and also the `InsideType` with dynamic cast of parameters

import UIKit

//: In the sample we have a Box that contains a type `InsideType`
//: Three implementations
//: - `IntBox` contains an Int
//: - `AnotherIntBox` contains an Int. Another one
//: - `StringBox` contains an String
//:
//: The boxes contain methods that receive the `InsideType`
protocol Box {
  associatedtype InsideType
  func pack(val: InsideType)
}

struct IntBox: Box {
  func pack(val: Int) {
    print("packed an \(val) in IntBox")
  }
}

struct AnotherIntBox: Box {
  func pack(val: Int) {
    print("packed an \(val) in AnotherIntBox")
  }
}

struct StringBox: Box {
  func pack(val: String) {
    print("packed an \(val) in StringBox")
  }
}

//: ## An array of Boxes that Contain `Any`
//: How can I have an array that contains boxes with any
//: ```
//: var boxesWithAny: [Box] = []
//: ```
//: i.e A wrapper that erases the container and the inside type
//:
//: This is the most invloved erasure as it will fail if the type passed is not type
//:
//: Steps
//: - Create a class that is a `Box`
//: - init takes in the `Box`
//: - `AnyBox` has a closure var for each `Box` function. That takes in `Any`
//: - Inside the closures, dynamic cast params to `Box.InsideType`
//: - If casting fails..do nothing
//: - `AnyBox` delegates calls to these closures
class AnyBox: Box {

  let packFunction: (Any) -> ()

  init<B: Box>(box: B) {
    self.packFunction = { value in
      // We cast the type to the expected type here
      // If dynamic cast fails then we dont call the pack method
      guard let value = value as? B.InsideType else {
        print("FAIL")
        return
      }

      box.pack(val: value)
    }
  }

  func pack(val: Any) {
    packFunction(val)
  }
}

//: Then we can have an array that contains Int boxes
let boxesWithAnything = [
  AnyBox(box: IntBox()),
  AnyBox(box: AnotherIntBox()),
  AnyBox(box: StringBox()),
]

//: and then
boxesWithAnything[0].pack(val: 1)
boxesWithAnything[1].pack(val: 2)
boxesWithAnything[2].pack(val: "Hello")

//: [Next](@next)
