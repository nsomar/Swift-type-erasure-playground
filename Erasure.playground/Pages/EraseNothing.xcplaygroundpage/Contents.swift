//: #  Type Erasure playground

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

let intBox1 = IntBox()
let intBox2 = IntBox()
let intBox3 = IntBox()

//: ## Create a wrapper that just holds a box
//: This is basically erasing nothing
var intBoxes: [IntBox] = []
intBoxes = [intBox1, intBox2, intBox3]

class AnyBox<B: Box>: Box {

  let box: B

  init(box: B) {
    self.box = box
  }

  func unpack() -> B.InsideType {
    return box.unpack()
  }
}

let boxes = [
  AnyBox(box: IntBox()),
  AnyBox(box: IntBox())
] 

//: [Erasing the Box but keeping the internal type](@next)
