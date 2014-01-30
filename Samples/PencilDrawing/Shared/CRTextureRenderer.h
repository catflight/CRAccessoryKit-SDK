//
//  CRTextureRenderer.h
//  Calibrator
//
//  Created by Boris Remizov on 10/16/13.
//  Copyright (c) 2013 Cregle Inc. All rights reserved.
//

#import "texture2d.h"
#import "CRFrameBufferRenderer.h"
#import <Foundation/Foundation.h>

@interface CRTextureRenderer : Texture2D<CRFrameBufferRenderer>

@property (nonatomic, readonly) CGSize size;

- (id)initWithContentSize:(CGSize)contentSize;

@end
