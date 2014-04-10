//
//  PanicOptions.h
//  PanicButton
//
//  Created by Tim Jarratt on 4/5/14.
//  Copyright (c) 2014 Tim Jarratt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PanicCommand.h"

@interface PanicOptions : NSObject

@property (strong, readonly, retain) NSString *title;
@property (strong, readonly, retain) NSArray *commands;

@end
