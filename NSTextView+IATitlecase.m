//
//  NSTextView+IATitlecase.m
//  Titlecase
//
//  Copyright © 2016 Information Architects Inc. All rights reserved.
//

#import "NSTextView+IATitlecase.h"
#import "NSString+IATitlecase.h"
#import "Aspects.h"

@implementation NSTextView (IATitlecase)

+ (void)load {
    // Implemented using aspects because we want every text entry to have “Make Title Case”. NSTextField uses NSTextView under the hood, so it gets the menus too.
    NSError *error;
    [self aspect_hookSelector:@selector(menuForEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        // __unsafe_unretained prevents ARC from overreleasing menu at the end.
        __unsafe_unretained NSMenu *menu;
        [[aspectInfo originalInvocation] getReturnValue:&menu];
        for (NSMenuItem *menuItem in menu.itemArray.reverseObjectEnumerator) {
            if (menuItem.hasSubmenu == NO) {
                continue;
            }
            NSInteger capitalizeIndex = [menuItem.submenu indexOfItemWithTarget:nil andAction:@selector(capitalizeWord:)];
            if (capitalizeIndex != -1) {
                NSMenuItem *capitalizeAsTitleItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Make Title Case", @"Title case transform title.") action:@selector(titlecaseWord:) keyEquivalent:@""];
                [menuItem.submenu addItem:capitalizeAsTitleItem];
                break;
            }
        }
    } error:&error];
}

- (void)titlecaseWord:(id)sender {
    if (self.isEditable == NO) {
        return;
    }
    [self selectWord:self];
    NSArray<NSValue *> *ranges = self.selectedRanges.copy;
    NSMutableArray<NSString *> *strings = [[NSMutableArray alloc] init];
    for (NSValue *rangeValue in ranges) {
        NSString *text = [self.string substringWithRange:rangeValue.rangeValue];
        NSString *titlecaseText = text.titlecaseString;
        [strings addObject:titlecaseText];
    }
    if ([self shouldChangeTextInRanges:ranges replacementStrings:strings] == NO) {
        return;
    }
    for (NSInteger rangeIndex = 0; rangeIndex < ranges.count; rangeIndex++) {
        [self replaceCharactersInRange:ranges[rangeIndex].rangeValue withString:strings[rangeIndex]];
    }
    [self setSelectedRanges:ranges];
}

@end
