//
//  DBPluginDemo.m
//  DemoBundle
//
//  Created by stone win on 10/12/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "DBPluginDemo.h"

@interface DBPluginDemo ()

@property (nonatomic, copy) NSString *selectedText;

@end

@implementation DBPluginDemo

#pragma mark - Actions

- (void)showSelected:(NSMenuItem *)sender
{
    NSLog(@"%@", self.selectedText);
    
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert setMessageText:_selectedText];
    [alert runModal];
}

#pragma mark - Observers

- (void)selectionDidChange:(NSNotification *)notification
{
    if (![[notification object] isKindOfClass:[NSTextView class]]) return;
    
    NSTextView *textView = (NSTextView *)[notification object];
    NSArray *selectedRanges = [textView selectedRanges];
    if (![selectedRanges count]) return;
    
    NSRange selectedRange = [selectedRanges[0] rangeValue];
    NSString *text = textView.textStorage.string;
    self.selectedText = [text substringWithRange:selectedRange];
    NSLog(@"%@", self.selectedText);
    
    // Hello, welcome to stone's home!
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectionDidChange:) name:NSTextViewDidChangeSelectionNotification object:nil];
    
    NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (editMenuItem)
    {
        [[editMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *newMenuItem = [[NSMenuItem alloc] initWithTitle:@"What is selected" action:@selector(showSelected:) keyEquivalent:@"abc"];
        [newMenuItem setTarget:self];
        [newMenuItem setKeyEquivalentModifierMask:NSAlternateKeyMask];
        [[editMenuItem submenu] addItem:newMenuItem];
        [newMenuItem release];
    }
}

#pragma mark -

+ (id)sharedInstance
{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    [DBPluginDemo sharedInstance];
    /*
    NSLog(@"**************************Hello World");
    //10/12/13 3:03:38.226 PM Xcode[13726]: [MT] PluginLoading: Required plug-in compatibility UUID 37B30044-3B14-46BA-ABAA-F01000C27B63 for plug-in at path '~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/DemoBundle.xcplugin' not present in DVTPlugInCompatibilityUUIDs
     */
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:NSApplicationDidFinishLaunchingNotification object:nil];
    }
    return self;
}

@end
