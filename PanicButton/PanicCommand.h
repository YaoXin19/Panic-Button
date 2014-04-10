//
//  PanicCommand.h
//  PanicButton
//
//  Created by Tim Jarratt on 4/9/14.
//  Copyright (c) 2014 Tim Jarratt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PanicCommand : NSObject
@property (strong, readonly, retain) NSString *title;
@property (strong, readonly, retain) NSString *shellCommand;

-(instancetype) initWithDict:(NSDictionary *) dict;
@end