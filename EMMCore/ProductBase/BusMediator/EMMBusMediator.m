//
//  EMMBusMediator.m
//  EMMCoreProj
//
//  Created by Chenly on 16/8/30.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

#import "EMMBusMediator.h"
#import "EMMBusMediatorProtocol.h"
#import "EMMBusMediatorTipViewController.h"

@implementation EMMBusMediator

static NSMutableDictionary<NSString *, id<EMMBusMediatorProtocol>> *g_connectorMap = nil;

#pragma mark - 向总控制中心注册

+ (void)registerConnector:(nonnull id<EMMBusMediatorProtocol>)connector {
    
    if (![connector conformsToProtocol:@protocol(EMMBusMediatorProtocol)]) {
        return;
    }
    
    @synchronized(g_connectorMap) {
        if (!g_connectorMap){
            g_connectorMap = [NSMutableDictionary dictionary];
        }
        
        NSString *className = NSStringFromClass([connector class]);
        if (!g_connectorMap[className]) {
            g_connectorMap[className] = connector;
        }
    }
}

#pragma mark - 通过 URL 获取 viewController 实例

+ (BOOL)canResponseURL:(nonnull NSURL *)URL {
    
    if(!g_connectorMap || g_connectorMap.count <= 0) return NO;
    
    __block BOOL success = NO;
    [g_connectorMap enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull key, id<EMMBusMediatorProtocol>  _Nonnull connector, BOOL * _Nonnull stop) {
        if([connector respondsToSelector:@selector(canOpenURL:)]){
            if ([connector canOpenURL:URL]) {
                success = YES;
                *stop = YES;
            }
        }
    }];
    return success;
}

+ (nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)URL {

    return [self viewControllerForURL:URL params:nil];
}

+ (nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)URL params:(nullable NSDictionary *)params {
    
    if(!g_connectorMap || g_connectorMap.count <= 0) return nil;
    
    NSDictionary *userParams = [self userParamsWithURL:URL params:params];
    __block UIViewController *viewController;
    
    [g_connectorMap enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull key, id<EMMBusMediatorProtocol>  _Nonnull connector, BOOL * _Nonnull stop) {
        if([connector respondsToSelector:@selector(connectToOpenURL:params:)]) {
            id returnObj = [connector connectToOpenURL:URL params:userParams];
            if(returnObj && [returnObj isKindOfClass:[UIViewController class]]) {
                
                viewController = returnObj;
                *stop = YES;
            }
        }
    }];
    return viewController;
}

/**
 * 从url获取query参数放入到参数列表中
 */
+ (NSDictionary *)userParamsWithURL:(nonnull NSURL *)URL params:(nullable NSDictionary *)params {
    
    NSArray *pairs = [URL.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *userParams = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *keyAndValue = [pair componentsSeparatedByString:@"="];
        if (keyAndValue.count == 2) {
            NSString *key = keyAndValue[0];
            NSString *value = [keyAndValue[1] stringByRemovingPercentEncoding];
            [userParams setObject:value forKey:key];
        }
    }
    [userParams addEntriesFromDictionary:params];
    return [userParams copy];
}

#pragma mark - 服务调用接口

+ (nullable id)serviceForProtocol:(nonnull Protocol *)protocol {
    
    if(!g_connectorMap || g_connectorMap.count <= 0) return nil;
    
    __block id returnServiceImp = nil;
    [g_connectorMap enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull key, id<EMMBusMediatorProtocol>  _Nonnull connector, BOOL * _Nonnull stop) {
        if([connector respondsToSelector:@selector(connectToHandleProtocol:)]){
            returnServiceImp = [connector connectToHandleProtocol:protocol];
            if(returnServiceImp){
                *stop = YES;
            }
        }
    }];
    return returnServiceImp;
}

@end
