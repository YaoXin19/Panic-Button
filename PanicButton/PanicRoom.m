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
        NSMenuItem *item = [[PanicMenuItem alloc] initWithTitle:cmd.title action:@selector(setSelectedCommand:) keyEquivalent:@""];
        [item setTarget:self];
        [item setRepresentedObject:cmd.shellCommand];

        [actionsMenu addItem:item];
        [item release];
    }];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"selected_command"] != nil) {
        NSInteger index = [defaults integerForKey:@"selected_command"];
        if (index < options.commands.count) {
            [self setSelectedCommand:[[actionsMenu itemArray] objectAtIndex:index]];
        } else if (options.commands.count > 0) {
            [self setSelectedCommand:[[actionsMenu itemArray] objectAtIndex:0]];
        }
    } else if (options.commands.count > 0) {
        [self setSelectedCommand:[[actionsMenu itemArray] objectAtIndex:0]];
    }

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
    [self revertAllCheckmarks];

    NSMenuItem *item = sender;
    NSString *checkmark = @"✓  ";

    NSLog(@"setting selected command '%@'", item.title);
    [item setTitle:[checkmark stringByAppendingString:item.title]];
    [listener setTask:[sender representedObject]];

    __block NSInteger theIndex = -1;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[actionsMenu itemArray] enumerateObjectsUsingBlock:^(NSMenuItem *obj, NSUInteger idx, BOOL *stop) {
        if (obj == item) {
            theIndex = idx;
            *stop = YES;
        }
    }];

    if (theIndex >= 0) {
        [defaults setInteger:theIndex forKey:@"selected_command"];
    }
}

#pragma mark - checkmarks
- (void) revertAllCheckmarks {
    [[actionsMenu itemArray] enumerateObjectsUsingBlock:^(PanicMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item reset];
    }];
}

@end
