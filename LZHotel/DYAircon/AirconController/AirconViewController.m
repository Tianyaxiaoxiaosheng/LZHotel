//
//  AirconViewController.m
//  LZHotel
//
//  Created by Jony on 17/7/6.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "AirconViewController.h"

@interface AirconViewController ()<NGViewDelegate>

@property (nonatomic, strong) NGView *airconNGView;    //键盘导航视图（包括键盘显示区域）
@property (nonatomic, strong) NSArray *roomsArray;    //房间信息数组
@property (nonatomic, strong) NSDictionary *airconViewDic; //空调界面字典
@property (nonatomic, strong) AirconKeyboardView *currentAirconView;

@end

@implementation AirconViewController

- (NSArray *)roomsArray{
    if (!_roomsArray) {
        _roomsArray = [[NSArray alloc] initWithArray:[self.controllerInfoDic objectForKey:@"rooms"]];
    }
    
    return _roomsArray;
}

//懒加载导航视图
- (NGView *)airconNGView{
    if (!_airconNGView) {
        _airconNGView = [[NGView alloc] initWithFrame:CGRectMake(AIRCON_VIEW_INIT_X, AIRCON_VIEW_INIT_Y, AIRCON_VIEW_WIDTH, AIRCON_VIEW_HEIGHT)];
        _airconNGView.delegate = self;
        
        //添加房间信息到导航栏
        for (NSDictionary *roomInfoDic in self.roomsArray) {
            [_airconNGView addNGViewButtonWithRoomInfoDictionary:roomInfoDic];
        }
        
    }
    return _airconNGView;
}

- (NSDictionary *)airconViewDic{
    if (!_airconViewDic) {
        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
        for (NSDictionary *roomInfoDic in self.roomsArray) {
           AirconKeyboardView *airconView = [[AirconKeyboardView alloc] initWithFrame:CGRectMake(ACKB_VIEW_INIT_X, ACKB_VIEW_INIT_Y, ACKB_VIEW_WIDTH, ACKB_VIEW_HEIGHT)];
            airconView.airconId = [[roomInfoDic objectForKey:@"id"] integerValue];
            [mutableDictionary setObject:airconView forKey:[roomInfoDic objectForKey:@"id"]];
        }
        _airconViewDic = [[NSDictionary alloc] initWithDictionary:mutableDictionary];
    }
    return _airconViewDic;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //test
//    NSLog(@"controllerInfoDic: %@", self.controllerInfoDic);
    
    //添加导航视图
    [self.view addSubview:self.airconNGView];
    [self.view sendSubviewToBack:self.airconNGView];
    
}

#pragma mark -- NGViewDelegate
- (void)NGView:(NGView *)NGView didSelectedFrom:(NSInteger)from to:(NSInteger)to{
    
    //替换界面
    [self.currentAirconView removeFromSuperview];
    self.currentAirconView = [self.airconViewDic objectForKey:[NSString stringWithFormat:@"%ld", to]];
    [self.view addSubview:self.currentAirconView];
    
    //test
    Aircon *aircon = [[Aircon alloc] init];
    if (self.currentAirconView.airconId == 1) {
        aircon.setTemp = 24;
        aircon.actualTemp = 26;
    }else {
        aircon.setTemp = 1;
        aircon.actualTemp = 20;

    }
    self.currentAirconView.aircon = aircon;
    
}
@end
