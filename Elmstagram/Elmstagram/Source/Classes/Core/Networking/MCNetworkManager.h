//
//  MCNetworkManager.h
//  Elmstagram
//
//  Created by Elmar Tampe on 24/09/14.
//  Copyright (c) 2014 Elmar Tampe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MCNetworkManager : NSObject

+ (void)uploadImage:(UIImage *)image
       successBlock:(void (^)(NSURL * url))successBlock
       failureBlock:(void (^)(NSError *error))failureBlock;

@end
