//
//  PanicMenuItem.h
//  PanicButton
//
//  Created by Tim Jarratt on 4/13/14.
//  Copyright (c) 2014 Tim Jarratt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PanicMenuItem : NSMenuItem
@property (strong, retain, readonly) NSString *originalTitle;
- (void) reset;
@end
