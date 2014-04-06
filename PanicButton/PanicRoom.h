//
//  PanicRoom.h
//  PanicButton
//
//  Created by Tim Jarratt on 3/30/13.
//  Copyright (c) 2013 Tim Jarratt. All rights reserved.
//

#import "PanicButton.h"
#import "PanicOptions.h"

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

#import <IOKit/hid/IOHIDLib.h>
#import <CoreAudio/CoreAudio.h>
#import <CoreAudioKit/CoreAudioKit.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

# define vendor_id 0x1130;
# define product_id 0x0202;
# define primary_usage 0;

@interface PanicRoom : NSObject {
    SEL action;
    NSStatusItem *statusItem;
    PanicButton *panic_button;
    PanicOptions *options;
}

- (void) startup;
- (void) create_status_bar;
- (void) start_runloop;

// menu actions
- (void) quit_application;

@end
