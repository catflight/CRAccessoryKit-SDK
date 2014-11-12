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
@class CRDrawing;

@interface UIResponder (UIResponderDrawingAdditions)

- (void)stylus:(CRAccessory*)accessory didStartDrawing:(CRDrawing*)drawing;
- (void)stylus:(CRAccessory*)accessory continuesDrawing:(CRDrawing*)drawing;
- (void)stylus:(CRAccessory*)accessory didEndDrawing:(CRDrawing*)drawing;

@end
