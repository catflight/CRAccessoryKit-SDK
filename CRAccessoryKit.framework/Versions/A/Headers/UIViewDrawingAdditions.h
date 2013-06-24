//
//  UIViewDrawingAdditions.h
//  CRAccessoryKit
//
//  Created by Boris Remizov on 6/21/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import <CRAccessoryKit/CRDrawing.h>
#import <CRAccessoryKit/UIResponderDrawingAdditions.h>
#import <UIKit/UIKit.h>

@interface UIView (UIViewDrawingAdditions)

- (UIView*)drawTest:(CGPoint)point withDrawind:(CRDrawing*)drawing;
- (BOOL)drawingInside:(CGPoint)point withDrawing:(CRDrawing*)drawing;

@end
