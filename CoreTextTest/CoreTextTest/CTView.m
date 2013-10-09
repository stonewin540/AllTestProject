//
//  CTView.m
//  CoreTextTest
//
//  Created by stone win on 1/5/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "CTView.h"

@implementation CTView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGSize) measureFrame: (CTFrameRef) frame
{
	CGPathRef framePath = CTFrameGetPath(frame);
	CGRect frameRect = CGPathGetBoundingBox(framePath);
    
	CFArrayRef lines = CTFrameGetLines(frame);
	CFIndex numLines = CFArrayGetCount(lines);
    
	CGFloat maxWidth = 0;
	CGFloat textHeight = 0;
    
	// Now run through each line determining the maximum width of all the lines.
	// We special case the last line of text. While we've got it's descent handy,
	// we'll use it to calculate the typographic height of the text as well.
	CFIndex lastLineIndex = numLines - 1;
	for(CFIndex index = 0; index < numLines; index++)
	{
		CGFloat ascent, descent, leading, width;
		CTLineRef line = (CTLineRef) CFArrayGetValueAtIndex(lines, index);
		width = CTLineGetTypographicBounds(line, &ascent,  &descent, &leading);
        
		if(width > maxWidth)
		{
			maxWidth = width;
		}
        
		if(index == lastLineIndex)
		{
			// Get the origin of the last line. We add the descent to this
			// (below) to get the bottom edge of the last line of text.
			CGPoint lastLineOrigin;
			CTFrameGetLineOrigins(frame, CFRangeMake(lastLineIndex, 1), &lastLineOrigin);
            
			// The height needed to draw the text is from the bottom of the last line
			// to the top of the frame.
			textHeight =  CGRectGetMaxY(frameRect) - lastLineOrigin.y + descent;
		}
	}
    
	// For some text the exact typographic bounds is a fraction of a point too
	// small to fit the text when it is put into a context. We go ahead and round
	// the returned drawing area up to the nearest point.  This takes care of the
	// discrepencies.
	return CGSizeMake(ceil(maxWidth), ceil(textHeight));
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    NSString *string = @"Yeah, just core text test!";
    CTFontRef font = CTFontCreateWithName(CFSTR("abc"), 50, NULL);
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                (__bridge id)(font), kCTFontAttributeName, nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string
                                                                     attributes:attributes];
    CGPathRef path = CGPathCreateWithRect(rect, NULL);
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(frame, context);
    
    
    CGPoint origin;
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &origin);
    

    CGSize size = [self measureFrame:frame];
    CGRect lineFrame = CGRectMake(origin.x, rect.size.height - size.height - 1, size.width, size.height);
    NSLog(@"frame: %@", NSStringFromCGRect(lineFrame));
    [[UIColor greenColor] setFill];
    CGContextFillRect(context, lineFrame);
    
    CGPathRelease(path);
}

@end
