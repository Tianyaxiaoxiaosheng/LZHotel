//
//  StringTools.m
//  LZHotel
//
//  Created by Jony on 17/7/17.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "StringTools.h"

@implementation StringTools
//static StringTools *sharedStringTools;
//
//+ (instancetype)sharedStringTools{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedStringTools = [[self alloc] init];
//    });
//    return sharedStringTools;
//}

/**
 The dictionary converts into string of character type URL
 
 @param infoDic key:"localIp","localPort","userId","userPwd"
 @return Uses in string of character type URL which registers
 */
+ (NSString *)registerStringUrlWithDictionary:(NSDictionary *)infoDic{
    NSString *parameterStr = [[NSString alloc] initWithFormat:@"?localIp=%@&localPort=%@&userId=%@&userPwd=%@", [infoDic objectForKey:@"localIp"]
                              , [infoDic objectForKey:@"localPort"]
                              , [infoDic objectForKey:@"userId"]
                              , [infoDic objectForKey:@"userPwd"]
                              ];
    NSString *strUrl = [NSString stringWithFormat:@"http://172.144.1.120:8080/hotelWeb/Register%@",parameterStr];
    return strUrl;
}

/**
 The dictionary converts into extraction status messages string of character type URL
 
 @param infoDic key:"roomId","deviceId"
 @return Uses in extracting status messages string of character type URL
 */
+ (NSString *)getOriginalStateStringUrlWithDictionary:(NSDictionary *)infoDic{
    NSString *parameterStr = [[NSString alloc] initWithFormat:@"?roomId=%@&deviceId=%@"
                              , [infoDic objectForKey:@"roomId"]
                              , [infoDic objectForKey:@"deviceId"]
                              ];
    NSString *strUrl = [NSString stringWithFormat:@"http://172.144.1.120:8080/hotelWeb/DeviceState%@",parameterStr];
    return strUrl;
}

//检查四位的房间号是否符合规范
+ (BOOL)isFourBitOfRoomNumbersWithString:(NSString *)string{
    if (string.length != 4) {
        return false;
    }
    //检查输入的房间号是否都是数字
    for (NSInteger i = 0; i < string.length; i++) {
        unichar charactor = [string characterAtIndex:i];
        if (!(charactor  >= 48 && charactor  <=57)) {
            return false;
        }
    }
    return true;
}


@end
