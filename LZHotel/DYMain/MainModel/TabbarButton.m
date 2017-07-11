//
//  TabbarButton.m
//  LZHotel
//
//  Created by Jony on 17/7/6.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "TabbarButton.h"

@implementation TabbarButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self.titleLabel setNumberOfLines:2];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        //富文本处理后不能再设置标题字体的格式
//        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        
    }
    return self;
}

//按钮按下高亮状态调用的方法
- (void)setHighlighted:(BOOL)highlighted{
}

@end
