//
//  WebConnect.m
//  LZHotel
//
//  Created by Jony on 17/7/17.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "WebConnect.h"

@implementation WebConnect

static WebConnect *sharedWebConnect = nil;
+ (instancetype)sharedWebConnect{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWebConnect = [[self alloc] init];
    });
    return sharedWebConnect;
}
- (void)some:(void (^)(NSString *str))block{
    
}

- (void )httpRequestWithStringUrl:(NSString *)strUrl complet:(void (^)(NSDictionary *responseDic, BOOL isSeccuss))complete{
    
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *taskError){
        NSLog(@"Register请求完成！");
        if (!taskError) {
            //NSError *jsonError = nil;
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            complete(responseDic,YES);
        }else{
            NSLog(@"\ntask error: %@", taskError.localizedDescription);
            complete(nil,NO);
        }
    }];
    
    [task resume];
}


@end
