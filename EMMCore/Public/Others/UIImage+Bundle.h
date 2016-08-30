//
//  UIImage+Bundle.h
//  EMMCoreProj
//
//  Created by Chenly on 16/8/30.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Bundle)

+ (nullable UIImage *)imageNamed:(nonnull NSString *)name bundleName:(nullable NSString *)bundleName;
+ (nullable UIImage *)imageInEMMBundleNamed:(nonnull NSString *)name;

@end
