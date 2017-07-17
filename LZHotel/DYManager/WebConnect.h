//
//  WebConnect.h
//  LZHotel
//
//  Created by Jony on 17/7/17.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebConnect : NSObject

+ (instancetype)sharedWebConnect;

/**
 网络请求
 @param strUrl 参数
 @param complete 回调
 */
- (void )httpRequestWithStringUrl:(NSString *)strUrl complet:(void (^)(NSDictionary *responseDic, BOOL isSeccuss))complete;

@end
