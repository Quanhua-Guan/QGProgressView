//
//  QGViewController.m
//  QGProgressView
//
//  Created by 官泉华 on 06/30/2022.
//  Copyright (c) 2022 官泉华. All rights reserved.
//

#import "QGViewController.h"
#import "QGProgressView.h"

@interface QGViewController ()

@end

@implementation QGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBlueColor;
    
    
    QGCircularProgressView *progressView = [[QGCircularProgressView alloc] initWithFrame:CGRectMake(150, 200, 54, 54)];
    progressView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view addSubview:progressView];
    
    __block BOOL up = YES;
    [[NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        progressView.progress += (up ? 1 : -1) * 0.01;
        
        if (progressView.progress >= 1.0 || progressView.progress <= 0.0) {
            up = !up;
        }
    }] fire];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
