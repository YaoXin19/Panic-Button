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
- (void) startup {
    [self create_status_bar];
    options = [[PanicOptions alloc] init];
    [NSThread detachNewThreadSelector:@selector(start_runloop) toTarget:self withObject:nil];
}

- (void) dealloc {
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
    [super dealloc];
}

#pragma mark - NSStatusItem Menu
- (void) create_status_bar {
    float width = 50.0;
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:width] retain];
    [statusItem setHighlightMode:YES];
    
    NSMenu *menu = [[NSMenu alloc] init];
    
    NSMenuItem *actions_item = [[NSMenuItem alloc] initWithTitle:@"Actions" action:nil keyEquivalent:@""];
    NSMenuItem *quit_item = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quit_application) keyEquivalent:@""];

    [quit_item setTarget:self];

    NSMenu *actions_menu = [[[NSMenu alloc] init] autorelease];
    // TODO: add actions from config parser

    [actions_item setSubmenu:actions_menu];
    
    [menu addItem:actions_item];
    [menu addItem:quit_item];
    
    [statusItem setTitle:[options title]];
    [statusItem setMenu:menu];
}

#pragma mark - RunLoop
- (void)start_runloop {
    NSLog(@"starting runloop");
        
    IOHIDManagerRef manager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
    if (!CFGetTypeID(manager) == IOHIDManagerGetTypeID()) {
        NSLog(@"couldn't get a IO HID manager ref");
        exit(1);
    }
    
    CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    if (!dict) {
        NSLog(@"Couldn't create device dict");
        exit(1);
    }
    
    int usage = primary_usage;
    int vendorID = vendor_id;
    int productID = product_id;
    CFNumberRef vendorRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &vendorID);
    CFNumberRef productRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &productID);
    CFNumberRef usageRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &usage);
    
    CFDictionaryAddValue(dict, CFSTR(kIOHIDVendorIDKey), vendorRef);
    CFDictionaryAddValue(dict, CFSTR(kIOHIDProductIDKey), productRef);
    CFDictionaryAddValue(dict, CFSTR(kIOHIDPrimaryUsageKey), usageRef);

    IOHIDManagerSetDeviceMatching(manager, dict);
    
    CFRelease(vendorRef);
    CFRelease(productRef);
    CFRelease(dict);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        IOHIDManagerRegisterDeviceMatchingCallback(manager, deviceMatchingCallback, (void *)self);
        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        IOReturn ret = IOHIDManagerOpen(manager, kIOHIDOptionsTypeNone);
        if (ret == kIOReturnSuccess) {
            CFRunLoopRun();
        }
        CFRelease(manager);
    });
    
    NSLog(@"started cf runloop");
    CFRunLoopRun();
}

#pragma mark - Device Usage
static void timerCallback(CFRunLoopTimerRef timer, void *info) {
    PanicRoom *room = (PanicRoom *) info;
    [room timer_callback];
}

- (void) timer_callback {
    if ([panic_button was_pushed]) {
        [self handle_current_action];
    }
}

- (void) handle_current_action {
    [self performSelector:action];
}

#pragma mark - Device Lifecycle
static void deviceRemovedCallback(void *context, IOReturn result, void *sender) {
    CFRunLoopTimerRef timer = (CFRunLoopTimerRef)context;
    if (timer && CFGetTypeID(timer) == CFRunLoopTimerGetTypeID()) {
        CFRunLoopTimerContext ctx;
        bzero(&ctx, sizeof(ctx));
        CFRunLoopTimerGetContext(timer, &ctx);
        if (ctx.info) {
            CFRelease(ctx.info);
        }
        CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes);
        timer = NULL;
    }
}

static void deviceMatchingCallback(void *context, IOReturn result, void *sender, IOHIDDeviceRef device) {
    PanicRoom *const this_class = (PanicRoom *const) context;
    [this_class handle_matching_device:device sender:sender result:result];
}

- (void) handle_matching_device:(IOHIDDeviceRef)device sender:(void *)sender result:(IOReturn)result {
    panic_button = [[PanicButton alloc] init];
    panic_button.device = device;
    panic_button.volume = [[VolumeKnob alloc] init];

    CFRunLoopTimerContext context;
    bzero(&context, sizeof(context));
    context.info = (void *) CFRetain(self);
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0, 0.1, 0, 0, timerCallback, &context);
    
    if (timer) {
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes);
        IOHIDDeviceRegisterRemovalCallback(device, deviceRemovedCallback, timer);
        CFRelease(timer);
    }
    else {
        NSLog(@"Could not initialize a CFTimer for a matching device.");
        exit(1);
    }
}

#pragma mark - Menu actions
- (void) quit_application {
    NSLog(@"Quit!");
    exit(0);
}

@end
