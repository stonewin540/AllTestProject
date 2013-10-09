//
//  AppDelegate.m
//  TrackMix
//
//  Created by stone win on 1/6/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "AppDelegate.h"
#import "Track.h"

@implementation AppDelegate
@synthesize textField;
@synthesize slider;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    Track *aTrack = [[Track alloc] init];
    self.track = aTrack;
}

- (IBAction)mute:(id)sender {
    
    //NSLog(@"received a mute: message");
    self.track.volume = 0;
    [self updateUserInterface];
    
}

- (void)updateUserInterface
{
    if (self.track)
    {
        float volume = self.track.volume;
        [self.textField setFloatValue:volume];
        [self.slider setFloatValue:volume];
    }
}

- (IBAction)takeFloatValueForVolumeFrom:(id)sender {
    
    /*
    NSString *senderName = nil;
    
    if (sender == self.textField) {
        
        senderName = @"textField";
        
    }
    else {
        
        senderName = @"slider";
        
    }
    
    NSLog(@"%@ sent takeFloatValueForVolumeFrom: with value %1.2f", senderName, [sender floatValue]);
     */
    float newValue = [sender floatValue];
    self.track.volume = newValue;
    [self updateUserInterface];
    
}
@end
