//
//  CRFrameBufferRenderer.h
//  Calibrator
//
//  Created by Boris Remizov on 10/16/13.
//  Copyright (c) 2013 Cregle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CRFrameBufferRenderer <NSObject>

- (void)beginDraw;
- (void)endDraw;

@end
