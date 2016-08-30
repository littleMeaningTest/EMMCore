//
//  UIImage+Bundle.m
//  EMMCoreProj
//
//  Created by Chenly on 16/8/30.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

#import "UIImage+Bundle.h"

@implementation UIImage (Bundle)

+ (nullable UIImage *)imageNamed:(nonnull NSString *)name bundleName:(nullable NSString *)bundleName {
    
    if ([bundleName hasSuffix:@".bundle"]) {
        bundleName = [bundleName stringByDeletingPathExtension];
    }
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

+ (nullable UIImage *)imageInEMMBundleNamed:(nonnull NSString *)name {
    return [UIImage imageNamed:name bundleName:@"emmcore"];
}

@end
