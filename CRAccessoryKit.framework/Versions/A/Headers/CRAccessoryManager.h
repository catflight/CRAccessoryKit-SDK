//
//  CRAccessoryManager.h
//  Calibrator
//
//  Created by Boris Remizov on 4/21/13.
//  Copyright (c) 2013 Cregle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const CRAccessoryConnectedNotification;
extern NSString* const CRAccessoryDisconnectedNotification;

extern NSString* const CRAccessoryNotificationAccessoryKey;


@interface CRAccessoryManager : NSObject

@property (nonatomic, readonly) NSArray* connectedAccessories;

@property (nonatomic) BOOL allowsAccessoriesTriggerStandardActions;

+ (CRAccessoryManager*)sharedManager;

@end
