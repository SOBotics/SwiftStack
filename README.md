# About SwiftStack
SwiftStack is a wrapper for the Stack Exchange API written in Swift.


# How to use

To use SwiftStack via Swift Package Manager in your project, add it as dependency in your `Package.swift`.

```
let package = Package(
    name: "MyProject",
    dependencies: [
        .Package(url: "https://github.com/NobodyNada/SwiftStack.git", versions: Version(0,0,0)..<Version(.max, .max, .max))
    ]
)
```

You can import the module with: `import SwiftStack`

## Create a basic request (/sites)

First of all, you need an instance of `APIClient`. From this instance, you will call all the requests to the Stack Exchange API.

    let client = APIClient()
    
### Asynchronous request

Asynchronous requests have completion handlers and will all look like this:

    client.fetchSites() {
        response, error in
    }
    
Response will always be of type `APIResponse<T: JsonConvertible>`. In this example, `T` is of type `Site`.

Of course, the functions can be more complex, when you want to pass parameters.

### Synchronous request

Synchronous requests return the result as `APIResponse<T: JsonConvertible>` and `throw` errors. In this example, `T` is of type `Site`.

```
do {
    let response = try client.fetchSites()
} catch {
    print("An error occurred: \(error)")
}
```

Of course, the functions can be more complex, when you want to pass parameters.


## Returned objects

Every object that contains data of the Stack Exchange API (for example `User`, `Question`,...) has properties with the exact same names as returned by the API, even when those names don't follow Swift conventions.

## Documentation

The documentation can be found on GitHub Pages: https://sobotics.github.io/SwiftStack/
