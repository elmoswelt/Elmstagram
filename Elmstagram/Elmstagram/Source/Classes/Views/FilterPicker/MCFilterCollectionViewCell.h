//
//  MCFilterCollectionViewCell.h
//  Elmstagram
//
//  Created by Elmar Tampe on 24/09/14.
//  Copyright (c) 2014 Elmar Tampe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCFilterCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) NSUInteger cellIndex;

+ (NSString *)reuseIdentifier;

@end
