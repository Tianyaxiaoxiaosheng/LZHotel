//
//  NGView.m
//  LZHGRControl
//
//  Created by Jony on 17/4/7.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "NGView.h"

@interface NGView ()

@property (nonatomic, weak) UIButton *currentSelectedBtn;

@end

@implementation NGView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = [UIColor colorWithRed:192/255 green:192/255 blue:192/255 alpha:0.2];
        self.layer.cornerRadius = 18;
        self.layer.masksToBounds = YES;
        
    }
    
    return self;
}

#pragma mark -- 添加按钮
-(void)addNGViewButtonWithRoomInfoDictionary:(NSDictionary *)roomInfoDic
{
    
    //使用自定义的按钮类型创建按钮
    UIButton *button = [NGButton buttonWithType:UIButtonTypeCustom];
    
    //字符串处理
    NSString *titleStr = [NSString stringWithFormat:@"%@\n%@"
                          , [roomInfoDic objectForKey:@"name_zh"]
                          , [[roomInfoDic objectForKey:@"name_en"] uppercaseString]];
    
    //设置按钮状态
    NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithAttributedString:[self createdAttributedTitleWithString:titleStr andButtonState:UIControlStateNormal]];
    [button setAttributedTitle:normalTitle forState:UIControlStateNormal];
    
    NSAttributedString *selectedTitle = [[NSAttributedString alloc] initWithAttributedString:[self createdAttributedTitleWithString:titleStr andButtonState:UIControlStateSelected]];
    [button setAttributedTitle:selectedTitle forState:UIControlStateSelected];
    
    //监听事件
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    //绑定tag，tag绑定要在addSubview的方法之前
    button.tag = [[roomInfoDic objectForKey:@"id"] integerValue];
    
    //添加按钮到自定义的tabBarView上
    [self addSubview:button];
    
    //设置默认选中
    if (self.subviews.count == 1) {
        [self buttonClicked:button];
    }
    
}

- (void)buttonClicked:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(NGView:didSelectedFrom:to:)]) {
        [self.delegate NGView:self didSelectedFrom:self.currentSelectedBtn.tag to:button.tag];
    }
    
    self.currentSelectedBtn.selected = NO;
    
    //设置当前选中
    button.selected = YES;
    self.currentSelectedBtn = button;

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
           [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:28.0] range:NSMakeRange(0, range.location)];
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
    
    CGFloat btnW = self.bounds.size.width/(self.subviews.count);
    CGFloat btnH = 80;
    CGFloat initialX  = 0;
    
    NSInteger index = 0;
    
    for (UIButton *btn in self.subviews) {
        CGFloat btnIntX = btnW * (index++) + initialX;
        btn.frame = CGRectMake(btnIntX, 0, btnW, btnH);
    }
    
}
@end


