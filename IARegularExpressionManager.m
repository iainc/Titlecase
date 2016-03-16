//
//  IARegularExpressionManager.m
//  Titlecase
//
//  Copyright © 2016 Information Architects Inc. All rights reserved.
//

#import "IARegularExpressionManager.h"

@implementation IARegularExpressionManager

- (instancetype)initWithRegularExpressions:(NSString *)regularExpressions options:(NSRegularExpressionOptions)options {
    self = [super init];
    NSDictionary *regularExpressionsDictionary = [self dictionaryWithRegularExpressionString:regularExpressions options:options];
    [regularExpressionsDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSString *pattern, BOOL *stop) {
        if ([self respondsToSelector:NSSelectorFromString(propertyName)] == NO) {
            return;
        }
        if ([self valueForKey:propertyName]) {
            return;
        }
        NSError *regularExpressionError;
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAllowCommentsAndWhitespace|options error:&regularExpressionError];
        if (regularExpression == nil) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Error in regular expression %@: %@.", propertyName, regularExpressionError.localizedDescription] userInfo:@{}];
        }
        [self setValue:regularExpression forKey:propertyName];
    }];
    return self;
}

- (NSDictionary *)dictionaryWithRegularExpressionString:(NSString *)regularExpressionString options:(NSRegularExpressionOptions)options {
    NSMutableDictionary *regularExpressions = [[NSMutableDictionary alloc] init];
    NSError *error;
    // Format expression parses the file.
    NSRegularExpression *expressionRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"^([a-zA-Z0-9]{3,})\\ ?=\\ ?\\{\\n(.*?)\\n^\\}$" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionAnchorsMatchLines|NSRegularExpressionAllowCommentsAndWhitespace|options error:&error];
    [expressionRegularExpression enumerateMatchesInString:regularExpressionString options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, regularExpressionString.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (result) {
            NSString *expressionName = [regularExpressionString substringWithRange:[result rangeAtIndex:1]];
            NSString *expression = [regularExpressionString substringWithRange:[result rangeAtIndex:2]];
            // Single-line expressions are trimmed (they are likely to be used as a variable).
            if ([expression containsString:@"\n"]) {
                expression = [expression stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t "]];
            }
            regularExpressions[expressionName] = expression;
        }
    }];
    // Some of the expressions may be used as a part of other expressions, as variables. We “copy & paste” those expressions.
    NSRegularExpression *variableRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"(?<= ^|\\ |\\( )\\$([a-zA-Z0-9]{3,})(?= $|\\ |\\) )" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionAnchorsMatchLines|NSRegularExpressionAllowCommentsAndWhitespace|options error:&error];
    [regularExpressions.copy enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSString *expression, BOOL *stop) {
        NSArray *referenceMatches = [variableRegularExpression matchesInString:expression options:0 range:NSMakeRange(0, expression.length)];
        NSMutableString *updatedExpression = expression.mutableCopy;
        for (NSTextCheckingResult *referenceMatch in referenceMatches.reverseObjectEnumerator) {
            NSString *referenceName = [expression substringWithRange:[referenceMatch rangeAtIndex:1]];
            NSString *referenceExpression = regularExpressions[referenceName];
            if (referenceExpression) {
                [updatedExpression replaceCharactersInRange:referenceMatch.range withString:referenceExpression];
            }
        }
        regularExpressions[name] = updatedExpression;
    }];
    return regularExpressions;
}

@end
