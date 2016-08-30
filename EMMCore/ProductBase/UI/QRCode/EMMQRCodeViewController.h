//
//  EMMQRCodeViewController.h
//  EMMKitDemo
//
//  Created by Chenly on 16/7/5.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EMMQRCodeViewController;

@protocol EMMQRCodeViewControllerDelegate <NSObject>

- (void)emm_QRCodeViewController:(EMMQRCodeViewController *)viewController didFinishScanningQRCode:(NSString *)code;

@end

@interface EMMQRCodeViewController : UIViewController

@property (nonatomic, weak) id<EMMQRCodeViewControllerDelegate> delegate;

- (void)startScanning;

@end
