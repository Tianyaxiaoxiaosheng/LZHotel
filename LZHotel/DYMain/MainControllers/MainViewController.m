//
//  MainViewController.m
//  LZHGRControl
//
//  Created by Jony on 17/4/1.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()<WDYTabbarDelegate>
@property (nonatomic, strong) NSArray *houseTypeArray; //房间类型数组

@property (nonatomic, strong) NSDictionary *currentTypeInfoDic; //当前房间类型信息
@property (nonatomic, strong) NSArray *currentControllerArray; //当前控制器数组

@end

@implementation MainViewController

//懒加载房间类型信息
- (NSArray *)houseTypeArray{
    if (!_houseTypeArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HouseType" ofType:@"plist"];
        
        if (path) {
            _houseTypeArray = [[NSArray alloc] initWithContentsOfFile:path];
        }else {
            NSLog(@"%s\nFile HouseType.plist not found!", __func__);
        }
    }
    return _houseTypeArray;
}

//懒加载当前房间类型信息
- (NSDictionary *)currentTypeInfoDic{
    if (!_currentTypeInfoDic) {
        
        //暂定版本
        NSInteger id = 4;
        
        for (NSDictionary *dic in self.houseTypeArray) {
            if ([[dic objectForKey:@"id"] integerValue] == id) {
                _currentTypeInfoDic = [[NSDictionary alloc] initWithDictionary:dic];
            }
        }
    }
    
    return _currentTypeInfoDic;
}

//懒加载当前房间控制器数组
- (NSArray *)currentControllerArray{
    if (!_currentControllerArray) {
        _currentControllerArray = [[NSArray alloc] initWithArray:[self.currentTypeInfoDic objectForKey:@"controllers"]];
    }
    return _currentControllerArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //test
//    NSLog(@"houseTypeArray: %@", self.houseTypeArray);
    
    //设置主界面背景
    self.view.backgroundColor = MAIN_VIEW_BACKGROUND;

   //添加控制器
    [self addControllerForTabBarController];
    

}

- (void)viewDidLayoutSubviews{
    
    //此方法在创建每个子View时都会调用，此类中调用两次，下方代码只需要一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect frame = CGRectMake(0
                                  , self.tabBar.frame.origin.y-41
                                  , self.tabBar.frame.size.width
                                  , 90);
        self.tabBar.frame = frame;
        
        WDYTabbar *tabBarView = [[WDYTabbar alloc] initWithFrame:self.tabBar.bounds];
        
        //添加按钮
        for (NSDictionary *controllerInfoDic in self.currentControllerArray) {
            
            //根据控制器信息添加按钮
            [tabBarView addTabbarButtonWithChineseName:[controllerInfoDic objectForKey:@"name_zh"] andEnglishName:[controllerInfoDic objectForKey:@"name_en"]];
        }
        
        //设置代理
        tabBarView.delegate = self;
        
        //把自定义的tabbar添加到 系统的tabbar上
        [self.tabBar addSubview:tabBarView];
        
    });
 
 
}

//添加控制器
- (void)addControllerForTabBarController{
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    
    //创建控制器
    LightsViewController *lightsViewController = [[LightsViewController alloc] init];
    AirconViewController *airconViewController = [[AirconViewController alloc] init];
    ServiceViewController *serviceViewController = [[ServiceViewController alloc] init];
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    
    for (NSDictionary *controllerInfoDic in self.currentControllerArray) {
        
        NSInteger controllerId = [[controllerInfoDic objectForKey:@"id"] integerValue];
        
        //根据控制器id添加控制器信息
        switch (controllerId) {
            case 1:
                lightsViewController.controllerInfoDic = controllerInfoDic;
                [viewControllers addObject:lightsViewController];
                break;
            case 2:
                airconViewController.controllerInfoDic = controllerInfoDic;
                 [viewControllers addObject:airconViewController];
                break;
            case 3:
                serviceViewController.controllerInfoDic = controllerInfoDic;
                 [viewControllers addObject:serviceViewController];
                break;
            case 4:
                settingViewController.controllerInfoDic = controllerInfoDic;
                 [viewControllers addObject:settingViewController];
                break;
                
            default:
                NSLog(@"ViewController add failed : id = %ld", controllerId);
                break;
        }
        
    }
    
    //添加控制器到UITabBarController
    self.viewControllers = viewControllers;
}

#pragma mark 自定义Tabbar的代理
-(void)tabbar:(WDYTabbar *)tabbar didSelectedFrom:(NSInteger)from to:(NSInteger)to{
    //切换tabbar控制器的子控件器
    self.selectedIndex = to;
    
}

@end
