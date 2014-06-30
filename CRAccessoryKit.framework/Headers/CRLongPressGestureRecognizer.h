//
//  CRLongPressGestureRecognizer.h
//  CRAccessoryKit
//
//  Created by Boris Remizov on 11/8/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import <CRAccessoryKit/CRGestureRecognizer.h>

@interface CRLongPressGestureRecognizer : CRGestureRecognizer

@property (nonatomic) CFTimeInterval minimumPressDuration;          // default is 0.6 sec
@property (nonatomic) CGFloat allowableMovement;                    // Default is 4 points

@end
