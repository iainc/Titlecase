## Titlecase

Modern Objective-C port of [title case script][Script] by John Gruber and Aristotle Pagaltzis.

[John Gruber][Article]:

> It’s pretty easy to write a non-clever title-casing function. The simplest way is to just capitalize the first letter of every word. That’s not right, though, because it’ll leave you with capitalized small words like if, in, of, on, etc. What you want is something that not only knows not to capitalize such words, but will un-capitalize them if they’re erroneously capitalized in the input.

We originally developed the port for [iA Writer 3.1.1][iA Writer]. We decided to open source it because we think it woud be useful to others. We’d be happy to see proper title case available in more apps.

### Components

#### `NSString+IATitlecase`

`NSString` category which returns a copy of a given string transformed to title case.

#### `IARegularExpressionManager`

Regular expressions benefit from proper formatting and comments just like any other code. Double escapes and the lack of multiple line support make inline regular expressions less portable and maintable in Cocoa. This class is intended to be used with strings initialized from a file where you can properly format regular expressions.

```
imageExpression = {
    (?i)
    $nameExpression
    \.(jpe?g|png|gif)
}
nameExpression = {
	(\w+)
}
```

Expression names and variables must be at least 3 characters long. You should use expressive names. Variables must be separated by a space or enclosed in parentheses.

`IARegularExpressionManager` is intended to be subclassed. Regular expressions in a string which have matching properties will be set using KVC. A shared instance is recommended to avoid parsing the file again and again. 

#### `IATitlecaseRegularExpressionManager` and `Titlecase.regex`

Regular expressions from [title case script][Script] by John Gruber and Aristotle Pagaltzis. This is a good example of a concrete subclass of `IARegularExpressionManager`.

#### `NSTextView+IATitlecase`

This category adds a “Make Title Case” transform to contextual menu in every `NSTextView` and `NSTextField` in your app. Requires [`Aspects`][Aspects] by Peter Steinberger. `titlecaseWord:` behavior closely follows system methods such as `lowercaseWord:` and `capitalizeWord:

### Tests

Titlecase passes [tests][Tests] from John Gruber, David Gouch, and Aristotle Pagaltzis. Only trimming tests are excluded, because our `titlecaseString` implementation follows the behavior of system methods such as `uppercaseString` and `capitalizedString`. 

### Supported SDK Versions

Titlecase requires ARC. Tested with iOS 9 and OS X 10.11. Supports iOS 7+ and OS X 10.7+.

### License

MIT license. Copyright © 2016 Information Architects Inc.

[Article]: http://daringfireball.net/2008/05/title_case
[Script]: https://gist.github.com/gruber/9f9e8650d68b13ce4d78
[Aspects]: https://github.com/steipete/Aspects
[Tests]: https://github.com/ap/titlecase/blob/master/test.pl
[iA Writer]: http://ia.net/writer