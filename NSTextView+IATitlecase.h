//
//  NSTextView+IATitlecase.h
//  Titlecase
//
//  Copyright © 2016 Information Architects Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/// This category adds a “Make Title Case” transform to contextual menu in every NSTextView and NSTextField.
@interface NSTextView (IATitlecase)

- (IBAction)titlecaseWord:(nullable id)sender;

@end
