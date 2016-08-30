//
//  EMMBusMediator.h
//  EMMCoreProj
//
//  Created by Chenly on 16/8/30.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EMMBusMediatorProtocol;

@interface EMMBusMediator : NSObject

/**
 *  向总控制中心注册
 */
+ (void)registerConnector:(nonnull id<EMMBusMediatorProtocol>)connector;


/**
 *  URL 能否响应
 */
+ (BOOL)canResponseURL:(nonnull NSURL *)URL;

/**
 *  通过 URL 获取 viewController 实例
 */
+ (nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)URL;
+ (nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)URL params:(nullable NSDictionary *)params;

/**
 *  根据 protocol 获取服务实例
 */
+ (nullable id)serviceForProtocol:(nonnull Protocol *)protocol;

@end
