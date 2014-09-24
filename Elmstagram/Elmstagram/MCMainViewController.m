//
//  MCMainViewController.m
//  Elmstagram
//
//  Created by Elmar Tampe on 24/09/14.
//  Copyright (c) 2014 Elmar Tampe. All rights reserved.
//

#import "MCMainViewController.h"
#import "MCNetworkManager.h"
#import "MCImageFilter.h"

#import "MCFilterCollectionViewCell.h"

#import "UIView+Extensions.h"

// ------------------------------------------------------------------------------------------

static const CGFloat kSpacer = 10.0;


// ------------------------------------------------------------------------------------------

@interface MCMainViewController () <UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate,
                                    UIActionSheetDelegate,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *originalImage;

@property (nonatomic, strong) UIView *filterPickerView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSURL *imageURL;

@end

// ------------------------------------------------------------------------------------------


@implementation MCMainViewController


// ------------------------------------------------------------------------------------------
#pragma mark - UIView Lifecycle
// ------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Deallocation
// ------------------------------------------------------------------------------------------
- (void)dealloc
{
    self.imagePickerController.delegate = nil;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Setup
// ------------------------------------------------------------------------------------------
- (void)setup
{
    [self setupImageView];
    [self setupFilterPickerView];
    [self setupFilterDescriptionLabel];
}


- (void)setupImageView
{
    CGRect rect = CGRectMake(kSpacer, 90.0, self.view.frame.size.width - 2.0 * kSpacer, 400.0);
    self.imageView = [[UIImageView alloc] initWithFrame:rect];
    self.imageView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.imageView];
}


- (void)setupFilterPickerView
{
    CGRect rect = CGRectMake(kSpacer, 0.0, self.view.frame.size.width - 2.0 * kSpacer, 100.0);
    self.filterPickerView = [[UIView alloc] initWithFrame:rect];
    self.filterPickerView.bottom = self.view.height - kSpacer - self.filterPickerView.height;
    self.filterPickerView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.filterPickerView.bounds
                                             collectionViewLayout:layout];

    self.collectionView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.23];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[MCFilterCollectionViewCell class]
            forCellWithReuseIdentifier:[MCFilterCollectionViewCell reuseIdentifier]];
    
    [self.filterPickerView addSubview:self.collectionView];
    [self.view addSubview:self.filterPickerView];
}



- (void)setupFilterDescriptionLabel
{
    CGRect rect = CGRectMake(kSpacer, 0.0, self.view.frame.size.width - 20.0, 30.0);
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.bottom = self.imageView.bottom + kSpacer;
    label.text = @"Choose a filter";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
}


// ------------------------------------------------------------------------------------------
#pragma mark - UICollectionViewDataSource
// ------------------------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
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


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self applyFilterForIndex:indexPath.row];
}


- (void)applyFilterForIndex:(NSUInteger)index
{
    switch (index)
    {
        case MCImageFilterTypeBlurr:
        {
            self.imageView.image = [MCImageFilter blurredImageWithImage:self.originalImage];
            break;
        }
        case MCImageFilterTypeColorInvert:
        {
            self.imageView.image = [MCImageFilter colorInvertedImageWithImage:self.originalImage];
            break;
        }
        case MCImageFilterTypeSharpen:
        {
            self.imageView.image = [MCImageFilter sharpendImageWithImage:self.originalImage];
            break;
        }
        case MCImageFilterTypeSepia:
        {
            self.imageView.image = [MCImageFilter sepiaImageWithImage:self.originalImage];
            break;
        }
        case MCImageFilterTypeColorPosterize:
        {
            self.imageView.image = [MCImageFilter colorPosterizeImageWithImage:self.originalImage];
            break;
        }
            
        default:
            break;
    }
}


// ------------------------------------------------------------------------------------------
#pragma mark - View Appearance
// ------------------------------------------------------------------------------------------
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Bar Button Actions
// ------------------------------------------------------------------------------------------
- (IBAction)didTabImagePickerBarButtonItem:(id)sender
{
    [self presentImagePickerController];
}


- (IBAction)didTabUploadBarButtonItem:(id)sender
{
    [self uploadFile];
}


// ------------------------------------------------------------------------------------------
#pragma mark - UIImagePicker
// ------------------------------------------------------------------------------------------
- (void)presentImagePickerController
{
    if (self.imagePickerController == nil)
    {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary |
                                                UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    [self presentViewController:self.imagePickerController
                       animated:YES
                     completion:nil];
}


// ------------------------------------------------------------------------------------------
#pragma mark - UIImagePickerControllerDelegate
// ------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    self.originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.imageView.image = self.originalImage;
}


- (void)uploadFile
{
    MCMainViewController __weak *weakSelf = self;
    
    [MCNetworkManager uploadImage:self.imageView.image
                     successBlock:^(NSURL *url)
    {
        weakSelf.imageURL = url;
        [weakSelf showActionSheet];
    }
                     failureBlock:^(NSError *error)
    {
        weakSelf.imageURL = nil;
        [weakSelf showActionSheet];
    }];
}


// ------------------------------------------------------------------------------------------
#pragma mark - UIActionSheet
// ------------------------------------------------------------------------------------------
- (void)showActionSheet
{
    NSString *title = self.imageURL ? @"Image upload successful! " : @"Upload error. Please try again.";
    NSString *buttonTitle = self.imageURL ? @"Open Image in Safari" : nil;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:buttonTitle, nil];
    
    [actionSheet showInView:self.view];
}


// ------------------------------------------------------------------------------------------
#pragma mark - UIActionSheetDelegate
// ------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:self.imageURL];
    }
}

@end
