//  RDDSignatureView.h
//
//  Created by Ryan Dignard on 8/21/14.
//  Copyright (c) 2014 Ryan Dignard. All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RDDSignatureView : UIView

/**
 Provide the desired width of the drawn line.  The default is 1.0f.
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 Provide the desired color of the drawn lines and dots.  The default is +[UIColor blackColor].
 */
@property (nonatomic, strong) UIColor* lineColor;

/**
 Provide the desired radius of the dots (a single non-moving tap).  The default is 2.0f.
 */
@property (nonatomic, assign) CGFloat dotRadius;

/**
 Call this method to clear the saved points.
 */
- (void) clearPad;

/**
 Call this method to get a snapshot of the current signature.
 */
- (UIImage*) imageOfSignature;

@end