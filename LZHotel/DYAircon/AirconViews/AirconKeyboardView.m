//
//  AirconKeyboardView.m
//  LZHGRControl
//
//  Created by Jony on 17/4/7.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "AirconKeyboardView.h"

@interface AirconKeyboardView ()
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *windTypeImage;
@property (weak, nonatomic) IBOutlet UIImageView *modeTypeImage;


//空调模式显示的数组
@property (nonatomic, strong) NSArray *modeTypeImages;
@property (nonatomic, strong) NSArray *windTypeImages;

@property (nonatomic, assign) NSInteger setTemp;

@end

@implementation AirconKeyboardView

#pragma mark-lazyload
//加载空调模式显示的数组
- (NSArray *)modeTypeImages{
    if (!_modeTypeImages) {
        _modeTypeImages = @[@"model_wind", @"model_code", @"model_hot"];
    }
    return _modeTypeImages;
}
- (NSArray *)windTypeImages{
    if (!_windTypeImages) {
        _windTypeImages = @[@"wind_speed4", @"wind_speed1", @"wind_speed2", @"wind_speed3", @"wind_speed0"];
    }
    return _windTypeImages;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        //设置界面
        self = [[[NSBundle mainBundle] loadNibNamed:@"AirconKeyboardView" owner:nil options:nil] lastObject];
        self.frame = frame;
        
        for (NSInteger i = 1; i <= 10; i++) {
            //无法直接使用UIButton *button in self.subViews,因为有其他控件，可能报错
            UIButton *button = [self viewWithTag:i];
            if (button) {
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
    }
    return self;
}

- (void)buttonClicked:(UIButton *)button{
    switch (button.tag) {
        case 1:
            self.setTemp++;
            break;
        case 2:
            self.setTemp--;
            break;
        case 3:
        case 4:
        case 5:
            self.modeTypeImage.image = [UIImage imageNamed:self.modeTypeImages[button.tag%3]];
            break;
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
            self.windTypeImage.image = [UIImage imageNamed:self.windTypeImages[button.tag%6]];
            break;

            
        default:
            break;
    }
}

- (void)setSetTemp:(NSInteger)setTemp{
    _setTemp = setTemp;
    self.temperatureLabel.text = [NSString stringWithFormat:@"%ld", setTemp];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.temperatureLabel.text = [NSString stringWithFormat:@"%ld", self.aircon.actualTemp];
    });
    
}

- (void)setAircon:(Aircon *)aircon{
    _aircon = aircon;
    self.temperatureLabel.text = [NSString stringWithFormat:@"%ld", aircon.actualTemp];
    self.windTypeImage.image = [UIImage imageNamed:[self.windTypeImages objectAtIndex:aircon.windType]];
    self.modeTypeImage.image = [UIImage imageNamed:[self.modeTypeImages objectAtIndex:aircon.modelType]];
    self.setTemp = aircon.setTemp;
}
@end
