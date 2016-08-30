//
//  ViewController.m
//  EMMCoreProj
//
//  Created by Chenly on 16/8/30.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

#import "ViewController.h"
#import "EMMBusMediatorTipViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action:(id)sender {

    EMMBusMediatorTipViewController *tipViewController = [EMMBusMediatorTipViewController tipViewControllerWithErrorType:EMMBusMediatorTipNotSupportURL errorInfo:[NSURL URLWithString:@"scheme://modula/what?p1=10"]];
    [self presentViewController:tipViewController animated:YES completion:nil];
}

@end
