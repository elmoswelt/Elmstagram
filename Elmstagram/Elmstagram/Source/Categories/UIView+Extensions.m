//
//  UIView+Extensions.m
//
//  Created by Elmar Tampe on 7/22/12.
//  Copyright (c) 2012 Elmar Tampe. All rights reserved.
//

#import "UIView+Extensions.h"

@implementation UIView(Extensions)

// ------------------------------------------------------------------------------------------
#pragma mark - Left Position of the view
// ------------------------------------------------------------------------------------------
- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}


- (CGFloat)left
{
    return self.frame.origin.x;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Right position of the view
// ------------------------------------------------------------------------------------------
- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x += right;
    self.frame = frame;
}


- (CGFloat)right
{
    return self.frame.size.width + self.frame.origin.x ;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Top Position of the view
// ------------------------------------------------------------------------------------------
- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}


- (CGFloat)top
{
    return self.frame.origin.y;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Bottom Posiition of the view 
// ------------------------------------------------------------------------------------------
- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y += bottom;
    self.frame = frame;
}


- (CGFloat)bottom
{
    return self.frame.size.height + self.frame.origin.y;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Height of the view
// ------------------------------------------------------------------------------------------
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


- (CGFloat)height
{
    return self.frame.size.height;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Width of the view
// ------------------------------------------------------------------------------------------
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)width
{
    return self.frame.size.width;
}

@end
