//
//  XMOpenGL.m
//  Shared
//
//  Created by Boris Remizov on 11/14/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import "CROpenGL.h"
#import <OpenGLES/ES1/gl.h>
#import <vector>

void glClearWithColor (CGColorRef color)
{
	static GLfloat vertexColors[4];
	const CGFloat* colorComponents = CGColorGetComponents(color);
	switch (CGColorGetNumberOfComponents(color))
	{
		case 4:		// RGBA
			vertexColors[0] = colorComponents[0];
			vertexColors[1] = colorComponents[1];
			vertexColors[2] = colorComponents[2];
			vertexColors[3] = colorComponents[3];
			break;
			
		case 2:		// Grayscale
			vertexColors[0] = colorComponents[0];
			vertexColors[1] = colorComponents[0];
			vertexColors[2] = colorComponents[0];
			vertexColors[3] = colorComponents[1];
			break;

		case 0:		// crear color
			vertexColors[0] = 0;
			vertexColors[1] = 0;
			vertexColors[2] = 0;
			vertexColors[3] = 0;
			break;
			
		default:
			NSLog(@"Unsupported number of components %d in color space", (int)CGColorGetNumberOfComponents(color));
			return;
	}
	glClearColor(vertexColors[0], vertexColors[1], vertexColors[2], vertexColors[3]);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

static GLfloat gVertexColors[16384 * 4];
static int gVertextColorsCount = 0;

void glDefineColor (CGColorRef color, int numberOfVertexes)
{
	numberOfVertexes = MIN((sizeof(gVertexColors)/sizeof(*gVertexColors)) / 4, numberOfVertexes);
	
	const CGFloat* colorComponents = CGColorGetComponents(color);
	switch (CGColorGetNumberOfComponents(color))
	{
		case 4:		// RGBA
			gVertexColors[0] = colorComponents[0];
			gVertexColors[1] = colorComponents[1];
			gVertexColors[2] = colorComponents[2];
			gVertexColors[3] = colorComponents[3];
			break;
			
		case 2:		// Grayscale
			gVertexColors[0] = colorComponents[0];
			gVertexColors[1] = colorComponents[0];
			gVertexColors[2] = colorComponents[0];
			gVertexColors[3] = colorComponents[1];
			break;
			
		default:
			NSLog(@"Unsupported number of components %d in color space", (int)CGColorGetNumberOfComponents(color));
			return;
	}
	
	for (int index = 1; index < numberOfVertexes; index++)
		memcpy(gVertexColors + index * 4, gVertexColors, sizeof(*gVertexColors) * 4);
	
	gVertextColorsCount = numberOfVertexes;
	
	glEnableClientState(GL_COLOR_ARRAY);
	glColorPointer(4, GL_FLOAT, 0, gVertexColors);
}

void glFillRect (CGRect rect)
{
	const GLfloat squareVertices[] =
	{
		(GLfloat)rect.origin.x, (GLfloat)rect.origin.y,
		(GLfloat)(rect.origin.x + rect.size.width), (GLfloat)rect.origin.y,
		(GLfloat)rect.origin.x, (GLfloat)(rect.origin.y + rect.size.height),
		(GLfloat)(rect.origin.x + rect.size.width), (GLfloat)(rect.origin.y + rect.size.height)
	};
	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(2, GL_FLOAT, 0, squareVertices);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

void glFillTriangle (CGPoint vertex1, CGPoint vertex2, CGPoint vertex3)
{
	const GLfloat vertices[] =
	{
		(GLfloat)vertex1.x, (GLfloat)vertex1.y,
		(GLfloat)vertex2.x, (GLfloat)vertex2.y,
		(GLfloat)vertex3.x, (GLfloat)vertex3.y
	};
	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	
	glDrawArrays(GL_TRIANGLES, 0, 3);
}

void glDrawLine (CGPoint begin, CGPoint end)
{
	const GLfloat lineVertices[] =
	{
		(GLfloat)begin.x, (GLfloat)begin.y,
		(GLfloat)end.x, (GLfloat)end.y
	};
	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(2, GL_FLOAT, 0, lineVertices);
	
	glDrawArrays(GL_LINES, 0, 2);
}

void glFillRoundedRect (CGRect rect, CGFloat radius, int corners)
{
	// draw left side
	for (CGFloat x = 0; x <= radius; x++)
	{
		CGFloat y = sqrt(radius * radius - (radius - x) * (radius -x));
		
		CGFloat leftTop = (corners & glCornerLeftTop) ? rect.origin.y + radius - y : rect.origin.y;
		CGFloat leftBottom = (corners & glCornerLeftBottom) ? rect.origin.y + rect.size.height - radius + y : rect.origin.y + rect.size.height;
		glDrawLine(CGPointMake(rect.origin.x + x, leftTop), CGPointMake(rect.origin.x+x, leftBottom));
	}
	
	// draw body
	glFillRect(CGRectMake(rect.origin.x+radius, rect.origin.y, rect.size.width - 2 * radius, rect.size.height));
	
	// draw right side
	CGFloat sideOffset = rect.origin.x + rect.size.width - radius;
	for (CGFloat x = 0; x <= radius; x++)
	{
		CGFloat y = sqrt(radius * radius - x * x);
		
		CGFloat leftTop = (corners & glCornerRightTop) ? rect.origin.y + radius - y : rect.origin.y;
		CGFloat leftBottom = (corners & glCornerRightBottom) ? rect.origin.y + rect.size.height - radius + y : rect.origin.y + rect.size.height;
		glDrawLine(CGPointMake(sideOffset + x, leftTop), CGPointMake(sideOffset + x, leftBottom));
	}
}

#define DEG2RAD(x) ((float)x * M_PI / 180.0f)
void glDrawCircle(CGPoint center, CGFloat radius)
{
	int N = 4 * M_PI * radius;
	float* vertexes = (float*)alloca(sizeof(float) * 2 * (N+2));
	
	vertexes[0] = center.x;
	vertexes[1] = center.y;
	int i;
	for (i = 2; i < 2 * N; i += 2)
	{
		float degInRad = M_PI * i / N;
		vertexes[i] = cosf(degInRad)*radius + center.x;
		vertexes[i+1] = sinf(degInRad)*radius + center.y;
	}
	vertexes[i] = vertexes[2];
	vertexes[i+1] = vertexes[3];

	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(2, GL_FLOAT, 0, vertexes);
	glDrawArrays(GL_TRIANGLE_FAN, 0, N+1);
}

void glDrawRect(CGRect rect)
{
	const GLfloat squareVertices[] =
	{
		static_cast<GLfloat>(rect.origin.x), static_cast<GLfloat>(rect.origin.y),
		static_cast<GLfloat>(rect.origin.x + rect.size.width), static_cast<GLfloat>(rect.origin.y),
		static_cast<GLfloat>(rect.origin.x + rect.size.width), static_cast<GLfloat>(rect.origin.y + rect.size.height),
		static_cast<GLfloat>(rect.origin.x), static_cast<GLfloat>(rect.origin.y + rect.size.height)
	};
	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(2, GL_FLOAT, 0, squareVertices);
	
	glDrawArrays(GL_LINE_LOOP, 0, 4);
}

static std::vector<GLfloat> gPolyLineVertexes;

void glPolyLineBegin()
{
	// implicitly close previous sequence
	glPolyLineEnd();
}

void glPolyLineAddSegment(CGPoint begin, CGPoint end)
{
    gPolyLineVertexes.push_back(begin.x);
    gPolyLineVertexes.push_back(begin.y);
    gPolyLineVertexes.push_back(end.x);
    gPolyLineVertexes.push_back(end.y);
}

void glPolyLineEnd()
{
	if (![NSThread isMainThread])
		[NSException raise:@"GLException" format:@"Draw only main thread please"];
	
	if (gPolyLineVertexes.size() > 0)
	{
		// extrapolate colors for first segment on other ones
		for (int index = 2; index < gPolyLineVertexes.size() / 2; index += 2)
			memcpy(gVertexColors + index * 4, gVertexColors, sizeof(*gVertexColors) * 4 * 2);
		
		glEnableClientState(GL_COLOR_ARRAY);
		glColorPointer(4, GL_FLOAT, 0, gVertexColors);
		
		glEnableClientState(GL_VERTEX_ARRAY);
		glVertexPointer(2, GL_FLOAT, 0, &gPolyLineVertexes[0]);
		glDrawArrays(GL_LINES, 0, gPolyLineVertexes.size() / 2);
		
		gPolyLineVertexes.clear();
	}
}
