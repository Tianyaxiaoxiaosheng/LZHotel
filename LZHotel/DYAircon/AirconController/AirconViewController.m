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
    
    //注册通知，死亡时移除
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controlInformationProcessing:) name:@"Aircon" object:nil];
    
    //获取初始状态
    [EPCore sendQIOrderToRcu];
}

//控制器死亡时移除观察者，
- (void)dealloc{
    //tabbar 切换是不会死亡的
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma mark -- NGViewDelegate
- (void)NGView:(NGView *)NGView didSelectedFrom:(NSInteger)from to:(NSInteger)to{
    
    //替换界面
    [self.currentAirconView removeFromSuperview];
    self.currentAirconView = [self.airconViewDic objectForKey:[NSString stringWithFormat:@"%ld", to]];
    [self.view addSubview:self.currentAirconView];
    
    //test
//    Aircon *aircon = [[Aircon alloc] init];
//    if (self.currentAirconView.airconId == 1) {
//        aircon.setTemp = 24;
//        aircon.actualTemp = 26;
//    }else {
//        aircon.setTemp = 1;
//        aircon.actualTemp = 20;
//
//    }
//    self.currentAirconView.aircon = aircon;
    
}

#pragma mark - 处理接收到的通知
- (void)controlInformationProcessing:(NSNotification *)notification{
    
    NSString *string = [notification object];
    NSLog(@"Aircon Notification : %@", string);
    
    //先判断下字符串合法性
    if (string.length != 15) {
        NSLog(@"AC order erorr !");
        return;
    }
    
    
    //截取字符串
    NSString *idStr = [string substringWithRange:NSMakeRange(2, 1)];
    NSString *orderStr = [string substringFromIndex:4];
    
    //命令字符串解析成空调对象类型
    Aircon *aircon = [[Aircon alloc] init];
    aircon.actualTemp = [[orderStr substringWithRange:NSMakeRange(0, 2)] integerValue];
    aircon.setTemp = [[orderStr substringWithRange:NSMakeRange(3, 2)] integerValue];
    aircon.modelType =  [[orderStr substringWithRange:NSMakeRange(6, 2)] integerValue];
    aircon.windType = [[orderStr substringWithRange:NSMakeRange(9, 2)] integerValue];

//    获取界面，并设置
    AirconKeyboardView *airconView = [self.airconViewDic objectForKey:idStr];
    if (airconView) {
       
        airconView.aircon = aircon;
    }
//     self.currentAirconView.aircon = aircon;
    

}

@end
