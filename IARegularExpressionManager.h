//
//  IARegularExpressionManager.h
//  Titlecase
//
//  Copyright © 2016 Information Architects Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Regular expressions benefit from proper formatting and comments just like any other code. Double escapes and the lack of multiple line support make inline regular expressions less portable and maintable. This class is intended to be used with strings initialized from a file where you can properly format regular expressions.
///
/// \code
/// imageExpression = {
///     (?i)
///     $nameExpression
///	    \.(jpe?g|png|gif)
/// }
/// nameExpression = {
/// 	(\w+)
/// }
/// \endcode
///
/// Expression names and variables must be at least 3 characters long. You should use expressive names. Variables must be separated by a space or enclosed in parentheses.
///
/// \c IARegularExpressionManager is intended to be subclassed. Regular expressions in a string which have matching properties will be set using KVC. A shared instance is recommended to avoid parsing the file again and again.
@interface IARegularExpressionManager : NSObject

/// Will parse the regular expressions and attempt to set them using KVC. Options will be applied to each expression.
- (instancetype)initWithRegularExpressions:(NSString *)regularExpressions options:(NSRegularExpressionOptions)options NS_DESIGNATED_INITIALIZER;

/// Use designated intiializer.
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
