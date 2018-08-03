//
//  ProgressBarView.h
//  WordFun
//
//  Created by 刘鹏i on 2018/7/10.
//  Copyright © 2018年 musjoy. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ProgressBarView : UIView
@property (nonatomic, assign) CGFlot progress;
@property (nonatomic, copy) void(^gameOver)(void);

/*
 由于重置进度为满状态时，会自带填充满的动画，所以这里重置后，再重新计时需要延迟一会儿执行，效果会更好
 
 示例：
 [self.viewProgress resetProgress];
 
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self.viewProgress animtionContinue];
 });
 
 */

/// 重置进度条为完整状态码
- (void)resetProgress;

/// 暂停进度
- (void)animtionPuased;

/// 继续、开始进度
- (void)animtionContinue;
@end
