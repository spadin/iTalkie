//
//  AppDelegate.h
//  iTalkie
//
//  Created by Sandro Padin on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    int initialVolume;
}
- (void) mute;
- (void) unmute;
- (void) setInputVolumeTo: (int)num;
- (int)  currentInputVolume;

OSStatus keyPressedHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData);
OSStatus keyReleasedHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData);

@property (retain) NSStatusItem *statusItem;
@property (assign) IBOutlet NSWindow *window;

@end
