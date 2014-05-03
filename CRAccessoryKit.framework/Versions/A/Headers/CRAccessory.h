//
//  CRAccessory.h
//  CRAccessoryKit
//
//  Created by Boris Remizov on 4/21/13.
//  Copyright (c) 2013 Cregle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum CRSideButtonAction
{
	CRSideButtonActionNone = 0,
	CRSideButtonActionUndo,
	CRSideButtonActionRedo,
	CRSideButtonActionErase,
	CRSideButtonActionSave
} CRSideButtonAction;


typedef uint32_t CRButtonState;


typedef enum CRPairingState
{
    CRPairingStateUnknown = 0,
    CRPairingStatePaired,
    CRPairingStateNotPaired
} CRPairingState;


extern float const CRPowerUndefined;


@interface CRAccessory : NSObject

@property (nonatomic, readonly) NSString* identifier;
@property (nonatomic, readonly) NSString* penIdentifier;

@property (nonatomic, readonly) UIScreen* screen;

@property (nonatomic, readonly) float penPowerLevel;
@property (nonatomic, readonly) float receiverPowerLevel;

@property (nonatomic, readonly) CRButtonState buttonState;
@property (nonatomic, readonly) CRSideButtonAction sideButtonAction;

@property (nonatomic, readonly) NSTimeInterval hoveringTime;

@property (nonatomic, readonly) CRPairingState pairingState;

@end
