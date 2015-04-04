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
	CRSideButtonActionUnknown = -1,
	CRSideButtonActionNone,
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


@protocol CRAccessory

@property (nonatomic, readonly) NSString* name;

@property (nonatomic, readonly) NSString* identifier;
@property (nonatomic, readonly) NSString* penIdentifier;

@property (nonatomic, readonly) UIScreen* screen;                       // screen accessory attached to

@property (nonatomic, readonly) float powerLevel;                       // [0; 1], or CRPowerUndefined

@property (nonatomic, readonly) CRButtonState buttonState;              // bitmask of pressed buttons (bit0 is usually side button)
@property (nonatomic, readonly) CRSideButtonAction sideButtonAction;

@property (nonatomic, readonly) CRPairingState pairingState DEPRECATED_ATTRIBUTE;

@end


@interface CRAccessory : NSObject<CRAccessory>

@end
