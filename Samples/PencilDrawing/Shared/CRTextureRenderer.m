//
//  CRTextureRenderer.m
//  Calibrator
//
//  Created by Boris Remizov on 10/16/13.
//  Copyright (c) 2013 Cregle Inc. All rights reserved.
//

#import "CRTextureRenderer.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@implementation CRTextureRenderer
{
	GLuint _framebuffer;
	int _drawingCounter;
}

#define kMaxTextureSize 2048

- (id)initWithContentSize:(CGSize)contentSize
{
	BOOL sizeToFit = NO;
	int i = 0;
	
	// calculate nearest power of two to bound contentSize
	int width = contentSize.width;
	if((width != 1) && (width & (width - 1))) {
		i = 1;
		while((sizeToFit ? 2 * i : i) < width)
			i *= 2;
		width = i;
	}

	int height = contentSize.height;
	if((height != 1) && (height & (height - 1))) {
		i = 1;
		while((sizeToFit ? 2 * i : i) < height)
			i *= 2;
		height = i;
	}

	while((width > kMaxTextureSize) || (height > kMaxTextureSize)) {
		width /= 2;
		height /= 2;
		contentSize.width *= 0.5;
		contentSize.height *= 0.5;
	}
	
	self = [super initWithData:NULL pixelFormat:kTexture2DPixelFormat_RGBA8888 pixelsWide:width pixelsHigh:height contentSize:contentSize];
	if (!self)
		return nil;
	
	glGenFramebuffersOES(1, &_framebuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _framebuffer);
	
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, self.name, 0);

    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
	
	// unbind frame buffer
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, 0);

	// erase with white color
	[self beginDraw];
	glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	[self endDraw];
	
	return self;
}

- (void)beginDraw
{
	if (0 == _drawingCounter)
	{
		glBindFramebuffer(GL_FRAMEBUFFER_OES, _framebuffer);
		glViewport(0, 0, self.contentSize.width, self.contentSize.height);

		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glOrthof(0, self.contentSize.width, 0, self.contentSize.height, -1, 1);
	}
	_drawingCounter++;
}

- (void)endDraw
{
	_drawingCounter--;
	if (0 == _drawingCounter)
	{
		glBindFramebuffer(GL_FRAMEBUFFER_OES, 0);
	}
}

- (void)dealloc
{
    if (_framebuffer)
        glDeleteFramebuffers(1, &_framebuffer);
}

@end
