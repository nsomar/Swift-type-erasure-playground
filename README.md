# Swift type erasure playground

![Screenshot](/misc/screenshot.png?raw=true)

This playground tries to explain type erasure by going through three erasure types. In the examples a `Box` protocol that contains an `InsideType` is used.

The type erasure examples:

- Creating a wrapper class that can hold a specific `Box` of `Int` (Not really type erasure)
- Creating a wrapper class that can hold any `Box` with `InsideType` of `Int` (Boxes of Ints)
- Creating a wrapper class that can hold any `Box` regardless of it's 
`InsideType` (Boxes of Any)