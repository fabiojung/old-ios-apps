//
//  ImageClass.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 08/10/08.
//  Copyright 2008 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIImage (ImageClass) 

+ (UIImage *)setImage:(UIImage *)image;
+ (UIImage *)resizedImage:(UIImage *)img;
+ (UIImage *)imageFromImagesBundle:(NSString *)imageName;
@end
