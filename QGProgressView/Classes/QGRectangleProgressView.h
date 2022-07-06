//
//  QGRectangleProgressView.h
//  QGProgressView
//
//  Created by mac on 2022/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 矩形进度条
@interface QGRectangleProgressView : UIView

/// 进度值, 取值范围 [0, 1], 默认值: 0.0
@property(nonatomic) CGFloat progress;

/// 进度条四边间距, 默认值: (1, 1, 1, 1), (单位: 点)
@property (nonatomic, assign) UIEdgeInsets progressEdgeInsets;

/// 进度条前景色, 默认: #00CE91
@property(nonatomic, strong, nullable) UIColor* progressTintColor;

/// 进度条轨道背景色, 默认: #F1F1F1
@property(nonatomic, strong, nullable) UIColor* trackTintColor;

@end

NS_ASSUME_NONNULL_END
