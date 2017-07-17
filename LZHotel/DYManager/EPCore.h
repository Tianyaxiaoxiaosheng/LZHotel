//
//  EPCore.h
//  LZHotel
//
//  Created by Jony on 17/7/17.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPCore : NSObject

//+ (instancetype)sharedEpCore;

//回调机制加入后，方法抽取不完美，无法实现调用回调后的一些操作
+ (void)registerWithUserInfo:(NSString *)userId andPassword:(NSString *)userPwd;

//对接收到的RCU信息解析
+ (void) rcuInfoAnalysis:(NSData *)data;

@end
