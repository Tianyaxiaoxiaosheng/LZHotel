//
//  RoomLightsView.m
//  LZHotel
//
//  Created by Jony on 17/7/11.
//  Copyright © 2017年 yavatop. All rights reserved.
//

//子控件的frame相关参数
static CGFloat subViewW = 150;
static CGFloat subViewH = 110;
static CGFloat initialX = 15;
static CGFloat initialY = 30;

//每行的个数
static NSInteger count_line = 5;
//页面最大加载数量
static NSInteger count_max = 15;




#import "RoomLightsView.h"

@interface RoomLightsView ()<WDYSwitchDelegate>

@end

@implementation RoomLightsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


- (void)setLightsArray:(NSArray *)lightsArray {
    for (NSDictionary *lighDic in lightsArray) {
        WDYSwitch *sw = [[WDYSwitch alloc] init];
        
        //设置代理
        sw.delegate = self;
        
        sw.name_zh = [lighDic objectForKey:@"name_zh"];
        sw.name_en = [lighDic objectForKey:@"name_en"];
        
        //开关状态预置为关
        sw.isOpen = NO;
        
        //检查下tag值是否已存在
        NSInteger tag = [[lighDic objectForKey:@"id"] integerValue];
        if (![self viewWithTag:tag]) {
            
            sw.tag = tag;
            [self addSubview:sw];
        }
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    //记录当前位置
    NSInteger index = 0;
    
    for (UIView *subView in self.subviews) {

        if (index < count_max) {
            CGFloat viewIntY = subViewH * (index/count_line) + initialY;
            CGFloat viewIntX = subViewW * ((index++)%count_line) + initialX;
            subView.frame = CGRectMake(viewIntX, viewIntY, subViewW, subViewH);
        }
    }

}

- (void)allLightsSwitch:(BOOL)isOpen{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[WDYSwitch class]]) {
            ((WDYSwitch *)subView).isOpen = isOpen;
        }
    }
}

#pragma mark - WDYSwitchDelegate
- (void)clickedWDYSwitch:(WDYSwitch *)sw {
    
    //test
//    NSLog(@"sw tag = %ld", sw.tag);
    sw.isOpen = !sw.isOpen;
}

@end
