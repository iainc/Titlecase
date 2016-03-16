//
//  IATitlecaseRegularExpressionManager.h
//  Titlecase
//
//  Copyright © 2016 Information Architects Inc. All rights reserved.
//

#import "IARegularExpressionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface IATitlecaseRegularExpressionManager : IARegularExpressionManager

+ (instancetype)sharedManager;

@property (nonatomic) NSRegularExpression *titlecaseExpression;
@property (nonatomic) NSRegularExpression *startExceptionExpression;
@property (nonatomic) NSRegularExpression *endExceptionExpression;
@property (nonatomic) NSRegularExpression *startHyphenatedCompoundExpression;
@property (nonatomic) NSRegularExpression *endHyphenatedCompoundExpression;

@end

NS_ASSUME_NONNULL_END
