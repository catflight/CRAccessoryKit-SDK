//
//  CRDrawing.h
//  iPen
//
//  Created by Boris Remizov on 6/21/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CRDrawingPhase) {
    CRDrawingPhaseBegan,
    CRDrawingPhaseMoved,
    CRDrawingPhaseStationary,
    CRDrawingPhaseEnded,
    CRDrawingPhaseCancelled
};


@interface CRDrawing : NSObject

@property(nonatomic,readonly) NSTimeInterval timestamp;

@property(nonatomic,readonly) CRDrawingPhase phase;

@property(nonatomic,readonly) float tipPressure;
@property(nonatomic,readonly) float previousTipPressure;

@property(nonatomic,readonly) NSIndexSet* buttonState;

- (CGPoint)locationInView:(UIView *)view;
- (CGPoint)previousLocationInView:(UIView *)view;

@end
