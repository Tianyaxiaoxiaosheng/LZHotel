//
//  NGButton.m
//  LZHotel
//
//  Created by Jony on 17/7/7.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "NGButton.h"

@implementation NGButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self.titleLabel setNumberOfLines:2];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        //初始状态不设置，会导致不去调用setSelected方法，从而按钮背景没有样式
        [self setSelected:NO];
        
    }
    return self;
}

//按钮按下高亮状态调用的方法
- (void)setHighlighted:(BOOL)highlighted{
}

- (void)setSelected:(BOOL)selected{
    
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:192/255 green:192/255 blue:192/255 alpha:0.0];
        self.enabled = NO;
    }else {
        self.backgroundColor = [UIColor colorWithRed:192/255 green:192/255 blue:192/255 alpha:0.2];
        self.enabled = YES;
    }
}


@end
