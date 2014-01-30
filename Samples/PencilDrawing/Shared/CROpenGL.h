//
//  XMOpenGL.h
//  Shared
//
//  Created by Boris Remizov on 11/14/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#ifndef Shared_CROpenGL_h
#define Shared_CROpenGL_h

#include <CoreGraphics/CoreGraphics.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>

#ifdef __cplusplus
extern "C" {
#endif

void glDefineColor (CGColorRef color, int numberOfVertexes);

void glClearWithColor (CGColorRef color);

void glFillRect (CGRect rect);
void glFillTriangle (CGPoint vertex1, CGPoint vertex2, CGPoint vertex3);

void glDrawRect(CGRect rect);

enum
{
	glCornerLeftTop		= (1 << 0),
	glCornerRightTop	= (1 << 1),
	glCornerLeftBottom	= (1 << 2),
	glCornerRightBottom	= (1 << 3),
	
	glCornerRightSide	= (glCornerRightTop | glCornerRightBottom),
	glCornerLeftSide	= (glCornerLeftTop | glCornerLeftBottom),
	glCornerTopSide		= (glCornerLeftTop | glCornerRightTop),
	glCornerBottomSide	= (glCornerLeftBottom | glCornerRightBottom),
	
	glCornerAll			= (glCornerLeftTop | glCornerRightTop | glCornerLeftBottom | glCornerRightBottom)
};
	
void glFillRoundedRect (CGRect rect, CGFloat radius, int corners);
	
void glDrawLine (CGPoint begin, CGPoint end);
void glDrawCircle(CGPoint center, CGFloat radius);

void glPolyLineBegin();
void glPolyLineAddSegment(CGPoint begin, CGPoint end);
void glPolyLineEnd();
	
#ifdef __cplusplus
}
#endif

#endif
