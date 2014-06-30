//
//  CRDrawingEvent.h
//  CRAccessoryKit
//
//  Created by Boris Remizov on 7/14/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRDrawingEvent : NSObject

@property(nonatomic,readonly) NSTimeInterval timestamp;     // Compatible with UITouch.timestamp. Seconds since system startup
@property(nonatomic,readonly) float tipPressure;            // [0; 1] normalized interval, 0 means stylus don't touch surface

- (CGPoint)locationInView:(UIView *)view;

@end
