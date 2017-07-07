//
//  WDYViewController.m
//  LZHotel
//
//  Created by Jony on 17/7/6.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "WDYViewController.h"

@interface WDYViewController ()

@property (nonatomic, strong) TitleBarView *titleBarView;

@end

@implementation WDYViewController

- (TitleBarView *)titleBarView{
    if (!_titleBarView) {
        if (self.controllerInfoDic) {
            _titleBarView = [[TitleBarView alloc] initWithFrame:CGRectMake(TITLEBAR_VIEW_INIT_X, TITLEBAR_VIEW_INIT_Y, TITLEBAR_VIEW_WIDTH, TITLEBAR_VIEW_HEIGHT) andControllerInfo:self.controllerInfoDic];
            
            //test
//            _titleBarView.backgroundColor = [UIColor blackColor];
        } else {
            NSLog(@"controllerInfoDic is null");
        }
    }
    return _titleBarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //加载标题视图
    [self.view addSubview:self.titleBarView];
}

@end
