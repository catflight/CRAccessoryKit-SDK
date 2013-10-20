//
//  CRAccessoryManager.h
//  Calibrator
//
//  Created by Boris Remizov on 4/21/13.
//  Copyright (c) 2013 Cregle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const CRAccessoryConnectedNotification;
extern NSString* const CRAccessoryDisconnectedNotification;

extern NSString* const CRAccessoryNotificationAccessoryKey;


@class CRAccessory;

@interface CRAccessoryManager : NSObject

@property (nonatomic, readonly, copy) NSArray* connectedAccessories;

@property (nonatomic) BOOL automaticallyRejectsPalmWhileDrawing;

@property (nonatomic) BOOL allowsHoveringEvents;
@property (nonatomic) BOOL sendsEditingActions;

@property (nonatomic, assign) UIResponder* firstResponder;

+ (CRAccessoryManager*)sharedManager;

@end
