//
//  CRGestureRecognizer.h
//  CRAccessoryKit
//
//  Created by Boris Remizov on 11/7/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum CRGestureRecognizerState
{
    CRGestureRecognizerStateReady = 0,
    CRGestureRecognizerStateBegan,
    CRGestureRecognizerStateChanged,
    CRGestureRecognizerStateEnded,
    CRGestureRecognizerStateFailed

} CRGestureRecognizerState;


@interface CRGestureRecognizer : NSObject

@property(nonatomic,readonly) CRGestureRecognizerState state;
@property(nonatomic, getter=isEnabled) BOOL enabled;
@property(nonatomic,readonly) UIView *view;
@property(nonatomic) BOOL cancelsDrawingsInView;

- (id)initWithView:(UIView*)view;

- (void)addTarget:(id)target action:(SEL)action;
- (void)removeTarget:(id)target action:(SEL)action;

- (CGPoint)locationInView:(UIView*)view;

@end
