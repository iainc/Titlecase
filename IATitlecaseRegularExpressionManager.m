//
//  IATitlecaseRegularExpressionManager.m
//  Text
//
//  Created by Anton Sotkov on 23.01.16.
//  Copyright © 2016 Information Architects Inc. All rights reserved.
//

#import "IATitlecaseRegularExpressionManager.h"

@implementation IATitlecaseRegularExpressionManager

+ (instancetype)sharedManager {
    static IATitlecaseRegularExpressionManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[IATitlecaseRegularExpressionManager alloc] initWithRegularExpressions:self.regularExpressions options:0];
    });
    return sharedManager;
}

+ (NSString *)regularExpressions {
    NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"Titlecase" withExtension:@"regex"];
	NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return string;
}

@end
