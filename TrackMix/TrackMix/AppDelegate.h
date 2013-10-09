//
//  AppDelegate.h
//  TrackMix
//
//  Created by stone win on 1/6/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Track;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSSlider *slider;
@property (strong) Track *track;

- (IBAction)mute:(id)sender;
- (IBAction)takeFloatValueForVolumeFrom:(id)sender;

@end
