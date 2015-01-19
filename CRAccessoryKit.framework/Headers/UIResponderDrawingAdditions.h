//
//  UIResponder+CRExtension.h
//  iPen
//
//  Created by Boris Remizov on 6/21/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import <CRAccessoryKit/CRDrawingEvent.h>
#import <UIKit/UIKit.h>

@protocol CRAccessory;
@class CRDrawing;

@interface UIResponder (UIResponderDrawingAdditions)

- (void)stylus:(id<CRAccessory>)accessory didStartDrawing:(CRDrawing*)drawing;
- (void)stylus:(id<CRAccessory>)accessory continuesDrawing:(CRDrawing*)drawing;
- (void)stylus:(id<CRAccessory>)accessory didEndDrawing:(CRDrawing*)drawing;

@end
