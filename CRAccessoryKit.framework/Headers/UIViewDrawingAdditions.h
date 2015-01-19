//
//  UIViewDrawingAdditions.h
//  CRAccessoryKit
//
//  Created by Boris Remizov on 6/21/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import <CRAccessoryKit/UIResponderDrawingAdditions.h>
#import <UIKit/UIKit.h>

@interface UIView (UIViewDrawingAdditions)

- (UIView*)drawTest:(CGPoint)point withAccessory:(id<CRAccessory>)accessory;
- (BOOL)drawingInside:(CGPoint)point withAccessory:(id<CRAccessory>)accessory;

@end
