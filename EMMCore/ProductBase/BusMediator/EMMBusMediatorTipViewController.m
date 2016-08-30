//
//  EMMBusMediatorTipViewController.m
//  EMMCoreProj
//
//  Created by Chenly on 16/8/30.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

#import "EMMBusMediatorTipViewController.h"
#import "Masonry.h"

@interface EMMBusMediatorTipViewController ()

@property (nonatomic, readwrite) EMMBusMediatorTip errorType;
@property (nonatomic, readwrite, nullable) id errorInfo;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation EMMBusMediatorTipViewController

+ (nullable instancetype)tipViewControllerWithErrorType:(EMMBusMediatorTip)errorType errorInfo:(nullable id)errorInfo {

    if (errorType == EMMBusMediatorTipSuccess) {
        return nil;
    }
    else {
        EMMBusMediatorTipViewController *viewController = [[EMMBusMediatorTipViewController alloc] init];
        viewController.errorType = errorType;
        viewController.errorInfo = errorInfo;
        return viewController;
    }
}

+ (nullable instancetype)tipViewControllerWithErrorTitle:(nullable NSString *)title errorDetail:(nullable NSString *)detail {

    EMMBusMediatorTipViewController *viewController = [[EMMBusMediatorTipViewController alloc] init];
    viewController.errorType = EMMBusMediatorTipCustom;
    viewController.titleLabel.text = title;
    viewController.detailLabel.text = detail;
    return viewController;
}

- (instancetype)init {

    if (self = [super init]) {
        
        _titleLabel = ({            
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:17.f];
            label.textColor = [UIColor blackColor];
            label.numberOfLines = 1;
            label;
        });
        _detailLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:15.f];
            label.textColor = [UIColor lightGrayColor];
            label.numberOfLines = 0;
            label;
        });
        _backButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:@"返回" forState:UIControlStateNormal];
            button;
        });
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.detailLabel];
    [self.view addSubview:self.backButton];
    
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).multipliedBy(0.2);
        make.width.lessThanOrEqualTo(self.view.mas_width).offset(-16.f * 2);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_bottom).multipliedBy(0.8f);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8.f);
        make.bottom.lessThanOrEqualTo(self.backButton.mas_top).offset(-8.f);
        make.width.lessThanOrEqualTo(self.view.mas_width).offset(-16.f * 2);
    }];
    
    if (self.errorType == EMMBusMediatorTipParamsError) {
        self.titleLabel.text = @"参数错误";
        self.detailLabel.text = [self.errorInfo description];
    }
    else if (self.errorType == EMMBusMediatorTipNotSupportURL) {
        self.titleLabel.text = @"不支持的 URL";
        self.detailLabel.text = [self.errorInfo description];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction {

    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
