//
//  LightsViewController.m
//  LZHotel
//
//  Created by Jony on 17/7/6.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "LightsViewController.h"

@interface LightsViewController ()<NGViewDelegate>

@property (nonatomic, strong) NGView *lightsNGView;    //键盘导航视图（包括键盘显示区域）
@property (nonatomic, strong) NSArray *roomsArray;    //房间信息数组
@property (nonatomic, strong) NSDictionary *roomsViewDic; //灯光房间界面字典
@property (nonatomic, strong) UIView *currentRoomView;

@property (nonatomic, strong) NSMutableDictionary *lightsDic;

@end

@implementation LightsViewController

- (NSArray *)roomsArray{
    if (!_roomsArray) {
        _roomsArray = [[NSArray alloc] initWithArray:[self.controllerInfoDic objectForKey:@"rooms"]];
    }
    
    return _roomsArray;
}

//懒加载导航视图
- (NGView *)lightsNGView{
    if (!_lightsNGView) {
        _lightsNGView = [[NGView alloc] initWithFrame:CGRectMake(AIRCON_VIEW_INIT_X, AIRCON_VIEW_INIT_Y, AIRCON_VIEW_WIDTH, AIRCON_VIEW_HEIGHT)];
        _lightsNGView.delegate = self;
        
        //添加房间信息到导航栏
        for (NSDictionary *roomInfoDic in self.roomsArray) {
            [_lightsNGView addNGViewButtonWithRoomInfoDictionary:roomInfoDic];
        }
        
    }
    return _lightsNGView;
}

- (NSDictionary *)roomsViewDic{
    if (!_roomsViewDic) {
        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
        for (NSDictionary *roomInfoDic in self.roomsArray) {

            RoomLightsView *roomLightsView = [[RoomLightsView alloc] initWithFrame:CGRectMake(ACKB_VIEW_INIT_X, ACKB_VIEW_INIT_Y, ACKB_VIEW_WIDTH, ACKB_VIEW_HEIGHT)];
            roomLightsView.lightsArray = [roomInfoDic objectForKey:@"lights"];
            [mutableDictionary setObject:roomLightsView forKey:[roomInfoDic objectForKey:@"id"]];
        }
        _roomsViewDic = [[NSDictionary alloc] initWithDictionary:mutableDictionary];
    }
    return _roomsViewDic;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //test
//    NSLog(@"controllerInfoDic: %@", self.controllerInfoDic);
    
    //添加导航视图
    [self.view addSubview:self.lightsNGView];
    [self.view sendSubviewToBack:self.lightsNGView];

}


#pragma mark -- NGViewDelegate
- (void)NGView:(NGView *)NGView didSelectedFrom:(NSInteger)from to:(NSInteger)to{
    //替换界面
    [self.currentRoomView removeFromSuperview];
    self.currentRoomView = [self.roomsViewDic objectForKey:[NSString stringWithFormat:@"%ld", to]];
    [self.view addSubview:self.currentRoomView];
}


@end
