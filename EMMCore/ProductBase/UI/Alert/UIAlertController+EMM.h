//
//  UIAlertController+EMM.h
//  CloudHR
//
//  Created by Chenly on 16/7/25.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (EMM)

+ (void)emm_alertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle
          otherButtonTitle:(NSString *)otherButtonTitle
                    handle:(void (^)(NSInteger buttonIndex))handler;

+ (void)emm_alertWithTitle:(NSString *)title message:(NSString *)message;

@end
