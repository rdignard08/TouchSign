//  RDDSignatureView.m
//
//  Created by Ryan Dignard on 8/21/14.
//  Copyright (c) 2014 Ryan Dignard. All rights reserved.

#import "RDDSignatureView.h"
#import <Availability.h>

@interface RDDSignatureView ()

@property (nonatomic, strong) NSMutableArray* committedTouches;
@property (nonatomic, strong) NSMutableArray* currentTouches;
@property (nonatomic, strong) UIButton* clearButton;

@end

static CGRect __dotRect;

@implementation RDDSignatureView

- (NSMutableArray*) committedTouches {
    if (!_committedTouches) {
        _committedTouches = [NSMutableArray array];
    }
    return _committedTouches;
}

- (UIButton*) clearButton {
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_clearButton addTarget:self action:@selector(clearPad) forControlEvents:UIControlEventTouchUpInside];
        _clearButton.backgroundColor = self.lineColor;
        _clearButton.frame = CGRectMake(20.0f, 20.0f, 40.0f, 40.0f);
        _clearButton.layer.cornerRadius = MIN(_clearButton.frame.size.width, _clearButton.frame.size.height) / 2.0f;
    }
    return _clearButton;
}

- (UIColor*) lineColor {
    if (!_lineColor) {
        _lineColor = [UIColor blackColor];
    }
    return _lineColor;
}

- (void) setShowsClearButton:(BOOL)showsClearButton {
    _showsClearButton = showsClearButton;
    if (_showsClearButton) {
        [self addSubview:self.clearButton];
    } else {
        [self.clearButton removeFromSuperview];
    }
}

- (void) setDotRadius:(CGFloat)dotRadius {
    _dotRadius = dotRadius;
    __dotRect = CGRectMake(-_dotRadius, -_dotRadius, 2*_dotRadius, 2*_dotRadius);
}

- (void) __setup {
    self.exclusiveTouch = YES;
    _lineWidth = 1.0f;
    self.dotRadius = 2.0f;
    self.showsClearButton = YES;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __setup];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self __setup];
    }
    return self;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        [self __setup];
    }
    return self;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    self.currentTouches = [NSMutableArray arrayWithObject:NSStringFromCGPoint([[touches anyObject] locationInView:self])];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint thePoint = CGPointZero;
    for (UITouch* touch in touches) {
        CGPoint aPoint = [touch locationInView:self];
        thePoint.x += aPoint.x;
        thePoint.y += aPoint.y;
    }
    thePoint.x = thePoint.x / (CGFloat)touches.count;
    thePoint.y = thePoint.y / (CGFloat)touches.count;
    
    [self.currentTouches addObject:NSStringFromCGPoint(thePoint)];
    [self setNeedsDisplay];
}

- (void) touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
    [self touchesEnded:touches withEvent:event];
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    [self.committedTouches addObject:self.currentTouches];
    self.currentTouches = nil;
    [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
        
    NSMutableArray* touchSegments = [NSMutableArray arrayWithArray:self.committedTouches];
    if (self.currentTouches) {
        [touchSegments addObject:self.currentTouches];
    }
        
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);
    CGFloat red, green, blue, alpha;
    [self.lineColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
    
    for (NSArray* segment in touchSegments) {
        CGPoint firstPoint = CGPointFromString(segment[0]);
        if (segment.count == 1) { /* a single point, draw a dot */
                CGContextFillEllipseInRect(context, CGRectOffset(__dotRect, firstPoint.x, firstPoint.y));
        } else { /* 2 or more, draw a series of line segments */
                CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
                for (NSUInteger i = 1; i < segment.count; i++) {
                    CGPoint nextPoint = CGPointFromString(segment[i]);
                    CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
                }
                CGContextStrokePath(context);
        }
    }
}

- (void) clearPad {
    self.committedTouches = nil;
    [self setNeedsDisplay];
}

- (UIImage*) imageOfSignature {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, [UIScreen mainScreen].scale);
#ifdef __IPHONE_7_0
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
#else
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
#endif
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
