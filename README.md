# SwiftSpy

SwiftSpy is a macro for generating test spies in Swift.

## Example

You can find some examples in the `Tests/` directory, but here's a quick summary of how to use this Swift macro.

Imagine you've declared some repository interface that simply stores and retrieves integer values:

```swift
protocol RepositoryInterface {
    func store(value: Int)
    func retrieve() -> Int
}
```

In your tests, you may want to mock out this component and keep track of how it's used.
Declare your mock implementation and annotate it with the `@Spy` macro annotation:

```swift
@Spy
class MockRepository: RepositoryInterface {
    func store(value: Int) {
        // TODO
    }

    func retrieve() -> Int {
        // TODO
    }
}
```

Typically, you would either leave these methods empty or keep some state manually on how these methods are used.
The `@Spy` macro will do this for you. It will generate spying methods on your behalf. All you need to do is call them.
The generated methods always start with an underscore (`_`).

```swift
@Spy
class MockRepository: RepositoryInterface {
    func store(value: Int) {
       _returnAndRecord_store(value) // calling generated function
    }

    func retrieve() -> Int {
        _returnAndRecord_retrieve() // calling generated function
    }
}
```

Inspecting recordings is easy:

```swift
let mock = MockRepository()
mock.store(1)
mock.store(2)
XCTAssertEqual(2, mock._timesCalled_store)
XCTAssertEqual([1, 2], mock_values_store)
```
