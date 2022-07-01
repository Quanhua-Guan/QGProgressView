//
//  QGCircularProgressView.m
//  QGProgressView
//
//  Created by mac on 2022/6/30.
//

#import "QGCircularProgressView.h"
#import <CoreText/CoreText.h>

@interface UIImage (GDProgressView)
@end
@implementation UIImage (GDProgressView)

- (UIImage *)gdpv_tintedImageWithColor:(UIColor *)tintColor
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];

    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return tintedImage;
}

@end

@interface QGCircularProgressView ()

#pragma mark - UI

/// 进度条背景
@property (nonatomic, strong) CAShapeLayer *progressTrackLayer;

/// 进度条前景
@property (nonatomic, strong) CAShapeLayer *progressLayer;

/// 进度条文字
@property (nonatomic, strong) UILabel *progressLabel;

/// 提示用户正在加载中的图层
@property (nonatomic, strong) CALayer *loadingLayer;

/// 提示用户正在加载中的图层的遮罩图层 (mask)
@property (nonatomic, strong) CAShapeLayer *loadingLayerMask;

#pragma mark - Other

/// 提示用户正在加载中的图片
@property (nonatomic, strong) UIImage *loadingImage;

/// 旋转加载中提示图层的定时器
@property (nonatomic, strong) CADisplayLink *loadingDisplayLink;

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
    _progress = 0.0;
    _progressTintColor = UIColor.whiteColor;
    _trackTintColor = [UIColor.whiteColor colorWithAlphaComponent:0.3];
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{
        UIFontDescriptorFeatureSettingsAttribute: @{
            UIFontFeatureTypeIdentifierKey: @(kNumberSpacingType),
            UIFontFeatureSelectorIdentifierKey: @(kMonospacedNumbersSelector),
        },
    }];
    _progressTextFont = [UIFont fontWithDescriptor:fontDescriptor size:13];
    
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
    
    _progressLabel = [[UILabel alloc] init];
    _progressLabel.backgroundColor = UIColor.clearColor;
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    _progressLabel.font = _progressTextFont;
    _progressLabel.textColor = _progressTintColor;
    _progressLabel.hidden = !_showProgressText;
    [self addSubview:_progressLabel];
    
    _loadingLayerMask = CAShapeLayer.layer;
    _loadingLayerMask.fillColor = UIColor.clearColor.CGColor;
    _loadingLayerMask.strokeColor = UIColor.whiteColor.CGColor;
    _loadingLayerMask.strokeStart = 0.125;
    _loadingLayerMask.strokeEnd = 1;
    _loadingLayerMask.lineCap = kCALineCapRound;
    
    _loadingLayer = CALayer.layer;
    _loadingLayer.mask = _loadingLayerMask;
    NSString *bundlePath = [[NSBundle bundleForClass:self.class] pathForResource:@"QGProgressView" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    _loadingImage = [UIImage imageNamed:@"loading_background.png" inBundle:bundle compatibleWithTraitCollection:nil];
    _loadingLayer.contents = (__bridge id)_loadingImage.CGImage;
    _loadingLayer.contentsGravity = kCAGravityResize;
    [self.layer addSublayer:_loadingLayer];
    
    _loadingDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [_loadingDisplayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:UITrackingRunLoopMode];
    [_loadingDisplayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSDefaultRunLoopMode];
    _loadingDisplayLink.paused = YES;
}

#pragma mark - Layout Subviews

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
        
        _loadingLayer.bounds = CGRectMake(0, 0, minSide + _lineWidth, minSide + _lineWidth);
        
        _loadingLayerMask.frame = CGRectMake(_lineWidth / 2, _lineWidth / 2, minSide, minSide);
        _loadingLayerMask.lineWidth = _lineWidth;
        _loadingLayerMask.path = bezierPath.CGPath;
    }
    
    _progressLabel.frame = self.bounds;
    _loadingLayer.position = _progressTrackLayer.position = _progressLayer.position = CGPointMake(size.width / 2, size.height / 2);
    
    _loadingDisplayLink.paused = _progress > 0;
}

#pragma mark - Dealloc

- (void)dealloc {
    [_loadingDisplayLink invalidate];
}

#pragma mark - DisplayLink

- (void)handleDisplayLink:(CADisplayLink *)displayLink {
    CGFloat angle = displayLink.duration * M_PI * 2.0;
    CATransform3D transorm = CATransform3DRotate(_loadingLayer.transform, angle, 0, 0, 1);
    _loadingLayer.transform = transorm;
}

#pragma mark - Setters

- (void)setProgress:(CGFloat)progress {
    _progress = MIN(MAX(0, progress), 1.0);
    _progressLayer.strokeEnd = _progress;
    _progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(progress * 100)];
    [self setNeedsLayout];
    
    if (_progress == 0) {
        if (_loadingDisplayLink.isPaused) {
            _loadingDisplayLink.paused = NO;
        }
        _loadingLayer.hidden = NO;
        _progressLayer.hidden = YES;
        _progressLabel.hidden = YES;
    } else {
        if (!_loadingDisplayLink.paused) {
            _loadingDisplayLink.paused = YES;
        }
        _loadingLayer.hidden = YES;
        _progressLayer.hidden = NO;
        _progressLabel.hidden = NO;
    }
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsLayout];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    _progressLayer.strokeColor = progressTintColor.CGColor;
    _progressLabel.textColor = progressTintColor;
    
    _loadingImage = [_loadingImage gdpv_tintedImageWithColor:progressTintColor];
    _loadingLayer.contents = (__bridge id)_loadingImage.CGImage;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    _trackTintColor = trackTintColor;
    _progressTrackLayer.strokeColor = trackTintColor.CGColor;
}

- (void)setShowProgressText:(BOOL)showProgressText {
    _showProgressText = showProgressText;
    _progressLabel.hidden = !showProgressText;
}

- (void)setProgressTextFont:(UIFont *)progressTextFont {
    _progressTextFont = progressTextFont;
    _progressLabel.font = _progressTextFont;
}

@end
