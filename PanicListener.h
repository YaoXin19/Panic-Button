//
//  PanicListener.h
//  PanicButton
//
//  Created by Tim Jarratt on 4/12/14.
//  Copyright (c) 2014 Tim Jarratt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

#import <IOKit/hid/IOHIDLib.h>
#import <CoreAudio/CoreAudio.h>
#import <CoreAudioKit/CoreAudioKit.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "PanicButton.h"

# define vendor_id 0x1130;
# define product_id 0x0202;
# define primary_usage 0;

@interface PanicListener : NSObject {
    PanicButton *panicButton;
}

@property (readwrite) SEL action;

@end
