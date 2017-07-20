//: # Erasing the Box with multiple types

import UIKit

//: In the sample we have a Box that contains two types `Type1` and `Type2`
//: Three implementations
//: - `IntBox` contains an Int
//: - `AnotherIntBox` contains an Int. Another one
//: - `StringBox` contains an String
protocol Box {
  associatedtype Type1
  associatedtype Type2
  func unpackFirst() -> Type1
  func unpackSecond() -> Type2
}

struct IntIntBox: Box {
  func unpackFirst() -> Int {
    return 142
  }

  func unpackSecond() -> Int {
    return 242
  }
}

struct IntStringBox: Box {
  func unpackFirst() -> Int {
    return 142
  }

  func unpackSecond() -> String {
    return "242"
  }
}


//: ## An array of Boxes that Contain `Type1` and `Type2` for both types

//: How can I have an array that contains boxes with two specific types
//: ```
//: var boxesWithIntInt: [Box] = []
//: ```
//: i.e A wrapper that erases the container only
//: The above is not possible as `Box` has an associated type and can only be used as a generic constraint
//: We need to create a wrapper that can hold a `Box` with `Int` and `Int`
//:
//: Steps
//: - Create a class that is a `Box` and has two generics
//: - init takes in the `Box` and makes sure that `B.Type1 == Type1, B.Type2 == Type2`
//: - `AnyBox` has a closure var for each `Box` function
//: - `AnyBox` delegates calls to these closures
class AnyBoxErasingBoth<Type1, Type2>: Box {

  let unpackFirstFunction: () -> Type1
  let unpackSecondFunction: () -> Type2

  init<B: Box>(box: B) where B.Type1 == Type1, B.Type2 == Type2 {
    self.unpackFirstFunction = box.unpackFirst
    self.unpackSecondFunction = box.unpackSecond
  }

  func unpackFirst() -> Type1 {
    return self.unpackFirstFunction()
  }

  func unpackSecond() -> Type2 {
    return self.unpackSecondFunction()
  }
}

//: ## An array of Boxes that Contain `Any` for both types
//: How can I have an array that contains boxes with any
//: ```
//: var boxesWithAnyAny: [Box] = []
//: ```
//: i.e A wrapper that erases the container and the inside type
//: The above is not possible as `Box` has an associated type and can only be used as a generic constraint
//: We need to create a wrapper that can hold a `Box` with `Any` and `Any`
//:
//: Steps
//: - Create a class that is a `Box` and has two generics
//: - init takes in the `Box`
//: - `AnyBox` has a closure var for each `Box` function that returns any
//: - `AnyBox` delegates calls to these closures
class AnyBoxErasingBothAny: Box {

  let unpackFirstFunction: () -> Any
  let unpackSecondFunction: () -> Any

  init<B: Box>(box: B) {
    self.unpackFirstFunction = box.unpackFirst
    self.unpackSecondFunction = box.unpackSecond
  }

  func unpackFirst() -> Any {
    return self.unpackFirstFunction()
  }

  func unpackSecond() -> Any {
    return self.unpackSecondFunction()
  }
}

//: We can then erase the box only
let x = [
  AnyBoxErasingBoth(box: IntIntBox()),
  AnyBoxErasingBoth(box: IntIntBox()),
]

//: We can then erase the box and both `Box.Type1` and `Box.Type2`
let y = [
  AnyBoxErasingBothAny(box: IntIntBox()),
  AnyBoxErasingBothAny(box: IntStringBox()),
]

//: [Next](@next)
