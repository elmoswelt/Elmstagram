//
//  MCFilterPickerControllerViewController.m
//  Elmstagram
//
//  Created by Elmar Tampe on 24/09/14.
//  Copyright (c) 2014 Elmar Tampe. All rights reserved.
//

#import "MCFilterPickerControllerViewController.h"
#import "MCFilterCollectionViewCell.h"
#import "MCImageFilter.h"

// ------------------------------------------------------------------------------------------

@interface MCFilterPickerControllerViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

// ------------------------------------------------------------------------------------------


@implementation MCFilterPickerControllerViewController


// ------------------------------------------------------------------------------------------
#pragma mark - View Lifecycle
// ------------------------------------------------------------------------------------------
- (void)loadView
{
    [super loadView];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 100.0)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupFilterPickerView];
}


- (void)dealloc
{
    self.collectionView.delegate = nil;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.collectionView reloadData];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Setup
// ------------------------------------------------------------------------------------------
- (void)setupFilterPickerView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:layout];
    
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.23];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[MCFilterCollectionViewCell class]
            forCellWithReuseIdentifier:[MCFilterCollectionViewCell reuseIdentifier]];
    
    [self.view addSubview:self.collectionView];
}



// ------------------------------------------------------------------------------------------
#pragma mark - UICollectionViewDataSource
// ------------------------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MCImageFilterTypeCount;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [MCFilterCollectionViewCell reuseIdentifier];
    
    MCFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                                 forIndexPath:indexPath];
    
    cell.cellIndex = indexPath.row;
    
    return cell;
}


// ------------------------------------------------------------------------------------------
#pragma mark - UICollectionViewDelegate
// ------------------------------------------------------------------------------------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self applyFilterForIndex:indexPath.row];
}


// ------------------------------------------------------------------------------------------
#pragma mark - UICollectionViewDelegateFlowLayout
// ------------------------------------------------------------------------------------------
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(85.0, 85.0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
}


// ------------------------------------------------------------------------------------------
#pragma mark - Apply Filter
// ------------------------------------------------------------------------------------------
- (void)applyFilterForIndex:(NSUInteger)index
{
    UIImage *image = nil;
    
    switch (index)
    {
        case MCImageFilterTypeBlurr:
        {
            image = [MCImageFilter blurredImageWithImage:self.sourceImage];
            break;
        }
        case MCImageFilterTypeColorInvert:
        {
            image = [MCImageFilter colorInvertedImageWithImage:self.sourceImage];
            break;
        }
        case MCImageFilterTypeSharpen:
        {
            image = [MCImageFilter sharpendImageWithImage:self.sourceImage];
            break;
        }
        case MCImageFilterTypeSepia:
        {
            image = [MCImageFilter sepiaImageWithImage:self.sourceImage];
            break;
        }
        case MCImageFilterTypeColorPosterize:
        {
            image = [MCImageFilter colorPosterizeImageWithImage:self.sourceImage];
            break;
        }
            
        default:
            break;
    }
    
    if (image == nil) return;
    
    if ([self.delegate respondsToSelector:@selector(filterPickerControllerViewController:didFinishApplyingFilterWithResultImage:)])
    {
        [self.delegate filterPickerControllerViewController:self didFinishApplyingFilterWithResultImage:image];
    }
}

@end
