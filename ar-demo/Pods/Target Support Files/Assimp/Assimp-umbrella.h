#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "pushpack1.h"
#import "poppack1.h"
#import "pstdint.h"
#import "scene.h"
#import "texture.h"
#import "mesh.h"
#import "aabb.h"
#import "light.h"
#import "camera.h"
#import "material.h"
#import "types.h"
#import "defs.h"
#import "config.h"
#import "anim.h"
#import "metadata.h"
#import "cimport.h"
#import "importerdesc.h"
#import "vector3.h"
#import "vector3.inl"
#import "vector2.h"
#import "vector2.inl"
#import "color4.h"
#import "color4.inl"
#import "matrix3x3.h"
#import "matrix3x3.inl"
#import "matrix4x4.h"
#import "matrix4x4.inl"
#import "quaternion.h"
#import "quaternion.inl"

FOUNDATION_EXPORT double AssimpVersionNumber;
FOUNDATION_EXPORT const unsigned char AssimpVersionString[];

