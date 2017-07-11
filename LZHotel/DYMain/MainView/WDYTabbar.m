//
//  WDYTabbar.m
//  LZHGRControl
//
//  Created by Jony on 17/4/23.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "WDYTabbar.h"

@interface WDYTabbar ()
/**
 * 当前选中的按钮
 */
@property (nonatomic, weak) UIButton *selectedBtn;

@end

@implementation WDYTabbar


- (instancetype)initWithFrame:(CGRect)frame{
  
    if (self = [super initWithFrame:frame]) {
        
        //系统tabbar本来的颜色无法
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0 alpha:1];
        
    }
    return  self;
}

#pragma mark -- 添加按钮
-(void)addTabbarButtonWithChineseName:(NSString *)name_zh andEnglishName:(NSString *)name_en{
    
    //使用自定义的按钮类型创建按钮
    UIButton *button = [TabbarButton buttonWithType:UIButtonTypeCustom];
    
    //字符串处理
    NSString *titleStr = [NSString stringWithFormat:@"%@\n%@", name_zh, [name_en uppercaseString]];

    //设置按钮状态
    NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithAttributedString:[self createdAttributedTitleWithString:titleStr andButtonState:UIControlStateNormal]];
    [button setAttributedTitle:normalTitle forState:UIControlStateNormal];

    NSAttributedString *selectedTitle = [[NSAttributedString alloc] initWithAttributedString:[self createdAttributedTitleWithString:titleStr andButtonState:UIControlStateSelected]];
    [button setAttributedTitle:selectedTitle forState:UIControlStateSelected];
    
    //监听事件
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    
    //绑定tag，tag绑定要在addSubview的方法之前
    button.tag = self.subviews.count;
    
    //添加按钮到自定义的tabBarView上
    [self addSubview:button];
    
    //设置默认选中
    if (button.tag == 0) {
        [self btnClick:button];
    }
    
}



/**
 created Attributed Title

 @param string Title with string
 @param state UIControlState
 @return MutableAttributedString
 */
-(NSMutableAttributedString *) createdAttributedTitleWithString:(NSString *)string andButtonState:(UIControlState)state{
    
    //创建可变的富文本
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    //设置不同行字符的大小
    NSRange range = [string rangeOfString:@"\n"];
    if (range.location != NSNotFound) {
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36.0] range:NSMakeRange(0, range.location)];
    }
    
    //根据状态设置字体颜色
    if (state == UIControlStateNormal) {
         [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedStr.length)];
    }else if (state == UIControlStateSelected) {
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(0, attributedStr.length)];
    }

    
    return attributedStr;
    
}


#pragma mark -- 自动布局放置按钮
-(void)layoutSubviews{
    [super layoutSubviews];

    CGFloat btnW = 80;
    CGFloat btnH = self.bounds.size.height-10;
    CGFloat initialX  = self.bounds.size.width/4 + 50;
  
    for (UIButton *btn in self.subviews) {
        CGFloat btnIntX = (btnW+20) * btn.tag + initialX;
        btn.frame = CGRectMake(btnIntX, 10.0, btnW, btnH);
    }
    
}

-(void)btnClick:(UIButton *)btn{
    
    //一点击通知代理
    if ([self.delegate respondsToSelector:@selector(tabbar:didSelectedFrom:to:)]) {
        [self.delegate tabbar:self didSelectedFrom:self.selectedBtn.tag to:btn.tag];
    }

    self.selectedBtn.selected = NO;
    
    //设置当前选中
    btn.selected = YES;
    self.selectedBtn = btn;
    
}


@end

