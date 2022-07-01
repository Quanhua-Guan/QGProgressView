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
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __block BOOL up = YES;
        [[NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            progressView.progress += (up ? 1 : -1) * 0.01;
            
            if (progressView.progress >= 1.0 || progressView.progress <= 0.0) {
                up = !up;
            }
        }] fire];
    });
    
    // create loading background image
    CAGradientLayer *gradientLayer = CAGradientLayer.layer;
    gradientLayer.frame = CGRectMake(0, 0, 54, 54);
    if (@available(iOS 12.0, *)) {
        gradientLayer.type = kCAGradientLayerConic;
    } else {
        // Fallback on earlier versions
    }
    gradientLayer.startPoint = CGPointMake(0.5, 0.5);
    gradientLayer.endPoint = CGPointMake(0.625, 0);
    gradientLayer.locations = @[
        @1.0,
        @0.25,
        @0,
    ];
    gradientLayer.colors = @[
        (__bridge id) ((UIColor.whiteColor).CGColor),
        (__bridge id) ((UIColor.clearColor).CGColor),
        (__bridge id) UIColor.clearColor.CGColor,
    ];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(54, 54), NO, UIScreen.mainScreen.scale);
    {
        [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        image = nil;
    }
    UIGraphicsEndImageContext();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
