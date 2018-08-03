//
//  ProgressBarView.m
//  WordFun
//
//  Created by 刘鹏i on 2018/7/10.
//  Copyright © 2018年 musjoy. All rights reserved.
//

#import "ProgressBarView.h"

@interface ProgressBarView ()
@property (strong, nonatomic) IBOutlet UIView *viewGradient;
@property (nonatomic, strong) CAShapeLayer *layerGradientMask;  ///< 渐变色蒙版图层
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation ProgressBarView
#pragma mark - Life Circle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadViewFromXib];
        
        [self viewConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadViewFromXib];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self viewConfig];
}

- (void)loadViewFromXib
{
    UIView *contentView = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    
    contentView.frame = self.bounds;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [self addSubview:contentView];
}

- (void)dealloc
{
    [_displayLink invalidate];
    _displayLink = nil;
}

#pragma mark - Subjoin
- (void)viewConfig
{
    // 增加layer
    _layerGradientMask = [self createLayer];

    _viewGradient.layer.mask = _layerGradientMask;
    
    // 增加定时器刷新UI
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshUI)];
    _displayLink.paused = YES;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - Action
- (void)refreshUI
{
    _layerGradientMask.strokeStart = 0;
    _layerGradientMask.strokeEnd = _progress;
    
    // 游戏失败
    if (_layerGradientMask.strokeEnd <= 0) {
        [self animtionPuased];
        if (_gameOver) {
            _gameOver();
        }
    }
}

#pragma mark - Private
/// 创建layer
- (CAShapeLayer *)createLayer
{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = _viewGradient.bounds;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.lineCap = kCALineCapRound;
    return layer;
}

/// 创建圆环路径
- (UIBezierPath *)createPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat y = _viewGradient.bounds.size.height / 2.0;
    [path moveToPoint:CGPointMake(_viewGradient.bounds.size.width, y)];
    [path addLineToPoint:CGPointMake(0, y)];
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = _viewGradient.bounds.size.height;
    return path;
}

#pragma mark - Public
- (void)resetProgress
{
    _layerGradientMask.strokeStart = 0;
    _layerGradientMask.strokeEnd = _progress;
}

- (void)animtionPuased
{
    _displayLink.paused = YES;
}

- (void)animtionContinue
{
    _displayLink.paused = NO;
}

#pragma mark - OverWrite
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _layerGradientMask.frame = _viewGradient.bounds;
    
    UIBezierPath *path = [self createPath];
    _layerGradientMask.path = path.CGPath;
    _layerGradientMask.lineWidth = _viewGradient.bounds.size.height;
}


@end
