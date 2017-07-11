//
//  ServiceViewController.m
//  LZHotel
//
//  Created by Jony on 17/7/6.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "ServiceViewController.h"

@interface ServiceViewController ()

@property (nonatomic, strong) ServerKeyboardView *serverKeyboardView;

@end

@implementation ServiceViewController

- (ServerKeyboardView *)serverKeyboardView{
    if (!_serverKeyboardView) {
        _serverKeyboardView = [[ServerKeyboardView alloc] initWithFrame:CGRectMake(SERVER_VIEW_INIT_X, SERVER_VIEW_INIT_Y, SERVER_VIEW_WIDTH, SERVER_VIEW_HEIGHT)];
    }
    return _serverKeyboardView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //test
//    NSLog(@"controllerInfoDic: %@", self.controllerInfoDic);
    
    //添加键盘区
    [self.view addSubview:self.serverKeyboardView];

}


@end
