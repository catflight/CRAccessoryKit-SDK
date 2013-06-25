//
//  iPen.h
//  iPen
//
//  Created by Boris Remizov on 6/21/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import <CRAccessoryKit/CRAccessory.h>
#import <CRAccessoryKit/CRAccessoryManager.h>
#import <CRAccessoryKit/CRDrawing.h>
#import <CRAccessoryKit/UIResponderDrawingAdditions.h>
#import <CRAccessoryKit/UIViewDrawingAdditions.h>
#import <Foundation/Foundation.h>

@interface CRAccessoryKit : NSObject

+ (BOOL)start:(NSError**)error;
+ (void)stop;

@end
