//
//  DataCenter.h
//  LZHotel
//
//  Created by Jony on 17/7/14.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCenter : NSObject

@property (nonatomic, strong) NSDictionary *roomInfoDic;
@property (nonatomic, strong) NSDictionary *localInfoDic;
@property (nonatomic, strong) NSDictionary *userInfoDic;
@property (nonatomic, strong) NSDictionary *serverInfoDic;
@property (nonatomic, strong) NSDictionary *rcuInfoDic;

//单例方法
+ (instancetype)sharedDataCenter;


/**
 To write the file

 @return The success of
 */
- (BOOL)toWriteTheFile;
@end
