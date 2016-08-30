//
//  EMMBusMediatorProtocol.h
//  EMMCoreProj
//
//  Created by Chenly on 16/8/30.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

@protocol EMMBusMediatorProtocol <NSObject>

- (BOOL)canOpenURL:(nonnull NSURL *)URL;

/**
 * 业务模块挂接中间件，注册自己能够处理的URL，完成url的跳转；
 * 如果url跳转需要回传数据，则传入实现了数据接收的调用者；
 *  @param URL          跳转到的URL，通常为 productScheme://connector/relativePath
 *  @param params       伴随url的的调用参数
 *  @return
 (1) UIViewController的派生实例，交给中间件present;
 (2) nil 表示不能处理;
 (3) [UIViewController notURLController]的实例，自行处理present;
 (4) [UIViewController paramsError]的实例，参数错误，无法导航;
 */
- (nullable UIViewController *)connectToOpenURL:(nonnull NSURL *)URL params:(nullable NSDictionary *)params;

/**
 * 业务模块挂接中间件，注册自己提供的service，实现服务接口的调用；
 *
 * 通过protocol协议找到组件中对应的服务实现，生成一个服务单例；
 * 传递给调用者进行protocol接口中属性和方法的调用；
 */
- (nullable id)connectToHandleProtocol:(nonnull Protocol *)serviceProtocol;

@end
