//
//  CRTapGestureRecognizer.h
//  CRAccessoryKit
//
//  Created by Boris Remizov on 11/8/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import <CRAccessoryKit/CRGestureRecognizer.h>

@interface CRTapGestureRecognizer : CRGestureRecognizer

@property (nonatomic) NSUInteger numberOfTapsRequired;          // Default is 2. The number of taps required to match
@property (nonatomic) NSTimeInterval maximumTapInterval;        // Default is 0.3 seconds

@end
