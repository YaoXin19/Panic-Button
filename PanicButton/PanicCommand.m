//
//  PanicCommand.m
//  PanicButton
//
//  Created by Tim Jarratt on 4/9/14.
//  Copyright (c) 2014 Tim Jarratt. All rights reserved.
//

#import "PanicCommand.h"

@interface PanicCommand()
@property (strong, readwrite, retain) NSString *title;
@property (strong, readwrite, retain) NSString *shellCommand;
@end

@implementation PanicCommand

-(instancetype) initWithDict:(NSDictionary *) dict {
    if (self = [super init]) {
        [self setTitle:[dict valueForKey:@"title"]];
        [self setShellCommand:[dict valueForKey:@"script"]];
    }

    return self;
}

@end