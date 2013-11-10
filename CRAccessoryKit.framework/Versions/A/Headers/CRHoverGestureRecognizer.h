//
//  CRHoverGestureRecognizer.h
//  CRAccessoryKit
//
//  Created by Boris Remizov on 11/8/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import <CRAccessoryKit/CRGestureRecognizer.h>

@interface CRHoverGestureRecognizer : CRGestureRecognizer

@property (nonatomic) CFTimeInterval minimumHoverDuration;          // default is 1.0 sec
@property (nonatomic) CGFloat allowableMovement;                    // default is 10 points

@end
