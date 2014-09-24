//
//  MCImageFilter.m
//  Elmstagram
//
//  Created by Elmar Tampe on 24/09/14.
//  Copyright (c) 2014 Elmar Tampe. All rights reserved.
//

#import "MCImageFilter.h"


@implementation MCImageFilter


// ------------------------------------------------------------------------------------------
#pragma mark - Gaussian Blurr Filter
// ------------------------------------------------------------------------------------------
+ (UIImage *)blurredImageWithImage:(UIImage *)sourceImage
{
    return [MCImageFilter filteredImage:sourceImage withFilterName:@"CIGaussianBlur"];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Color Invert Filter
// ------------------------------------------------------------------------------------------
+ (UIImage *)colorInvertedImageWithImage:(UIImage *)sourceImage
{
    return [MCImageFilter filteredImage:sourceImage withFilterName:@"CIColorInvert"];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Sharpen Filter 
// ------------------------------------------------------------------------------------------
+ (UIImage *)sharpendImageWithImage:(UIImage *)sourceImage
{
    return [MCImageFilter filteredImage:sourceImage withFilterName:@"CISharpenLuminance"];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Sepia Filter
// ------------------------------------------------------------------------------------------
+ (UIImage *)sepiaImageWithImage:(UIImage *)sourceImage
{
    return [MCImageFilter filteredImage:sourceImage withFilterName:@"CISepiaTone"];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Color Posterize Filter
// ------------------------------------------------------------------------------------------
+ (UIImage *)colorPosterizeImageWithImage:(UIImage *)sourceImage
{
    return [MCImageFilter filteredImage:sourceImage withFilterName:@"CIColorPosterize"];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Generic Filter
// ------------------------------------------------------------------------------------------
+ (UIImage *)filteredImage:(UIImage *)sourceImage withFilterName:(NSString *)filterName
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:sourceImage];
    
    CIFilter *filter = [CIFilter filterWithName:filterName];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    
    return [UIImage imageWithCGImage:[[self filterContext] createCGImage:filter.outputImage
                                                                fromRect:filter.outputImage.extent]];
}


// ------------------------------------------------------------------------------------------
#pragma mark - CIIImageContext
// ------------------------------------------------------------------------------------------
+ (CIContext *)filterContext
{
    static CIContext *context = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        context = [CIContext contextWithOptions:nil];
    });
    
    return context;
}

@end
