//
//  UIResponder+CRExtension.h
//  iPen
//
//  Created by Boris Remizov on 6/21/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRAccessory;
@class CRDrawing;

@interface UIResponder (UIResponderDrawingAdditions)

- (void)drawingBegan:(CRDrawing*)drawing withAccessory:(CRAccessory*)accessory;
- (void)drawingMoved:(CRDrawing*)drawing withAccessory:(CRAccessory*)accessory;
- (void)drawingEnded:(CRDrawing*)drawing withAccessory:(CRAccessory*)accessory;
- (void)drawingCancelled:(CRDrawing*)drawing withAccessory:(CRAccessory*)accessory;

- (void)buttonDown:(NSUInteger)button withAccessory:(CRAccessory*)accessory;
- (void)buttonUp:(NSUInteger)button withAccessory:(CRAccessory*)accessory;

@end
