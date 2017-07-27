//
//  UDPNetwork.m
//  LZHotel
//
//  Created by Jony on 17/7/17.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "UDPNetwork.h"

@interface UDPNetwork ()<AsyncUdpSocketDelegate>

@property (nonatomic, assign)   BOOL isReceiveNetworkData;
@property (nonatomic, strong) AsyncUdpSocket *socket;

@end

@implementation UDPNetwork

#pragma mark - lazyload

#pragma mark-确保被创建一次
static UDPNetwork *sharedUDPNetwork = nil;

+ (instancetype)sharedUDPNetwork{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUDPNetwork = [super allocWithZone:zone];
    });
    return sharedUDPNetwork;
}

- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUDPNetwork = [super init];
    });
    return sharedUDPNetwork;
}

- (id)copyWithZone:(NSZone *)zone{
    return  sharedUDPNetwork;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return  sharedUDPNetwork;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return sharedUDPNetwork;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return sharedUDPNetwork;
}

#pragma mark-接收网络数据
//初始化socket通信
- (AsyncUdpSocket *)socket{
    if (!_socket) {
        
        //绑定端口
        NSDictionary *localInfoDic = [DataCenter sharedDataCenter].localInfoDic;
        if (localInfoDic) {
            NSString *portStr = [localInfoDic objectForKey:@"localPort"];
            if (portStr) {
                
                //创建socket
                _socket = [[AsyncUdpSocket alloc] initIPv4];
                _socket.delegate = self;
                NSError *error = nil;
                if ([_socket bindToPort:[portStr intValue] error:&error]){
                    
                    NSLog(@"socket bind success!");
                    }else{
                        NSLog(@"socket bind failed!");
                    }

            }else{
                NSLog(@"localPort is null");
            }
        }else{
            NSLog(@"localInfoDic is null");
        }
        
        //此错误，未找到解决方案，但不影响发送接收
        //NSLog(@"%@", error);
    }
    return _socket;
}

- (BOOL)isIsReceiveNetworkData{
    if (!_isReceiveNetworkData) {
        
        //启动时不接收数据
        _isReceiveNetworkData = FALSE;
    }
    return _isReceiveNetworkData;
}

//启动接收网络
- (BOOL)startReceiveNetworkData{

    //防止多次启动
    if (self.isReceiveNetworkData) {
        //重复连接会崩溃
        NSLog(@"重复启动接收");
        return FALSE;
        
    }else{
        if (self.socket) {
            //启动接收线程
            [self.socket receiveWithTimeout:-1 tag:0];
            return TRUE;
        }else{
            NSLog(@"socket is nil");
            return false;
        }
        
    }
}

- (BOOL)disConnect{
    //    self.isReceiveNetworkData = FALSE;
    // close(self.socket);
    [self.socket close]; //只影响接收消息，不影响发送
//    [self.socket setDelegate:nil];
    self.socket = nil;
    return false;
}

//发送数据方法
- (BOOL)sendDataToRCU:(NSData *)data{
    
    NSDictionary *rcuInfoDic = [[DataCenter sharedDataCenter] rcuInfoDic];
    NSString *rcuIp  = [rcuInfoDic objectForKey:@"rcuIp"];
    int rcuPort = [[rcuInfoDic objectForKey:@"rcuPort"] intValue];
    
    if ([self.socket sendData:data toHost:rcuIp port:rcuPort withTimeout:-1 tag:0]) {
        return true;
    }
    return false;
}

#pragma mark -AsyncUdpSocketDelegate
//UDP接收消息
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port {
    static int i = 0;
    NSString *recStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"\n(%d)host----->%@ :%hu\ndata----->%@",(i++), host, port, recStr);
    //对接收到的信息处理，如果处理时间过长，会影响接收，可采用GCD进行多任务异步处理
    
    //接收到的信息交由处理中心处理
    [EPCore rcuInfoAnalysis:data];
    
    
    //启动监听下一条消息
    [self.socket receiveWithTimeout:-1 tag:0];
    //这里可以加入你想要的代码
    return YES;
}


-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    
    NSLog(@"Message not received for error: %@", error);
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    
    NSLog(@"Message not send for error: %@",error);
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    
    NSLog(@"Message send success!");
}

-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    
    NSLog(@"socket closed!");
}

@end
