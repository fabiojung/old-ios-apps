//
//  ImageClass.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 08/10/08.
//  Copyright 2008 iTouchFactory. All rights reserved.
//

#import "ImageClass.h"

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight) {
    
	float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);

}

@implementation UIImage (ImageClass)

+ (UIImage *)setImage:(UIImage *)image {
	
	UIImage *img = [self resizedImage:image];
	
	int w = 64;
    int h = 64;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, w, h);
	addRoundedRectToPath(context, rect, 6, 6);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    free(CGBitmapContextGetData(context));
	CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	colorSpace = nil;
	context = nil;
	UIImage *newImage = [UIImage imageWithCGImage:imageMasked] ;
	CGImageRelease(imageMasked);
	imageMasked = nil;
	return newImage;
}

+ (UIImage *)resizedImage:(UIImage *)img {
	CGImageRef imageRef = [img CGImage];
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
	CGRect thumbRect = CGRectMake(0.0, 0.0, 64.0, 64.0);
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
	
	CGContextRef bitmap = CGBitmapContextCreate(
												NULL,
												thumbRect.size.width,		
												thumbRect.size.height,		
												CGImageGetBitsPerComponent(imageRef),	
												4 * thumbRect.size.width,	
												CGImageGetColorSpace(imageRef),
												alphaInfo
												);
	
	
	CGContextDrawImage(bitmap, thumbRect, imageRef);
	CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [UIImage imageWithCGImage:ref];
	CGContextRelease(bitmap);	
	CGImageRelease(ref);
	return result;
}

+ (UIImage *)imageFromImagesBundle:(NSString *)imageName {
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
}
@end
