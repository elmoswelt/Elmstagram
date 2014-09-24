//
//  MCFilterCollectionViewCell.m
//  Elmstagram
//
//  Created by Elmar Tampe on 24/09/14.
//  Copyright (c) 2014 Elmar Tampe. All rights reserved.
//

#import "MCFilterCollectionViewCell.h"


@interface MCFilterCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation MCFilterCollectionViewCell


// ------------------------------------------------------------------------------------------
#pragma mark - Initializer
// ------------------------------------------------------------------------------------------
- (instancetype)initWithFrame:(CGRect)rect
{
    if ((self = [super initWithFrame:rect]))
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, rect.size.height)];
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.43].CGColor;
        self.imageView.layer.borderWidth = 1.0;
        self.imageView.layer.cornerRadius = 3.0;
        
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.imageView];
    }
    
    return self;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Reuse Identifier
// ------------------------------------------------------------------------------------------
+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([MCFilterCollectionViewCell class]);
}


// ------------------------------------------------------------------------------------------
#pragma mark - Custom Setter
// ------------------------------------------------------------------------------------------
- (void)setCellIndex:(NSUInteger)cellIndex
{
    _cellIndex = cellIndex;
    
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%lu.png", cellIndex]];
}

@end
