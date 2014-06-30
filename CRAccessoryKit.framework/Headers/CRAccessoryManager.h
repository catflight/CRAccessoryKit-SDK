//
//  CRAccessoryManager.h
//  CRAccessoryKit
//
//  Created by Boris Remizov on 4/21/13.
//  Copyright (c) 2013 Cregle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const CRAccessoryConnectedNotification;
extern NSString* const CRAccessoryDisconnectedNotification;


@class CRAccessory;
@class CRGestureRecognizer;

@interface CRAccessoryManager : NSObject

@property (nonatomic, readonly, copy) NSSet* connectedAccessories;
@property (nonatomic, readonly, copy) NSSet* gestureRecognizers;

@property (nonatomic) BOOL automaticallyRejectsPalmWhileDrawing;
@property (nonatomic) BOOL showsHoveringMarks;
@property (nonatomic) BOOL sendsEditingActions;                     // if set, corresponding messages (save:, undo:, redo:, erase:) will be sent to app's firstResponder

@property (nonatomic, assign) UIResponder* firstResponder;          // if set, object that receives All drawing and side button events (bypass of UIResponder chain)

+ (CRAccessoryManager*)sharedManager;

- (BOOL)addGestureRecognizer:(CRGestureRecognizer*)gestureRecognizer;
- (void)removeGestureRecognizer:(CRGestureRecognizer*)gestureRecognizer;

@end
