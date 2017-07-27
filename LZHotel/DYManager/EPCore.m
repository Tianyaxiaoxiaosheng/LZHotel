//
//  EPCore.m
//  LZHotel
//
//  Created by Jony on 17/7/17.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "EPCore.h"

@implementation EPCore
//#pragma mark-creating once
//static EPCore *sharedEPCore;
//
//+ (instancetype)sharedEPCore{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedEPCore = [[self alloc] init];
//    });
//    return sharedEPCore;
//}


#pragma mark -- 注册功能
+ (void)registerWithUserInfo:(NSString *)userId andPassword:(NSString *)userPwd{
    //检查输入的数据格式
    if (![StringTools isFourBitOfRoomNumbersWithString:userId]) {
        [SVProgressHUD showInfoWithStatus:@"房间号不符合规范！"];
        return;
    }
    
    //获取本设备信息
    NSDictionary *localInfoDic = [[DataCenter sharedDataCenter] localInfoDic];
    
//    NSLog(@"localInfoDic : %@",localInfoDic);
    NSDictionary *infoDic = @{@"localIp":[localInfoDic objectForKey:@"localIp"]                                    ,@"localPort":[localInfoDic objectForKey:@"localPort"]
                              ,@"userId":userId
                              ,@"userPwd":userPwd};
    NSString *strUrl = [StringTools registerStringUrlWithDictionary:infoDic];
    
//    NSLog(@"strUrl :%@",strUrl);
    [[WebConnect sharedWebConnect] httpRequestWithStringUrl:strUrl complet:^(NSDictionary *responseDic, BOOL isSeccuss){
        if (isSeccuss) {
            [SVProgressHUD showSuccessWithStatus:@"Succeed !"];
            NSLog(@"responseDic: %@",responseDic);
            
            //请求成功后，对返回的数据处理
            NSDictionary *userInfoDic = @{@"userName":userId
                                          , @"userPwd":userPwd};
            [self dealWithInfomationResponse:responseDic andUserInfo:userInfoDic];
        }else {
            [SVProgressHUD showErrorWithStatus:@"Faled !"];
        }
    }];
}

+ (void) dealWithInfomationResponse:(NSDictionary *)responseDic andUserInfo:(NSDictionary *)userInfoDic{
    //测试
    NSLog(@"处理注册返回的数据");
    
    BOOL isSuccess = [[responseDic objectForKey:@"isSuccess"] boolValue];
    if (isSuccess) {
        
        //更新本地信息
        DataCenter *sharedDataCenter = [DataCenter sharedDataCenter];
        
        sharedDataCenter.rcuInfoDic = [responseDic objectForKey:@"rcuInfo"];
        sharedDataCenter.roomInfoDic = [responseDic objectForKey:@"roomInfo"];
        sharedDataCenter.userInfoDic = userInfoDic;
        
        //写入本地缓存
        if ([sharedDataCenter toWriteTheFile]) {
            [SVProgressHUD showSuccessWithStatus:@"Succeed, please restart!"];
        }else {
            [SVProgressHUD showErrorWithStatus:@"Local write error!"];
        }
        
    } else{
        [SVProgressHUD showErrorWithStatus:[responseDic objectForKey:@"errorInfo"]];
    }
}

#pragma mark - rcu信息解析
+ (void) rcuInfoAnalysis:(NSData *)data{
    //NSLog(@"Start Analysis");
    NSString *strRcuInfo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //筛选一下字符串
    static NSString *tempStr = nil;
    if ([strRcuInfo isEqualToString:tempStr]) {
        return;
    }else{
        tempStr = strRcuInfo;
    }
    NSLog(@"\nStart Analysis ----------");
    
    NSUInteger strLength;
    strLength = strRcuInfo.length;
    //NSLog(@"strLength : %ld", strLength);
    
    //1.删除前导字符
    strRcuInfo = [strRcuInfo substringWithRange:NSMakeRange(1, strLength-3)];
    NSLog(@"\nThe first processing: %@", strRcuInfo);
    
    //2.判断指令类型
    if ([strRcuInfo hasPrefix:@"RE"]) {
        //NSLog(@"RE order type");
        [self reOrderAnalysis:[strRcuInfo substringFromIndex:10]];
        
    }else if ([strRcuInfo hasPrefix:@"RL"]) {
        //NSLog(@"RL order type");
        [self rlOrderAnalysis:[strRcuInfo substringFromIndex:10]];
        
    }else if ([strRcuInfo hasPrefix:@"FR"]) {
        //NSLog(@"FR order type");
        [self frOrderAnalysis:[strRcuInfo substringFromIndex:10]];
        
    }else {
        NSLog(@"\nUnknown order type");
        
    }
    
    
}

+ (void)reOrderAnalysis:(NSString *)reStr {
    NSLog(@"RE: %@", reStr);
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    //根据“|”的位置循环截取
    NSUInteger loc = [reStr rangeOfString:@"|"].location;
    
    while (loc != NSNotFound) {
        NSString *subStr = [reStr substringToIndex:loc];
        //NSLog(@"subStr: %@", subStr);
        
        //处理截取的字符串
        if ([subStr hasPrefix:@"AC"]) {
            //NSLog(@"AC Order type");
            //NSLog(@"subStr: %@", subStr);
            [defaultCenter postNotificationName:@"Aircon" object:subStr userInfo:nil];
        }else if ([subStr hasPrefix:@"IC"]) {
            [defaultCenter postNotificationName:@"Server" object:subStr userInfo:nil];
        }
        
        reStr = [reStr substringFromIndex:loc+1];
        loc = [reStr rangeOfString:@"|"].location;
    }
}

+ (void)rlOrderAnalysis:(NSString *)rlStr {
    NSLog(@"RL: %@", rlStr);
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    //根据“|”的位置循环截取
    NSUInteger loc = [rlStr rangeOfString:@"|"].location;
    
    while (loc != NSNotFound) {
        NSString *subStr = [rlStr substringToIndex:loc];
        //        NSLog(@"subStr: %@", subStr);
        
        //处理截取的字符串
        if ([subStr hasPrefix:@"LC"] || [subStr hasPrefix:@"DM"]) {
            //NSLog(@"AC Order type");
            //NSLog(@"subStr: %@", subStr);
            [defaultCenter postNotificationName:@"Lights" object:subStr userInfo:nil];
        }
        
        rlStr = [rlStr substringFromIndex:loc+1];
        loc = [rlStr rangeOfString:@"|"].location;
    }
    
}

+ (void)frOrderAnalysis:(NSString *)frStr {
    NSLog(@"FR: %@", frStr);
    
    //根据“|”的位置循环截取
    NSUInteger loc = [frStr rangeOfString:@"|"].location;
    
    while (loc != NSNotFound) {
        //        NSString *subStr = [frStr substringToIndex:loc];
        //        NSLog(@"subStr: %@", subStr);
        frStr = [frStr substringFromIndex:loc+1];
        loc = [frStr rangeOfString:@"|"].location;
    }
    
}

@end
