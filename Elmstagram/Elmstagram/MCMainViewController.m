//
//  MCMainViewController.m
//  Elmstagram
//
//  Created by Elmar Tampe on 24/09/14.
//  Copyright (c) 2014 Elmar Tampe. All rights reserved.
//

#import "MCMainViewController.h"
#import "UIView+Extensions.h"

// ------------------------------------------------------------------------------------------

static const CGFloat kSpacer = 10.0;


// ------------------------------------------------------------------------------------------

@interface MCMainViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) UIView *filterPickerView;

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
    self.filterPickerView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    
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
#pragma mark - Deallocation
// ------------------------------------------------------------------------------------------
- (void)dealloc
{
    // TODO: Ist das wirklich notwendig?
    
    self.imagePickerController.delegate = nil;
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
    NSLog(@"Upload");
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
    self.imageView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
}






@end
