//
//  PanicOptions.m
//  PanicButton
//
//  Created by Tim Jarratt on 4/5/14.
//  Copyright (c) 2014 Tim Jarratt. All rights reserved.
//

#import "PanicOptions.h"

@interface PanicOptions()
@property (strong, readwrite, retain) NSString *title;
@property (strong, readwrite, retain) NSArray *commands;
@end

@implementation PanicOptions

-(instancetype) init {
    if (self = [super init]) {
        [self setDefaults];

        NSArray *components = @[NSHomeDirectory(), @".panic", @"config.json"];
        NSString *pathToConfig = [NSString pathWithComponents:components];
        NSData *data = [NSData dataWithContentsOfFile:pathToConfig];

        [self readConfigJSON:data];
    }

    return self;
}

-(void) setDefaults {
    [self setTitle:@"Panic!"];
}

-(void) readConfigJSON:(NSData *)data {
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    if (!object) {
        return NSLog(@"Failed to read config. Bailing!!");
    }

    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *config = object;
        NSString *title = [config valueForKey:@"title"];
        if (title != nil && !([title isEqualToString:@""])) {
            [self setTitle:title];
        }

        NSArray *commands = [config valueForKey:@"commands"];
        if (commands != nil) {
            [self setCommands:commands];
        }
    }
}

@end
