//
//  NSString+IATitlecase.m
//  Titlecase
//
//  Copyright © 2016 Information Architects Inc. All rights reserved.
//

#import "NSString+IATitleCase.h"
#import "IATitlecaseRegularExpressionManager.h"

@interface NSString (IATitlecaseAdditions)

@property (readonly) NSString *firstCharacterCapitalizedString;

@end

@implementation NSMutableString (IATitlecaseExpression)

- (void)replaceMatchesForRegularExpression:(NSRegularExpression *)expression usingTransforms:(NSDictionary<NSNumber *, NSString *(^)(NSString *, NSInteger *)> *)transforms {
    [expression enumerateMatchesInString:self options:0 range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        for (NSInteger matchRangeIndex = 0; matchRangeIndex < result.numberOfRanges; matchRangeIndex++) {
            NSRange range = [result rangeAtIndex:matchRangeIndex];
            if (range.location == NSNotFound) {
                continue;
            }
            NSString *(^transform)(NSString *word, NSInteger *next) = transforms[@(matchRangeIndex)];
            if (transform == nil) {
                continue;
            }
            NSString *substring = [self substringWithRange:range];
            NSString *modifiedSubstring = transform(substring, &matchRangeIndex);
            if (substring.length != modifiedSubstring.length) {
                @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Modified string must have the same length as original." userInfo:@{}];
            }
            [self replaceCharactersInRange:range withString:modifiedSubstring];
        }
    }];
}

@end

#define transform(expression) ^NSString *(NSString *word, NSInteger *next){ expression }

@implementation NSString (IATitlecase)

- (NSString *)titlecaseString {
    // Regular expressions and their processing are based on the particular revision of Perl script with one difference: white space is not stripped, because I want the NSString category act similarly to -(uppercase|lowercase|capitalized)String.
    // https://gist.github.com/gruber/9f9e8650d68b13ce4d78/d7d64ccbc6e1c86b0aae5cb368ea1f6f7f3738c5
    IATitlecaseRegularExpressionManager *manager = [IATitlecaseRegularExpressionManager sharedManager];
    NSMutableString *titlecaseString = [([self.uppercaseString isEqualToString:self] ? self.lowercaseString : self) mutableCopy];
    [titlecaseString replaceMatchesForRegularExpression:manager.titlecaseExpression usingTransforms:@{
        @1: transform( return word; ),
        @2: transform( *next = 6; return word; ),
        @3: transform( *next = 6; return word.lowercaseString; ),
        @4: transform( *next = 6; return word.lowercaseString.firstCharacterCapitalizedString; ),
        @5: transform( return word; ),
        @6: transform( return word; ),
	}];
    [titlecaseString replaceMatchesForRegularExpression:manager.startExceptionExpression usingTransforms:@{
        @1: transform( return word; ),
        @2: transform( return word.lowercaseString.firstCharacterCapitalizedString; ),
	}];
    [titlecaseString replaceMatchesForRegularExpression:manager.endExceptionExpression usingTransforms:@{
        @1: transform( return word.lowercaseString.firstCharacterCapitalizedString; ),
	}];
    [titlecaseString replaceMatchesForRegularExpression:manager.startHyphenatedCompoundExpression usingTransforms:@{
        @1: transform( return word.lowercaseString.firstCharacterCapitalizedString; ),
	}];
    [titlecaseString replaceMatchesForRegularExpression:manager.endHyphenatedCompoundExpression usingTransforms:@{
        @1: transform( return word; ),
        @2: transform( return word.firstCharacterCapitalizedString; ),
	}];
    return titlecaseString;
}

- (NSString *)firstCharacterCapitalizedString {
    NSRange firstCharacterRange = [self rangeOfComposedCharacterSequenceAtIndex:0];
    NSString *firstCharacter = [self substringWithRange:firstCharacterRange];
    return [self stringByReplacingCharactersInRange:firstCharacterRange withString:firstCharacter.uppercaseString];
}

@end
