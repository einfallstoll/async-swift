async-swift
===========

Async utilities for Swift

## Documentation

### Collections

* [`each`](#each)

## Collections

<a name="each" />
### each(arr, iterator, asyncCallback)

Applies the function `iterator` to each item in `arr`, in parallel.
The `iterator` is called with an item from the list, and a callback for when it
has finished. If the `iterator` passes an error to its `asyncCallback`, the main
`callback` (for the `each` function) is immediately called with the error.

Note, that since this function applies `iterator` to each item in parallel,
there is no guarantee that the iterator functions will complete in order.

__Arguments__

* `arr` - An array to iterate over.
* `iterator(item, asyncCallback)` - A function to apply to each item in `arr`.
The iterator is passed a `asyncCallback(error)` which must be called once it has 
completed. If no error has occurred, the `asyncCallback` should be run with a `nil` argument.
* `finished(error)` - A callback which is called when all `iterator` functions
have finished, or an error occurs.

__Examples__


```swift
var posts = [17, 15, 13]

Async.each(posts, iterator: { (post, asyncCallback) -> Void in
    NewsAPI.loadPost(post) { (possibleError: String?, content: String) -> () in
        if let error = possibleError {
            asyncCallback(error: error)
        } else {
            loadedPosts[post] = content
            asyncCallback(error: nil)
        }
    }
}) { (error: String?) -> Void in
    if error != nil {
        println("An error occured: \(error!)")
    } else {
        println("All posts loaded")
    }
}
```