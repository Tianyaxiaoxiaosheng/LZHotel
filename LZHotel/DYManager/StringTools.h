//
//  StringTools.h
//  LZHotel
//
//  Created by Jony on 17/7/17.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringTools : NSObject

//+ (instancetype)sharedStringTools;


/**
 The dictionary converts into string of character type URL
 
 @param infoDic key:"localIp","localPort","userId","userPwd"
 @return Uses in string of character type URL which registers
 */
+ (NSString *)registerStringUrlWithDictionary:(NSDictionary *)infoDic;


/**
 The dictionary converts into extraction status messages string of character type URL
 
 @param infoDic key:"roomId","deviceId"
 @return Uses in extracting status messages string of character type URL
 */
+ (NSString *)getOriginalStateStringUrlWithDictionary:(NSDictionary *)infoDic;


/**
 The string is current.
 
 @param string String of room number
 @return bool
 */
+ (BOOL)isFourBitOfRoomNumbersWithString:(NSString *)string;

@end
