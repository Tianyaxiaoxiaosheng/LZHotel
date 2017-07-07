//
//  TitleBarView.m
//  LZHGRControl
//
//  Created by Jony on 17/4/7.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "TitleBarView.h"

@interface TitleBarView ()

@property (strong, nonatomic) IBOutlet UILabel *chineseNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *englishNameLable;

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation TitleBarView

- (instancetype)initWithFrame:(CGRect)frame andControllerInfo:(NSDictionary *)controllerInfoDic
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TitleBarView" owner:nil options:nil] lastObject];
        
        self.chineseNameLabel.text = [controllerInfoDic objectForKey:@"name_zh"];
    
        self.englishNameLable.text = [[controllerInfoDic objectForKey:@"name_en"] uppercaseString];
        
        NSString *icon = [controllerInfoDic objectForKey:@"icon"];
        if (icon) {
            self.iconImageView.image = [UIImage imageNamed:icon];
        }
        
    }

    return self;
}


@end
