//
//  UIResponder+CRExtension.h
//  iPen
//
//  Created by Boris Remizov on 6/21/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import <CRAccessoryKit/CRDrawingEvent.h>
#import <UIKit/UIKit.h>

@class CRAccessory;

@interface UIResponder (UIResponderDrawingAdditions)

- (void)drawingsBegan:(NSArray*)drawingEvents withAccessory:(CRAccessory*)accessory;
- (void)drawingsMoved:(NSArray*)drawingEvents withAccessory:(CRAccessory*)accessory;
- (void)drawingsEnded:(NSArray*)drawingEvents withAccessory:(CRAccessory*)accessory;

#if 0

- (void)buttonDown:(NSUInteger)button ofAccessory:(CRAccessory*)accessory;
- (void)buttonUp:(NSUInteger)button ofAccessory:(CRAccessory*)accessory;

#endif

@end
