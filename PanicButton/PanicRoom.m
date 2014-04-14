//
//  PanicRoom.m
//  PanicButton
//
//  Created by Tim Jarratt on 3/30/13.
//  Copyright (c) 2013 Tim Jarratt. All rights reserved.
//

#import "PanicRoom.h"

@implementation PanicRoom

#pragma mark - Lifecycle
- (instancetype) init {
    if (self = [super init]) {
        options = [[[PanicOptions alloc] init] retain];
        listener = [[PanicListener alloc] init];
    }

    return self;
}

- (void) start {
    [self createStatusBar];
    [NSThread detachNewThreadSelector:@selector(startRunloop) toTarget:listener withObject:nil];
}

- (void) dealloc {
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
    [super dealloc];
}

#pragma mark - NSStatusItem Menu
- (void) createStatusBar {
    float width = 50.0;
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:width] retain];
    [statusItem setHighlightMode:YES];
    
    menu = [[NSMenu alloc] init];
    
    NSMenuItem *actions_item = [[NSMenuItem alloc] initWithTitle:@"Actions" action:nil keyEquivalent:@""];
    NSMenuItem *quit_item = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quitApplication:) keyEquivalent:@""];

    [quit_item setTarget:self];

    actionsMenu = [[[NSMenu alloc] init] autorelease];
    [options.commands enumerateObjectsUsingBlock:^(PanicCommand *cmd, NSUInteger index, BOOL *stop) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:cmd.title action:@selector(setSelectedCommand:) keyEquivalent:@""];
        [item setTarget:self];
        [item setRepresentedObject:cmd.shellCommand];

        [actionsMenu addItem:item];
        [item release];
    }];

    [actions_item setSubmenu:actionsMenu];
    
    [menu addItem:actions_item];
    [menu addItem:quit_item];
    
    [statusItem setTitle:[options title]];
    [statusItem setMenu:menu];

    [quit_item release];
}

#pragma mark - Menu actions
- (void) quitApplication:(id) sender {
    NSLog(@"Goodbye!");
    exit(0);
}

- (void) setSelectedCommand:(id) sender {
    [listener setTask:[sender representedObject]];
}

@end
