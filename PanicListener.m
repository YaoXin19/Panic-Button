//
//  PanicListener.m
//  PanicButton
//
//  Created by Tim Jarratt on 4/12/14.
//  Copyright (c) 2014 Tim Jarratt. All rights reserved.
//

#import "PanicListener.h"

@implementation PanicListener
#pragma mark - RunLoop
- (void)startRunloop {
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
    CFRelease(usageRef);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        IOHIDManagerRegisterDeviceMatchingCallback(manager, deviceMatchingCallback, (void *)self);
        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        IOReturn ret = IOHIDManagerOpen(manager, kIOHIDOptionsTypeNone);
        if (ret == kIOReturnSuccess) {
            CFRunLoopRun();
        }
        CFRelease(manager);
    });

    CFRunLoopRun();
}

#pragma mark - Device Usage
static void timerCallback(CFRunLoopTimerRef timer, void *info) {
    PanicListener *self = (PanicListener *) info;
    [self timerCallback];
}

- (void) timerCallback {
    if ([panicButton wasPushed]) {
        [self performSelector:self.action];
    }
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
    PanicListener *const this_class = (PanicListener *const) context;
    [this_class handleMatchingDevice:device sender:sender result:result];
}

- (void) handleMatchingDevice:(IOHIDDeviceRef)device sender:(void *)sender result:(IOReturn)result {
    panicButton = [[PanicButton alloc] init];
    panicButton.device = device;
    panicButton.volume = [[VolumeKnob alloc] init];

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
        NSLog(@"PANIC: Could not initialize a CFTimer for a matching device.");
        exit(1);
    }
}
@end
