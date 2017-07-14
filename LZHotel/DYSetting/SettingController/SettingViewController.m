//
//  SettingViewController.m
//  LZHotel
//
//  Created by Jony on 17/7/6.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@property (nonatomic, strong) SetKeyboardView *setKeyboardView;

@end

@implementation SettingViewController

- (SetKeyboardView *)setKeyboardView{
    if (!_setKeyboardView) {
        _setKeyboardView = [[SetKeyboardView alloc] initWithFrame:CGRectMake(SET_VIEW_INIT_X, SET_VIEW_INIT_Y, SET_VIEW_WIDTH, SET_VIEW_HEIGHT)];
    }
    return _setKeyboardView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //test
//    NSLog(@"controllerInfoDic: %@", self.controllerInfoDic);
    
    //添加界面
    [self.view addSubview:self.setKeyboardView];
}


@end
