//
//  QGCircularProgressView.m
//  QGProgressView
//
//  Created by mac on 2022/6/30.
//

#import "QGCircularProgressView.h"

@interface QGCircularProgressView ()

#pragma mark - UI

/// 进度条背景
@property (nonatomic, strong) CAShapeLayer *progressTrackLayer;

/// 进度条前景
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation QGCircularProgressView

#pragma mark - Init & Setup

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = UIColor.clearColor;
    _lineWidth = 6.0;
    _progress = 0.3;
    _progressTintColor = UIColor.whiteColor;
    _trackTintColor = [UIColor.whiteColor colorWithAlphaComponent:0.3];
    
    _progressTrackLayer = CAShapeLayer.layer;
    _progressTrackLayer.fillColor = UIColor.clearColor.CGColor;
    _progressTrackLayer.strokeColor = _trackTintColor.CGColor;
    [self.layer addSublayer:_progressTrackLayer];
    
    _progressLayer = CAShapeLayer.layer;
    _progressLayer.fillColor = UIColor.clearColor.CGColor;
    _progressLayer.strokeColor = _progressTintColor.CGColor;
    _progressLayer.strokeEnd = _progress;
    _progressLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_progressLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    CGFloat minSide = MIN(size.width, size.height);
    minSide -= _lineWidth;
    if (minSide != _progressLayer.bounds.size.width) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(minSide / 2, minSide / 2)
                                                                  radius:minSide / 2
                                                              startAngle:-M_PI_2
                                                                endAngle:M_PI_2 * 3
                                                               clockwise:YES];
        
        _progressLayer.lineWidth = _lineWidth;
        _progressLayer.path = bezierPath.CGPath;
        _progressLayer.bounds = CGRectMake(0, 0, minSide, minSide);
        
        _progressTrackLayer.lineWidth = _lineWidth;
        _progressTrackLayer.path = bezierPath.CGPath;
        _progressTrackLayer.bounds = CGRectMake(0, 0, minSide, minSide);
    }
    
    _progressTrackLayer.position = _progressLayer.position = CGPointMake(size.width / 2, size.height / 2);
}

#pragma mark - Setters

- (void)setProgress:(CGFloat)progress {
    _progress = MIN(MAX(0, progress), 1.0);
    _progressLayer.strokeEnd = _progress;
    [self setNeedsLayout];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsLayout];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    _progressLayer.strokeColor = progressTintColor.CGColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    _trackTintColor = trackTintColor;
    _progressTrackLayer.strokeColor = trackTintColor.CGColor;
}

@end
