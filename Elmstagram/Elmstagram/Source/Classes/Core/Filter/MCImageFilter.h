//
//  MCImageFilter.h
//  Elmstagram
//
//  Created by Elmar Tampe on 24/09/14.
//  Copyright (c) 2014 Elmar Tampe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MCImageFilter : NSObject

+ (UIImage *)blurredImageWithImage:(UIImage *)sourceImage;

+ (UIImage *)colorInvertedImageWithImage:(UIImage *)sourceImage;

+ (UIImage *)sharpendImageWithImage:(UIImage *)sourceImage;

+ (UIImage *)sepiaImageWithImage:(UIImage *)sourceImage;

+ (UIImage *)colorPosterizeImageWithImage:(UIImage *)sourceImage;

@end
