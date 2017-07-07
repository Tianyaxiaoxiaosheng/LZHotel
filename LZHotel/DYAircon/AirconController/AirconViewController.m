//
//  AirconViewController.m
//  LZHotel
//
//  Created by Jony on 17/7/6.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "AirconViewController.h"

@interface AirconViewController ()<ACNavigationViewDelegate>

@property (nonatomic, strong) ACNavigationView *aCNavigationView;    //键盘导航视图（包括键盘显示区域）
@property (nonatomic, strong) NSArray *roomsArray;    //房间信息数组
@property (nonatomic, strong) NSArray *airconViewArray; //空调界面数组
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
- (ACNavigationView *)aCNavigationView{
    if (!_aCNavigationView) {
        _aCNavigationView = [[ACNavigationView alloc] initWithFrame:CGRectMake(AIRCON_VIEW_INIT_X, AIRCON_VIEW_INIT_Y, AIRCON_VIEW_WIDTH, AIRCON_VIEW_HEIGHT)];
        _aCNavigationView.delegate = self;
        
        //添加房间信息到导航栏
        for (NSDictionary *roomInfoDic in self.roomsArray) {
            [_aCNavigationView addACNavigationViewButtonWithChineseName:[roomInfoDic objectForKey:@"name_zh"] andEnglishName:[roomInfoDic objectForKey:@"name_en"]];
        }
        
    }
    return _aCNavigationView;
}

- (NSArray *)airconViewArray{
    if (!_airconViewArray) {
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        for (NSDictionary *roomInfoDic in self.roomsArray) {
           AirconKeyboardView *airconView = [[AirconKeyboardView alloc] initWithFrame:CGRectMake(ACKB_VIEW_INIT_X, ACKB_VIEW_INIT_Y, ACKB_VIEW_WIDTH, ACKB_VIEW_HEIGHT)];
            airconView.airconId = [[roomInfoDic objectForKey:@"id"] integerValue];
            [mutableArray addObject:airconView];
        }
        _airconViewArray = [[NSArray alloc] initWithArray:mutableArray];
    }
    return _airconViewArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //test
//    NSLog(@"controllerInfoDic: %@", self.controllerInfoDic);
    
    //添加导航视图
    [self.view addSubview:self.aCNavigationView];
    [self.view sendSubviewToBack:self.aCNavigationView];
    
}

#pragma mark -- ACNavigationViewDelegate
- (void)aCNavigationView:(ACNavigationView *)aCNavigationView didSelectedFrom:(NSInteger)from to:(NSInteger)to{
    
    //替换界面
    [self.currentAirconView removeFromSuperview];
    self.currentAirconView = [self.airconViewArray objectAtIndex:to];
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
