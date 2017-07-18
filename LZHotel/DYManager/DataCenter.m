//
//  DataCenter.m
//  LZHotel
//
//  Created by Jony on 17/7/14.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "DataCenter.h"

@interface DataCenter ()

@property (nonatomic, strong) NSMutableDictionary *dataCenterDic; //cache data
@property (nonatomic, copy) NSString *dataCachePath;
@end

@implementation DataCenter

#pragma mark - 单例模式
static DataCenter *sharedDataCenter = nil;
+ (instancetype)sharedDataCenter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataCenter = [[self alloc] init];
    });
    return sharedDataCenter;
}

#pragma mark - lazy loading with the data center
- (NSDictionary *)roomInfoDic{
    if (!_roomInfoDic) {
        _roomInfoDic = [[NSDictionary alloc] initWithDictionary:[self.dataCenterDic objectForKey:@"roomInfo"]];
    }
    return _roomInfoDic;
}

- (NSDictionary *)localInfoDic{
    if (!_localInfoDic) {
//        _localInfoDic = [[NSDictionary alloc] initWithDictionary:[self.dataCenterDic objectForKey:@"localInfo"]];
        _localInfoDic = @{@"localIp":[self getCurrentIpAddress]
                          , @"localPort":[[self.dataCenterDic objectForKey:@"localInfo"] objectForKey:@"localPort"]};
    }
    return _localInfoDic;
}

- (NSDictionary *)userInfoDic{
    if (!_userInfoDic) {
        _userInfoDic = [[NSDictionary alloc] initWithDictionary:[self.dataCenterDic objectForKey:@"userInfo"]];
    }
    return _userInfoDic;
}

- (NSDictionary *)serverInfoDic{
    if (!_serverInfoDic) {
        _serverInfoDic = [[NSDictionary alloc] initWithDictionary:[self.dataCenterDic objectForKey:@"serverInfo"]];
    }
    return _serverInfoDic;
}

- (NSDictionary *)rcuInfoDic{
    if (!_rcuInfoDic) {
        _rcuInfoDic = [[NSDictionary alloc] initWithDictionary:[self.dataCenterDic objectForKey:@"rcuInfo"]];
    }
    return _rcuInfoDic;
}

#pragma mark - Lazy loading locally cached information
- (NSString *)dataCachePath{
    if (!_dataCachePath) {
        NSArray *documentDirectoryArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *myDocumentDirectory = [documentDirectoryArray firstObject];
        _dataCachePath = [myDocumentDirectory stringByAppendingPathComponent:@"DataCenterDic.plist"];
    }
    return _dataCachePath;
}

- (NSMutableDictionary *)dataCenterDic{
    if (!_dataCenterDic) {
        _dataCenterDic = [NSMutableDictionary dictionaryWithContentsOfFile:self.dataCachePath];
        
        //测试期间，一直进入
        if (true) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:self.dataCachePath contents:nil attributes:nil];
            
            //initialization data, and writed file
            [[self initializeTheDataCenterDic] writeToFile:self.dataCachePath atomically:YES];
            
            //To read the data
            _dataCenterDic = [NSMutableDictionary dictionaryWithContentsOfFile:self.dataCachePath];
            
            //Reconfirm
            if (!_dataCenterDic) {
                NSLog(@"To read cache data error !");
            }
        }
    }
    return _dataCenterDic;
}

#pragma mark - Relative methods


/**
 Gets the current network IP address

 @return The IP address of the string type
 */
- (NSString *)getCurrentIpAddress{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}


/**
 Initialize The DataCenterDic

 @return DataCenterDic
 */
- (NSDictionary *)initializeTheDataCenterDic{
    NSDictionary *mutableDic = [[NSDictionary alloc] init];
    
    NSDictionary *roomInfoDic = @{@"roomNum":@"1002"
                                  , @"roomId":@"1"
                                  , @"roomType":@"4"};
    NSDictionary *userInfoDic = @{@"userName":@"0000"
                                  , @"userPwd":@"123456"};
    NSDictionary *localInfoDic = @{@"localIp":@"192.168.0.1"
                                   , @"localPort":@"12345"};
    NSDictionary *serverInfoDic = @{@"serverIp":@"172.144.1.120"
                                    , @"serverPort":@"8080"
                                    , @"serverName":@"hotelWeb"};
    NSDictionary *rcuInfoDic = @{@"rcuIp":@"172.144.1.120"
                                 , @"rcuPort":@"60000"};
    
    
    mutableDic = @{@"roomInfo":roomInfoDic
                   , @"userInfo":userInfoDic
                   , @"localInfo":localInfoDic
                   , @"serverInfo":serverInfoDic
                   , @"rcuInfo":rcuInfoDic};
    
    return mutableDic;
}

#pragma mark - Provided to the outside methods
- (BOOL)toWriteTheFile{
    
    //使用object存入的数据不能为nil，防止崩溃，为了方便使用Value
    [self.dataCenterDic setValue:self.roomInfoDic forKey:@"roomInfo"];
    [self.dataCenterDic setValue:self.localInfoDic forKey:@"localInfo"];
    [self.dataCenterDic setValue:self.userInfoDic forKey:@"userInfo"];
    [self.dataCenterDic setValue:self.serverInfoDic forKey:@"serverInfo"];
    [self.dataCenterDic setValue:self.rcuInfoDic forKey:@"rcuInfo"];
    
    if ([self.dataCenterDic writeToFile:self.dataCachePath atomically:YES]) {
        return true;
    }

    return false;
}

@end
