//
//  QGCircularProgressView.h
//  QGProgressView
//
//  Created by mac on 2022/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 圆形进度条
@interface QGCircularProgressView : UIView

/// 进度值, 取值范围 [0, 1], 默认值: 0.0
@property(nonatomic) CGFloat progress;

/// 进度条宽度, 默认值: 6.0 (单位: 点)
@property (nonatomic, assign) CGFloat lineWidth;

/// 进度条前景色, 默认白色
@property(nonatomic, strong, nullable) UIColor* progressTintColor;

/// 进度条轨道背景色, 30%透明度白色
@property(nonatomic, strong, nullable) UIColor* trackTintColor;

/// 是否展示进度文本, 默认: NO
@property (nonatomic, assign) BOOL showProgressText;

/// 进度文本字号, 默认字号 13, Regular
@property (nonatomic, strong) UIFont *progressTextFont;

@end

NS_ASSUME_NONNULL_END
