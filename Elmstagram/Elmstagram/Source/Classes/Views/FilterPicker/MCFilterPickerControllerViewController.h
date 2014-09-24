//
//  MCFilterPickerControllerViewController.h
//  Elmstagram
//
//  Created by Elmar Tampe on 24/09/14.
//  Copyright (c) 2014 Elmar Tampe. All rights reserved.
//

#import <UIKit/UIKit.h>


// ------------------------------------------------------------------------------------------

@class MCFilterPickerControllerViewController;

@protocol MCFilterPickerControllerViewControllerDelegate <NSObject>

@optional

- (void)filterPickerControllerViewController:(MCFilterPickerControllerViewController *)filterPickerControllerViewController didFinishApplyingFilterWithResultImage:(UIImage *)image;

@end

// ------------------------------------------------------------------------------------------

@interface MCFilterPickerControllerViewController : UIViewController

@property (nonatomic, weak) id<MCFilterPickerControllerViewControllerDelegate> delegate;
@property (nonatomic, weak) UIImage *sourceImage;

@end
