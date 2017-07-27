//
//  LightsViewController.m
//  LZHotel
//
//  Created by Jony on 17/7/6.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "LightsViewController.h"

@interface LightsViewController ()<NGViewDelegate, OverAllControlViewDelegate>

@property (nonatomic, strong) NGView *lightsNGView;    //键盘导航视图（包括键盘显示区域）
@property (nonatomic, strong) NSArray *roomsArray;    //房间信息数组
@property (nonatomic, strong) NSDictionary *roomsViewDic; //灯光房间界面字典
@property (nonatomic, strong) UIView *currentRoomView; //当前房间界面

@property (nonatomic, strong) NSMutableDictionary *allLightsDic; //所有灯控字典

@property (nonatomic, strong) OverAllControlView  *overAllControlView; //总控开关界面

@end

@implementation LightsViewController

//懒加载房间信息数组
- (NSArray *)roomsArray{
    if (!_roomsArray) {
        _roomsArray = [[NSArray alloc] initWithArray:[self.controllerInfoDic objectForKey:@"rooms"]];
    }
    
    return _roomsArray;
}

//懒加载导航视图
- (NGView *)lightsNGView{
    if (!_lightsNGView) {
        _lightsNGView = [[NGView alloc] initWithFrame:CGRectMake(LIGHTS_VIEW_INIT_X, LIGHTS_VIEW_INIT_Y, LIGHTS_VIEW_WIDTH, LIGHTS_VIEW_HEIGHT)];
        _lightsNGView.delegate = self;
        
        //添加房间信息到导航栏
        for (NSDictionary *roomInfoDic in self.roomsArray) {
            [_lightsNGView addNGViewButtonWithRoomInfoDictionary:roomInfoDic];
        }
        
    }
    return _lightsNGView;
}

//懒加载房间界面字典
- (NSDictionary *)roomsViewDic{
    if (!_roomsViewDic) {
        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
        for (NSDictionary *roomInfoDic in self.roomsArray) {

            RoomLightsView *roomLightsView = [[RoomLightsView alloc] initWithFrame:CGRectMake(LKB_VIEW_INIT_X, LKB_VIEW_INIT_Y, LKB_VIEW_WIDTH, LKB_VIEW_HEIGHT)];
            //房间灯数组赋值，界面根据此添加灯开关控件
            roomLightsView.lightsArray = [roomInfoDic objectForKey:@"lights"];
            roomLightsView.tag = [[roomInfoDic objectForKey:@"id"] integerValue];
            [mutableDictionary setObject:roomLightsView forKey:[roomInfoDic objectForKey:@"id"]];
        }
        _roomsViewDic = [[NSDictionary alloc] initWithDictionary:mutableDictionary];
    }
    return _roomsViewDic;
}

//懒加载总控开关界面
- (OverAllControlView *)overAllControlView{
    if (!_overAllControlView) {
        _overAllControlView = [[OverAllControlView alloc] initWithFrame:CGRectMake(OAC_VIEW_INIT_X, OAC_VIEW_INIT_Y, OAC_VIEW_WIDTH, OAC_VIEW_HEIGHT)];
        _overAllControlView.delegate = self;
    }
    return _overAllControlView;
}

- (NSMutableDictionary *)allLightsDic {
    
    if (!_allLightsDic) {
        
        _allLightsDic = [[NSMutableDictionary alloc] init];
        
        //获取房间界面
        for (UIView *roomView in [self.roomsViewDic allValues]) {
            
            //获取房间界上的子控件
            for (UIView *subView in roomView.subviews) {
                
                //判断类型，是否是自定义的开关
                if ([subView isKindOfClass:[WDYSwitch class]]) {
 
                    //get id
                    NSString *idStr = [NSString stringWithFormat:@"%ld", subView.tag];
                    
                    //判断key是否已经存在
                    if (![_allLightsDic objectForKey:idStr]) {
                        //如果不存在添加
                        [_allLightsDic setObject:(WDYSwitch *)subView forKey:idStr];
                    }else {
                        //如果存在，则表示开关有重复的id值，打印错误，以防止在控制命令解析时错误
                        NSLog(@"WDYSwitch repetition id = %@", idStr);
                    }
                    
                }
            }
        }
    }
    return _allLightsDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //test
//    NSLog(@"controllerInfoDic: %@", self.controllerInfoDic);

    //测试 所有开关
//    for (WDYSwitch *sw in [self.allLightsDic allValues]) {
//        if ((sw.tag%2) == 0) {
//            sw.isOpen = YES;
//        }
//    }

    
    //添加导航视图
    [self.view addSubview:self.lightsNGView];
    [self.view sendSubviewToBack:self.lightsNGView];

    //添加总控界面
    [self.view addSubview:self.overAllControlView];
    
    //注册通知，死亡时移除
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controlInformationProcessing:) name:@"Lights" object:nil];
    
    //获取状态信息
    [[UDPNetwork sharedUDPNetwork] startReceiveNetworkData];
    [EPCore sendQSOrderToRcu];

    
}

//控制器死亡时移除观察者，
- (void)dealloc{
    //tabbar 切换是不会死亡的
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma mark -- NGViewDelegate
- (void)NGView:(NGView *)NGView didSelectedFrom:(NSInteger)from to:(NSInteger)to{
    //替换界面
    [self.currentRoomView removeFromSuperview];
    self.currentRoomView = [self.roomsViewDic objectForKey:[NSString stringWithFormat:@"%ld", to]];
    [self.view addSubview:self.currentRoomView];
}

#pragma mark - OverAllControlView delegate 
-(void)OverAllSwitchONAndOFF:(NSInteger)tag{
    //test
//    NSLog(@"OverAllSwitchONAndOFF: %ld", tag);
//    NSLog(@"\ncurrentRoomView tag = %ld", self.currentRoomView.tag);
    
    [(RoomLightsView *)self.currentRoomView allLightsSwitch:(tag == 1)];
}

#pragma mark -- 解析信息
- (void)controlInformationProcessing:(NSNotification *)notification{
    
    NSString *string = [notification object];
    NSLog(@"Lights Notification : %@", string);
    
    //1、截取字符串,获取灯光控制类型
    NSString *typeStr = [string substringToIndex:2];
    //    NSString *orderStr = [string substringFromIndex:4];
    
    //2、判断类型,分别处理
    if ([typeStr isEqualToString:@"LC"]) {
        [self lcOrderAnalysis:string];
    }else if ([typeStr isEqualToString:@"DM"]) {
        [self dmOrderAnalysis:string];
    }
    
}

//LC指令解析
- (void)lcOrderAnalysis:(NSString *)lcStr{
    
    //1、获取开关状态
    NSString *statusStr = [lcStr substringWithRange:NSMakeRange(2, 1)];
    BOOL isOpen = ([statusStr integerValue] == 1)? YES:NO;
    
    //2、获取灯的编号，并分解成数组
    NSString *orderStr = [lcStr substringFromIndex:4];
    NSArray *idStrArray = [orderStr componentsSeparatedByString:@","];
    
    //3、根据状态，对编号数组进行处理,根据是否是特殊的255分别处理
    if ([idStrArray containsObject:@"255"]) {
        
       //如果是255，则获取所有的Value值，统一处理
        for (WDYSwitch *wdySwitch in [self.allLightsDic allValues]) {
            wdySwitch.isOpen = isOpen;
        }
    } else{
        
        //得到所有的key值，判断是否在指令数组，分别处理
        for (NSString *idStr in [self.allLightsDic allKeys]) {
            
            WDYSwitch *wdySwitch = [self.allLightsDic objectForKey:idStr];
            wdySwitch.isOpen = [idStrArray containsObject:idStr] ? isOpen:(!isOpen);
//            //id值在指令数组
//            if ([idStrArray containsObject:idStr]) {
//                wdySwitch.isOpen = isOpen;
//            }else {
//                wdySwitch.isOpen = !isOpen;
//            }
        }
    }
    
}

//DM指令解析
- (void)dmOrderAnalysis:(NSString *)lcStr{
}

@end
