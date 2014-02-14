//
//  CTTMarkupParser.m
//  CoreTextTest
//
//  Created by stone win on 2/13/14.
//  Copyright (c) 2014 stone win. All rights reserved.
//

#import "CTTMarkupParser.h"
#import <CoreText/CoreText.h>

@implementation CTTMarkupParser

- (id)init
{
    self = [super init];
    if (self)
    {
        self.font = @"ArialMT";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor redColor];
        self.strokeWidth = 0;
        self.images = [[NSMutableArray alloc] init];
    }
    return self;
}

// Callbacks
static void deallocCallback(void *ref)
{
    if (ref)
    {
        CFRelease((CFTypeRef)ref);
    }
}

static CGFloat ascentCallback(void *ref)
{
    NSString *ascent = ((NSString *)[(__bridge NSDictionary *)ref objectForKey:@"height"]);
    return [ascent floatValue];
}

static CGFloat descentCallback(void *ref)
{
    NSString *descent = ((NSString *)[(__bridge NSDictionary *)ref objectForKey:@"descent"]);
    return [descent floatValue];
}

static CGFloat widthCallback(void *ref)
{
    NSString *width = ((NSString *)((__bridge NSDictionary *)ref)[@"width"]);
    return [width floatValue];
}

- (void)appendAttributesFor:(NSMutableAttributedString *)aString withMarkup:(NSString *)markup chunks:(NSArray *)chunks
{
    for (NSTextCheckingResult *b in chunks)
    {
        NSArray *parts = [[markup substringWithRange:b.range] componentsSeparatedByString:@"<"];
        
        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)self.font, 24, NULL);
        
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               (__bridge id)self.color.CGColor, kCTForegroundColorAttributeName,
                               (__bridge id)fontRef, kCTFontAttributeName,
                               (__bridge id)self.strokeColor.CGColor, kCTStrokeColorAttributeName,
                               @(self.strokeWidth), kCTStrokeWidthAttributeName, nil];
        
        [aString appendAttributedString:[[NSAttributedString alloc] initWithString:parts[0] attributes:attrs]];
        
        CFRelease(fontRef);
        
        if ([parts count] > 1)
        {
            NSString *tag = parts[1];
            if ([tag hasPrefix:@"font"])
            {
                // stroke
                NSRegularExpression *secondRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=strokeColor=\")\\w+" options:0 error:NULL];
                [secondRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    if ([[tag substringWithRange:result.range] isEqualToString:@"none"])
                    {
                        self.strokeWidth = 0;
                    }
                    else
                    {
                        self.strokeWidth = -3;
                        SEL colorSel = NSSelectorFromString([NSString stringWithFormat:@"%@Color", [tag substringWithRange:result.range]]);
                        self.strokeColor = [UIColor performSelector:colorSel];
                    }
                }];
                
                // color
                NSRegularExpression *colorRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=color=\")\\w+" options:0 error:NULL];
                [colorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    SEL colorSel = NSSelectorFromString([NSString stringWithFormat:@"%@Color", [tag substringWithRange:result.range]]);
                    self.color = [UIColor performSelector:colorSel];
                }];
                
                // face
                NSRegularExpression *faceRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=face=\")[^\"]+" options:0 error:NULL];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    self.font = [tag substringWithRange:result.range];
                }];
            }
            
            if ([tag hasPrefix:@"img"])
            {
                __block NSNumber* width = [NSNumber numberWithInt:0];
                __block NSNumber* height = [NSNumber numberWithInt:0];
                __block NSString* fileName = @"";
                
                //width
                NSRegularExpression* widthRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=width=\")[^\"]+" options:0 error:NULL];
                [widthRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    width = [NSNumber numberWithInt: [[tag substringWithRange: match.range] intValue] ];
                }];
                
                //height
                NSRegularExpression* faceRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=height=\")[^\"]+" options:0 error:NULL];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    height = [NSNumber numberWithInt: [[tag substringWithRange:match.range] intValue]];
                }];
                
                //image
                NSRegularExpression* srcRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=src=\")[^\"]+" options:0 error:NULL];
                [srcRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    fileName = [tag substringWithRange: match.range];
                }];
                
                //add the image for drawing
                [self.images addObject:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  width, @"width",
                  height, @"height",
                  fileName, @"fileName",
                  [NSNumber numberWithInt: [aString length]], @"location",
                  nil]
                 ];
                
                //render empty space for drawing the image in the text //1
                CTRunDelegateCallbacks callbacks;
                callbacks.version = kCTRunDelegateVersion1;
                callbacks.getAscent = ascentCallback;
                callbacks.getDescent = descentCallback;
                callbacks.getWidth = widthCallback;
                callbacks.dealloc = deallocCallback;
                
                NSDictionary* imgAttr = [NSDictionary dictionaryWithObjectsAndKeys: //2
                                         width, @"width",
                                         height, @"height",
                                         nil];
                
                CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(imgAttr)); //3
                NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        //set the delegate
                                                        (__bridge id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                                        nil];
                
                //add a space to the text so that it can call the delegate
                [aString appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:attrDictionaryDelegate]];
            }
        }
    }
}

- (NSAttributedString *)attrStringFromMarkup:(NSString *)markup
{
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"(.*?)(<[^>]+>|\\Z)" options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray *chunks = [regex matchesInString:markup options:0 range:NSMakeRange(0, [markup length])];
    [self appendAttributesFor:aString withMarkup:markup chunks:chunks];
    
    return aString;
}

@end
