//
//  CROpenGLView.m
//  Shared
//
//  Created by Boris Remizov on 11/5/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import "CROpenGLView.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES1/gl.h>
#import <QuartzCore/QuartzCore.h>

@implementation CROpenGLView
{
	// The pixel dimensions of the CAEAGLLayer
	GLint backingWidth;
	GLint backingHeight;
	
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint _framebuffer, _colorRenderbuffer;
	
	BOOL _dirty;
	BOOL _active;
	int _drawingCounter;
}

@synthesize backingHeight, backingWidth;

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (id)initWithRenderer: (id<CROpenGLViewRenderer>)renderer
{
	self = [self initWithFrame:CGRectZero];
	if (!self) return nil;
	
	self.renderer = renderer;
	_active = TRUE;

    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	[EAGLContext setCurrentContext:_context];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationExecutionModeChanged:) name:UIApplicationWillResignActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationExecutionModeChanged:) name:UIApplicationDidBecomeActiveNotification object:nil];

	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

	_active = TRUE;

	_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	[EAGLContext setCurrentContext:_context];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationExecutionModeChanged:) name:UIApplicationWillResignActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationExecutionModeChanged:) name:UIApplicationDidBecomeActiveNotification object:nil];
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (!self) return nil;
	
	_active = TRUE;
	
	_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	[EAGLContext setCurrentContext:_context];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationExecutionModeChanged:) name:UIApplicationWillResignActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationExecutionModeChanged:) name:UIApplicationDidBecomeActiveNotification object:nil];

	return self;
}

- (void)applicationExecutionModeChanged:(NSNotification*)notification
{
	if ([notification.name isEqual:UIApplicationWillResignActiveNotification])
		_active = FALSE;
	else
		_active = TRUE;
}

- (void)beginDraw
{
	if (0 == _drawingCounter)
	{
        //setting up the draw content
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, _framebuffer);
        
        glViewport(0, 0, backingWidth, backingHeight);
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
        glOrthof(0, backingWidth, backingHeight, 0, -1, 1);

        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        glDisable(GL_DEPTH_TEST);
	}
	_drawingCounter++;
}

- (void)endDraw
{
	_drawingCounter--;
	if (0 == _drawingCounter)
	{
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
        [_context presentRenderbuffer:GL_RENDERBUFFER_OES];
	}
}

- (void)setNeedsDisplay
{
	if (!_active || _dirty) return;
	_dirty = TRUE;
	dispatch_async(dispatch_get_main_queue(), ^{
        [EAGLContext setCurrentContext:_context];
		[self.renderer openGLViewRenderContent:self inRect:CGRectMake(0, 0, self.backingWidth, self.backingHeight)];
		_dirty = NO;
	});
}

- (void)setNeedsDisplayInRect:(CGRect)rect
{
	if (!_active || _dirty) return;
	_dirty = TRUE;
	dispatch_async(dispatch_get_main_queue(), ^{
        [EAGLContext setCurrentContext:_context];
        [self.renderer openGLViewRenderContent:self inRect:rect];
		_dirty = NO;
	});
}

- (void)terminate
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [EAGLContext setCurrentContext:_context];
	self.renderer = nil;

	// Tear down GL
	if (_framebuffer)
	{
		glDeleteFramebuffersOES(1, &_framebuffer);
		_framebuffer = 0;
	}
	
	if (_colorRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &_colorRenderbuffer);
		_colorRenderbuffer = 0;
	}
	
    [EAGLContext setCurrentContext:nil];
}

- (void)dealloc
{
    [self terminate];
}

- (void)layoutSubviews
{
    [EAGLContext setCurrentContext:_context];

    [self destroyFramebuffer];
    [self createFramebuffer];

    // update screen
    [self.renderer openGLView:self didChangeScaleFactor:self.contentScaleFactor];
	[self setNeedsDisplay];
    
    [super layoutSubviews];
}

- (BOOL)createFramebuffer
{
	self.contentScaleFactor = self.window.screen.scale;

    glGenFramebuffersOES(1, &_framebuffer);
    glGenRenderbuffersOES(1, &_colorRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _framebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable: (CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _colorRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);

    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

- (void)destroyFramebuffer
{
    glDeleteFramebuffersOES(1, &_framebuffer);
    _framebuffer = 0;
    glDeleteRenderbuffersOES(1, &_colorRenderbuffer);
    _colorRenderbuffer = 0;
}

@end
