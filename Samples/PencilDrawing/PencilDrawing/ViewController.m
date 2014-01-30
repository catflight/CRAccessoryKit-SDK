//
//  ViewController.m
//  PencilDrawing
//
//  Created by Boris Remizov on 1/30/14.
//  Copyright (c) 2014 Cregle. All rights reserved.
//

#import "ViewController.h"
#import "CRTextureRenderer.h"
#import "texture2d.h"
#import "CROpenGLView.h"
#import "CROpenGL.h"

@interface ViewController ()<CROpenGLViewRenderer>

@property (nonatomic, strong) CRTextureRenderer* textureRenderer;
@property (nonatomic, strong) Texture2D* backgroundTexture;
@property (nonatomic, readonly) CROpenGLView* view;

// line drawing support
@property (nonatomic) CGPoint lastLocation;
@property (nonatomic) CGFloat lastPressure;

@end

@implementation ViewController

@dynamic view;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - drawing primitives

- (void)drawIncrementally:(NSArray*)events
{
	[self.textureRenderer beginDraw];
	
    glDisable(GL_TEXTURE_2D);
	glDisable(GL_DEPTH_TEST);
    glEnable(GL_ALPHA);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	for (CRDrawingEvent* drawing in events)
	{
		CGPoint location = [drawing locationInView:self.view];
		
        // convert UIKit coordinates to OpenGL coordinates
		location.x *= self.view.window.screen.scale;
		location.y *= self.view.window.screen.scale;
        
        if (CGPointEqualToPoint(_lastLocation, CGPointZero))
        {
            glDefineColor([[UIColor blackColor] colorWithAlphaComponent:drawing.tipPressure].CGColor, 96);
            glDrawCircle(location, 1);
        }
        else
        {
            glDefineColor([[UIColor darkGrayColor] colorWithAlphaComponent:_lastPressure].CGColor, 2);
            glDefineColor([[UIColor darkGrayColor] colorWithAlphaComponent:drawing.tipPressure].CGColor, 1);
            glDrawLine(location, self.lastLocation);
        }

        self.lastLocation = location;
        self.lastPressure = drawing.tipPressure;
    }
	
	[self.textureRenderer endDraw];
}

- (void)endDrawingIncrementally:(NSArray*)events
{
    [self drawIncrementally:events];

    self.lastPressure = 0;
    self.lastLocation = CGPointZero;
}

- (void)eraseIncrementally:(NSArray*)events
{
	// erase to background
	[self.textureRenderer beginDraw];
	
	CGPoint vertexes[6] = {
		{.5, .5},
		{0, 0},
		{1, 0},
		{1, 1},
		{0, 1},
		{0, 0}
	};
	
	glDisable(GL_DEPTH_TEST);
	glEnable(GL_ALPHA);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glDefineColor([[UIColor whiteColor] colorWithAlphaComponent:0.0f].CGColor,6);
    glDefineColor([[UIColor whiteColor] colorWithAlphaComponent:1.0f].CGColor, 1);

	for (id drawingEventOrTouch in events)
	{
        CGPoint origin = [drawingEventOrTouch locationInView:self.view];
        // convert UIKit coordinates to OpenGL coordinates
		origin.x *= self.view.window.screen.scale;
		origin.y *= self.view.window.screen.scale;
        [self.backgroundTexture drawAtPoint:CGPointMake(origin.x, origin.y)];
	}
	
	[self.textureRenderer endDraw];

    // end line drawing sequence if was active
    self.lastPressure = 0;
    self.lastLocation = CGPointZero;
}

- (void)clear
{
    [self.textureRenderer beginDraw];
	
	CGRect rect = CGRectMake(0, 0, [self.view backingWidth], [self.view backingHeight]);
	
	glDisable(GL_DEPTH_TEST);
	glDisable(GL_BLEND);
	
	glDefineColor([UIColor whiteColor].CGColor, 5);
	for (CGFloat x = 0; x < rect.size.width; x += self.backgroundTexture.pixelsWide)
		for (CGFloat y = 0; y < rect.size.height; y += self.backgroundTexture.pixelsHigh)
			[self.backgroundTexture drawAtPoint:CGPointMake(x + self.backgroundTexture.pixelsWide / 2, y + self.backgroundTexture.pixelsHigh / 2)];
	
	[self.textureRenderer endDraw];

    // end line drawing sequence if was active
    self.lastPressure = 0;
    self.lastLocation = CGPointZero;
}

#pragma mark - CROpenGLViewRenderer methods

// callback invoked on changing/showing view on screen (once per screen change)
- (void)openGLView:(CROpenGLView*)view didChangeScaleFactor:(CGFloat)scaleFactor
{
	// initialize texture renderbuffer
	self.textureRenderer = [[CRTextureRenderer alloc] initWithContentSize:CGSizeMake(view.bounds.size.width * scaleFactor, view.bounds.size.height * scaleFactor)];
	self.backgroundTexture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"background_tile"]];
    
	[self clear];
}

// callback invoked on redraw actions
- (void)openGLViewRenderContent:(CROpenGLView*)view inRect:(CGRect)rect
{
	[view beginDraw];
	
	glDisable(GL_DEPTH_TEST);
	glDisable(GL_BLEND);
	glDefineColor([UIColor whiteColor].CGColor, 5);
    // show texture buffer
	[self.textureRenderer drawInRect: CGRectMake(0, 0, view.backingWidth, view.backingHeight)];
    
	[view endDraw];
}

#pragma mark - UIResponder's Cregle extension methods invoked by stylus

// these methods are being invoked on main thread, synchronized with display link
// the events array contains events accured between screen refresh

- (void)drawingsBegan:(NSArray *)events withAccessory:(CRAccessory *)accessory
{
	if (0x01 & accessory.buttonState)
        // side button pressed
        [self eraseIncrementally:events];
    else
        [self drawIncrementally:events];

    // overloaded method of CROpenGLView
	[self.view setNeedsDisplay];
}

- (void)drawingsMoved:(NSArray *)events withAccessory:(CRAccessory *)accessory
{
	if (0x01 & accessory.buttonState)
    {
        // side button pressed
        [self eraseIncrementally:events];
    }
    else
        [self drawIncrementally:events];

    // overloaded method of CROpenGLView
	[self.view setNeedsDisplay];
}

- (void)drawingsEnded:(NSArray *)events withAccessory:(CRAccessory *)accessory
{
	if (0x01 & accessory.buttonState)
        // side button pressed
        [self eraseIncrementally:events];
    else
        [self endDrawingIncrementally:events];
    
    // overloaded method of CROpenGLView
	[self.view setNeedsDisplay];
}

#pragma mark - Standard UIRsponder's methods invoked on touches

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
    
    // UITouch and CRDrawingEvent classes have compatible interfaces, bad to hardcast but possible)
    [self eraseIncrementally:[touches allObjects]];
	
    // overloaded method of CROpenGLView
	[self.view setNeedsDisplay];
}

@end
