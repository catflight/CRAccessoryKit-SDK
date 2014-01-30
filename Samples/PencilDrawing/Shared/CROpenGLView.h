//
//  CROpenGLView.h
//  Shared
//
//  Created by Boris Remizov on 11/5/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import "CRFrameBufferRenderer.h"
#import <OpenGLES/ES1/gl.h>
#import <UIKit/UIKit.h>

@class CROpenGLView;

@protocol CROpenGLViewRenderer <NSObject>

- (void)openGLView:(CROpenGLView*)view didChangeScaleFactor:(CGFloat)scaleFactor;
- (void)openGLViewRenderContent:(CROpenGLView*)view inRect:(CGRect)rect;

@end

@interface CROpenGLView : UIView<CRFrameBufferRenderer>

@property (nonatomic, readonly) EAGLContext* context;
@property (nonatomic, readonly) GLint backingWidth;
@property (nonatomic, readonly) GLint backingHeight;

@property (nonatomic, assign) IBOutlet id<CROpenGLViewRenderer>renderer;

- (id)initWithRenderer: (id<CROpenGLViewRenderer>)renderer;

@end
