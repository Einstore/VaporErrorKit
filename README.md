# VaporErrorKit



### Install using SPM

```swift
.package(url: "https://github.com/Einstore/VaporErrorKit.git", from: "0.0.1")
```

### Concept

Allow framework agnostic server side libraries to have a common error type while allowing easy error handling within the final app.

WebError libraries consist of three products:

- VaporErrorKit - This library
- [NIOErrorKit](https://github.com/Einstore/NIOErrorKit) - `WebErrorKit` extended for use with `NIO`
- [WebErrorKit](https://github.com/Einstore/WebErrorKit) - Base types, protocols and tools; to be used in libraries

### Basic use

Conform your error to `WebError` from `WebErrorKit` package

> If your error is a `String` `RawRepresentable` (String enum) you get `code` property for free (see response output below) 

```swift
enum MyError: String, WebError {

    case somethingHasHappened
    
}
```

above error will generate following error response:

```json
// Status 500
{
    "code": "my_error.something_has_happened"
}
```

### Custom use

```swift
enum MyError: String, WebError {
    
    case somethingHasHappened
    
    var statusCode: Int {
        return 417
    }
    
    var reason: String? {
        return "Something has happened!!!"
    }
    
}
```

above error will generate following error response:

```json
// Status 417
{
    "code": "my_error.something_has_happened",
    "reason": "Something has happened!!!"
}
```

### Custom enum types

For errors that don't conform to `String` and `RawRepresentable` you can use `SerializableWebError` as follows:

```swift
enum MyError: SerializableWebError {

    case itsComplicated(complication: String)

    var serializedCode: String {
        switch self {
        case .itsComplicated(complication: let c):
            return "its_complicated:\(c)"
        }
    }

}
```

above error will generate following error response:

```json
// Status 500
{
    "code": "my_error.its_complicated:huge_problem"
}
```

### Integration with Vapor

#### WebErrorMiddleware

Register `WebErrorMiddleware` in your `configure` method

```swift
s.register(MiddlewareConfiguration.self) { c in
    // Create _empty_ middleware config
    var middlewares = MiddlewareConfiguration()

    // Catches errors and converts to HTTP response
    try middlewares.use(c.make(WebErrorMiddleware.self))

    return middlewares
}
```

#### Handling `Swift.Error`

- Code of the error message will be "snake cased" type of the error
- Status code is set to `500`
- Reason is `localizedDescription`

#### Handling `Vapor.AbortError`

- Code of the error message will be "snake cased" type of the error while the reason and status code works the same

Base error types.

### Author

Ondrej Rafaj @rafiki270

### License

MIT; Copyright 2019 - Einstore
