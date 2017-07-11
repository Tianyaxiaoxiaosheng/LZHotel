//
//  RoomLightsView.m
//  LZHotel
//
//  Created by Jony on 17/7/11.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "RoomLightsView.h"

@implementation RoomLightsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


- (void)setLightsArray:(NSArray *)lightsArray {
    for (NSDictionary *lighDic in lightsArray) {
        WDYSwitch *sw = [[WDYSwitch alloc] init];
        sw.name_zh = [lighDic objectForKey:@"name_zh"];
        sw.name_en = [lighDic objectForKey:@"name_en"];
        
        sw.tag = [[lighDic objectForKey:@"id"] integerValue];
        
        [self addSubview:sw];
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat subViewW = 150;
    CGFloat subViewH = 110;
    CGFloat initialX  = 10;
    CGFloat initialY  = 10;
    
    NSInteger index = 0;
    
    for (UIView *subView in self.subviews) {
        
//        NSLog(@"index = %ld", index);
        
        CGFloat viewIntY = subViewH * (index/4) + initialY;
        CGFloat viewIntX = subViewW * ((index++)%4) + initialX;
       
        
        subView.frame = CGRectMake(viewIntX, viewIntY, subViewW, subViewH);
    }

}

@end
