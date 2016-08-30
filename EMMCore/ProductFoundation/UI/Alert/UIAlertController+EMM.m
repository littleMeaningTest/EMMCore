//
//  UIAlertController+EMM.m
//  CloudHR
//
//  Created by Chenly on 16/7/25.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

#import "UIAlertController+EMM.h"

@implementation UIAlertController (EMM)

+ (void)emm_alertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle
          otherButtonTitle:(NSString *)otherButtonTitle
                    handle:(void (^)(NSInteger buttonIndex))handler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelButtonTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(0);
            }
        }];
        [alertController addAction:cancelAction];
    }
    
    if (otherButtonTitle) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(1);
            }
        }];
        [alertController addAction:otherAction];
    }
    
    UIViewController *currentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (currentViewController.presentedViewController) {
        currentViewController = currentViewController.presentedViewController;
    }
    [currentViewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)emm_alertWithTitle:(NSString *)title message:(NSString *)message {
    [self emm_alertWithTitle:title message:message cancelButtonTitle:@"确定" otherButtonTitle:nil handle:nil];
}

@end
