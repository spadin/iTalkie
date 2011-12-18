//
//  AppDelegate.m
//  iTalkie
//
//  Created by Sandro Padin on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <Carbon/Carbon.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize statusItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    EventHotKeyRef myHotKeyRef;
    EventHotKeyID myHotKeyID;
    EventTypeSpec keyPressedEventType;
    EventTypeSpec keyReleaseEventType;
    
    keyPressedEventType.eventClass=kEventClassKeyboard;
    keyPressedEventType.eventKind=kEventHotKeyPressed;
    
    keyReleaseEventType.eventClass=kEventClassKeyboard;
    keyReleaseEventType.eventKind=kEventHotKeyReleased;
    
    void *s = (__bridge_retained void *)self;
    
    InstallApplicationEventHandler(&keyPressedHandler, 1, &keyPressedEventType, s, NULL);
    InstallApplicationEventHandler(&keyReleasedHandler, 1, &keyReleaseEventType, s, NULL);
    
    myHotKeyID.signature='mhk1';
    myHotKeyID.id=1;
    
    RegisterEventHotKey(97, 0, myHotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [self setInputVolumeTo:initialVolume];
}

- (void)awakeFromNib
{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setHighlightMode:YES];
    
    initialVolume = [self currentInputVolume];
    
    [self mute];
}
- (void) setInputVolumeTo: (int)num
{
    NSAppleScript *run = [[NSAppleScript alloc] 
                          initWithSource:[NSString stringWithFormat:@"tell application \"System Events\" to set volume input volume %i", num]];
	[run executeAndReturnError:nil];
}
- (int) currentInputVolume
{
    NSDictionary *error = nil;
    
    NSMutableString *scriptText = [NSMutableString stringWithString:@"set currentVolume to missing value\n"];
    [scriptText appendString:@"tell application \"System Events\"\n"];
    [scriptText appendString:@"set currentVolume to input volume of (get volume settings)\n"];
    [scriptText appendString:@"end tell\n"];
    [scriptText appendString:@"return currentVolume\n"];
    
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptText];
    NSAppleEventDescriptor *result = [script executeAndReturnError:&error];    
    NSData *data = [result data];
    
    long long currentInputVolume = 0;
    [data getBytes:&currentInputVolume length:[data length]];
    
    return (int)currentInputVolume;
}
- (void) mute
{
    [statusItem setImage:[NSImage imageNamed:@"microphone_muted"]];
    [statusItem setAlternateImage:[NSImage imageNamed:@"neg_microphone_muted"]];
    [self setInputVolumeTo:0];
}
- (void) unmute 
{
    [statusItem setImage:[NSImage imageNamed:@"microphone"]];
    [statusItem setAlternateImage:[NSImage imageNamed:@"neg_microphone"]];
    [self setInputVolumeTo:100];
}
OSStatus keyPressedHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData)
{   
    [(__bridge AppDelegate*)userData unmute];
    return noErr; 
}
OSStatus keyReleasedHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData)
{
    [(__bridge AppDelegate*)userData mute];
    return noErr; 
}
@end
