//
//  EMMBusMediatorTipViewController.h
//  EMMCoreProj
//
//  Created by Chenly on 16/8/30.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EMMBusMediatorTip) {
    EMMBusMediatorTipSuccess = 0,
    EMMBusMediatorTipParamsError,
    EMMBusMediatorTipNotSupportURL,
    EMMBusMediatorTipCustom,
};

@interface EMMBusMediatorTipViewController : UIViewController

@property (nonatomic, readonly) EMMBusMediatorTip errorType;
@property (nonatomic, readonly, nullable) id errorInfo;
+ (nullable instancetype)tipViewControllerWithErrorType:(EMMBusMediatorTip)errorType errorInfo:(nullable id)errorInfo;
+ (nullable instancetype)tipViewControllerWithErrorTitle:(nullable NSString *)title errorDetail:(nullable NSString *)detail;

@end
