//
//  MCMainViewController.m
//  Elmstagram
//
//  Created by Elmar Tampe on 24/09/14.
//  Copyright (c) 2014 Elmar Tampe. All rights reserved.
//

#import "MCMainViewController.h"
#import "MCNetworkManager.h"
#import "MCFilterPickerControllerViewController.h"

#import "UIView+Extensions.h"

// ------------------------------------------------------------------------------------------

static const CGFloat kSpacer = 10.0;


// ------------------------------------------------------------------------------------------

@interface MCMainViewController () <UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate,
                                    UIActionSheetDelegate,
                                    MCFilterPickerControllerViewControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *originalImage;

@property (nonatomic, strong) MCFilterPickerControllerViewController *filterPicker;

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
    self.filterPicker = [[MCFilterPickerControllerViewController alloc] init];
    
    [self addChildViewController:self.filterPicker];
    [self.view addSubview:self.filterPicker.view];
    [self.filterPicker didMoveToParentViewController:self];
    self.filterPicker.delegate = self;
    
    self.filterPicker.view.bottom = self.view.height - kSpacer - self.filterPicker.view.height;
    self.filterPicker.view.width = self.view.width;
}



- (void)setupFilterDescriptionLabel
{
    CGRect rect = CGRectMake(kSpacer, 15.0, self.view.frame.size.width - 20.0, 30.0);
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.bottom = self.imageView.bottom + kSpacer;
    label.text = @"Choose a filter";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
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
    self.filterPicker.sourceImage = self.originalImage;
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


// ------------------------------------------------------------------------------------------
#pragma mark - MCFilterPickerControllerViewControllerDelegate
// ------------------------------------------------------------------------------------------
- (void)filterPickerControllerViewController:(MCFilterPickerControllerViewController *)filterPickerControllerViewController didFinishApplyingFilterWithResultImage:(UIImage *)image
{
    self.imageView.image = image;
}
@end
