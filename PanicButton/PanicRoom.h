//
//  PanicRoom.h
//  PanicButton
//
//  Created by Tim Jarratt on 3/30/13.
//  Copyright (c) 2013 Tim Jarratt. All rights reserved.
//

#import "PanicButton.h"
#import "PanicOptions.h"
#import "panicCommand.h"

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
    NSMenu *menu;
    NSMenu *actionsMenu;
    NSStatusItem *statusItem;

    PanicButton *panicButton;
    PanicOptions *options;
}

- (void) startup;
- (void) startRunloop;
- (void) createStatusBar;

// menu actions
- (IBAction) quitApplication:(id) sender;
- (IBAction) performCommand:(id) sender;

@end
