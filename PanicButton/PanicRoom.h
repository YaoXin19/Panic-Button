//
//  PanicRoom.h
//  PanicButton
//
//  Created by Tim Jarratt on 3/30/13.
//  Copyright (c) 2013 Tim Jarratt. All rights reserved.
//

#import "PanicOptions.h"
#import "PanicCommand.h"
#import "PanicListener.h"

#import <Cocoa/Cocoa.h>

@interface PanicRoom : NSObject {
    NSMenu *menu;
    NSMenu *actionsMenu;
    NSStatusItem *statusItem;

    PanicOptions *options;
    PanicListener *listener;
}

- (void) start;
- (void) createStatusBar;

// menu actions
- (IBAction) quitApplication:(id) sender;
- (IBAction) performCommand:(id) sender;

@end
