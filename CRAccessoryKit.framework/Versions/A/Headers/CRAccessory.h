//
//  CRAccessory.h
//  Calibrator
//
//  Created by Boris Remizov on 4/21/13.
//  Copyright (c) 2013 Cregle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern float const CRPowerUndefined;

@interface CRAccessory : NSObject

@property (nonatomic, readonly) NSString* identifier;
@property (nonatomic, readonly) UIScreen* screen;

@property (nonatomic, readonly) float penPowerLevel;
@property (nonatomic, readonly) float receiverPowerLevel;

@property (nonatomic, readonly) NSUInteger buttonState;

@end
