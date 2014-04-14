//
//  PanicMenuItem.m
//  PanicButton
//
//  Created by Tim Jarratt on 4/13/14.
//  Copyright (c) 2014 Tim Jarratt. All rights reserved.
//

#import "PanicMenuItem.h"

@interface PanicMenuItem ()
@property (strong, retain, readwrite) NSString *originalTitle;
@end

@implementation PanicMenuItem

- (instancetype) initWithTitle:(NSString *)aString action:(SEL)aSelector keyEquivalent:(NSString *)charCode {
    if (self = [super initWithTitle:aString action:aSelector keyEquivalent:charCode]) {
        [self setOriginalTitle:aString];
    }

    return self;
}

- (void) reset {
    [self setTitle:[self originalTitle]];
}
@end
