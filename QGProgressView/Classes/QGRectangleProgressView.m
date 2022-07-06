//
//  QGRectangleProgressView.m
//  QGProgressView
//
//  Created by mac on 2022/7/6.
//

#import "QGRectangleProgressView.h"

/** 生成颜色(透明度1.0), 传入hex字符串, 格式: 0xRRGGBB */
#define QGColorHex(hexValue) [UIColor colorWithRed:((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0f\
                                                green:((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0\
                                                 blue:((CGFloat)(hexValue & 0xFF)) / 255.0 alpha:1.0]

@interface QGRectangleProgressView ()

#pragma mark - UI

/// 进度条背景
@property (nonatomic, strong) CAShapeLayer *progressTrackLayer;

/// 进度条前景
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation QGRectangleProgressView

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
    _progress = 0.0;
    _progressEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1);
    _progressTintColor = QGColorHex(0x00CE91);
    _trackTintColor = QGColorHex(0xF1F1F1);
    
    _progressTrackLayer = CAShapeLayer.layer;
    _progressTrackLayer.fillColor = UIColor.clearColor.CGColor;
    _progressTrackLayer.strokeColor = _trackTintColor.CGColor;
    _progressTrackLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_progressTrackLayer];
    
    _progressLayer = CAShapeLayer.layer;
    _progressLayer.fillColor = UIColor.clearColor.CGColor;
    _progressLayer.strokeColor = _progressTintColor.CGColor;
    _progressLayer.strokeEnd = _progress;
    _progressLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_progressLayer];
}

#pragma mark - Layout Subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    CGFloat trackWidth = size.width;
    CGFloat trackHeight = size.height;
    CGFloat progressWidth = size.width - _progressEdgeInsets.left - _progressEdgeInsets.right;
    CGFloat progressHeight = size.height - _progressEdgeInsets.top - _progressEdgeInsets.bottom;
    
    if (progressWidth != _progressLayer.bounds.size.width ||
        progressHeight != _progressLayer.bounds.size.height ||
        trackWidth != _progressTrackLayer.bounds.size.width ||
        trackHeight != _progressTrackLayer.bounds.size.height) {
        // track
        UIBezierPath *bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint:CGPointMake(trackHeight / 2, trackHeight / 2)];
        [bezierPath addLineToPoint:CGPointMake(trackWidth - trackHeight / 2, trackHeight / 2)];
        
        _progressTrackLayer.path = bezierPath.CGPath;
        _progressTrackLayer.lineWidth = trackHeight;
        
        // progress
        bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint:CGPointMake(progressHeight / 2, progressHeight / 2)];
        [bezierPath addLineToPoint:CGPointMake(progressWidth - progressHeight / 2, progressHeight / 2)];
        
        _progressLayer.path = bezierPath.CGPath;
        _progressLayer.lineWidth = progressHeight;
    }
       
    _progressTrackLayer.frame = self.bounds;
    _progressLayer.frame = CGRectMake(_progressEdgeInsets.left, _progressEdgeInsets.top, progressWidth, progressHeight);
}

#pragma mark - Setters

- (void)setProgress:(CGFloat)progress {
    _progress = MIN(MAX(0, progress), 1.0);
    _progressLayer.strokeEnd = _progress;
}

- (void)setProgressEdgeInsets:(UIEdgeInsets)progressEdgeInsets {
    _progressEdgeInsets = progressEdgeInsets;
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
