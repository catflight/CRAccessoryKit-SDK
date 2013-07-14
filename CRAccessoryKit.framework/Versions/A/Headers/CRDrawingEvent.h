//
//  CRDrawingEvent.h
//  CRAccessoryKit
//
//  Created by Boris Remizov on 7/14/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRDrawingEvent : NSObject

@property(nonatomic,readonly) NSTimeInterval timestamp;
@property(nonatomic,readonly) float tipPressure;

- (CGPoint)locationInView:(UIView *)view;

@end
