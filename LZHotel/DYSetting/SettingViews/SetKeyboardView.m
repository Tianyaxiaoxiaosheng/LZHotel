//
//  SetKeyboardView.m
//  LZHGRControl
//
//  Created by Jony on 17/4/7.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "SetKeyboardView.h"

@interface SetKeyboardView ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UITextField *roomNumTextField;
@property (weak, nonatomic) IBOutlet UISwitch *sw;

@end

@implementation SetKeyboardView

-(instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SetKeyboardView" owner:nil options:nil] lastObject];
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithRed:192/255 green:192/255 blue:192/255 alpha:0.2];
        self.layer.cornerRadius = 18;
        self.layer.masksToBounds = YES;
        
        //初始化key文本框显示
        self.keyTextField.clearButtonMode = UITextFieldViewModeAlways;
        self.keyTextField.clearsOnBeginEditing = YES;
        self.keyTextField.keyboardType = UIKeyboardTypeDecimalPad;
        self.keyTextField.placeholder = @"6位字符";
        self.keyTextField.delegate = self;
        self.keyTextField.secureTextEntry = YES;
        
        //房间号文本框
//        self.roomNumTextField.text = [NetworkInfo sharedNetworkInfo].userInfoDic[@"userId"];
        self.roomNumTextField.clearButtonMode = UITextFieldViewModeAlways;
        self.roomNumTextField.clearsOnBeginEditing = YES;
        self.roomNumTextField.keyboardType = UIKeyboardTypeDecimalPad; //数字键盘 有数字和小数点
        self.roomNumTextField.placeholder = @"4位数字"; //水印
        self.roomNumTextField.delegate = self;
        
        //设置开关的初始值
        
//        [SVProgressHUD setMinimumDismissTimeInterval:3];
        [SVProgressHUD setMaximumDismissTimeInterval:1];
//        [SVProgressHUD setFadeInAnimationDuration:0.1];
        [SVProgressHUD setFadeOutAnimationDuration:0.8];
      }
    return self;
}

//switch用于测试网络接收
- (IBAction)swValueChanged:(id)sender{
//    if ([(UISwitch *)sender isOn]) {
//        [[UDPNetwork sharedUDPNetwork] startReceiveNetworkData];
//    }else{
//        [[UDPNetwork sharedUDPNetwork] disConnect];
//    }
}

#pragma mark - 按钮事件
//取消，使房间号显示为原来
- (IBAction)cancel:(id)sender {
//    self.roomNumTextField.text = [NetworkInfo sharedNetworkInfo].userInfoDic[@"userId"];
    self.keyTextField.text = nil;
}

//注册，保存房间号
- (IBAction)preserve:(id)sender {
    //保存前检查规范,抽离到注册方法中
//    if (![self isFourBitOfRoomNumbersWithString:self.roomNumTextField.text]) {
//        [SVProgressHUD showInfoWithStatus:@"房间号不符合规范！"];
//        return;
//    }
    
//    注册
    [EPCore registerWithUserInfo:self.roomNumTextField.text andPassword:self.keyTextField.text];
    
    //更新本地数据放在注册方法中

}
- (IBAction)test {
//    测试udp发送数据
//    UDPNetwork *sharedUDPNetwork = [UDPNetwork sharedUDPNetwork];
//    [sharedUDPNetwork startReceiveNetworkData];
    
//        [sharedUDPNetwork disConnect];
//    [sharedUDPNetwork sendDataToRCU:[NSData dataWithBytes:@"Test message" length:12]];
//    [sharedUDPNetwork disConnect];
    
    //测试IP地址比对
//    NSString *ipAddress = @"172.144.1.107";
//    if ([[NetworkInfo sharedNetworkInfo] isEqualToTheCurrentIpAddressWithIpAddress:ipAddress]){
//        NSLog(@"ip地址相同");
//    }else{
//        NSLog(@"ip地址不同");
//    }
    
//    测试注册
//    NSDictionary *infoDic = @{@"localIp":@"192.168.0.15",@"localPort":@"12345",@"userId":@"1208",@"userPwd":@"123456"};
//    NSLog(@"测试按钮点击");
//    
//    NSString *strUrl = [StringTools registerStringUrlWithDictionary:infoDic];
    
    
    //测试获取状态信息
//    NSDictionary *infoDic = @{@"roomId":@"3",@"deviceId":@"1"};
//    NSString *strUrl = [[StringTools sharedStringTools] getOriginalStateStringUrlWithDictionary:infoDic];
//
//    [[WebConnect sharedWebConnect] httpRequestWithStringUrl:strUrl complet:^(NSDictionary *responseDic, BOOL isSeccuss){
//        if (isSeccuss) {
//            NSLog(@"netObject: %@",responseDic);
//        }
//    }];
    
    //测试udp发送
//    UDPNetwork * sharedUDPNetwork= [UDPNetwork sharedUDPNetwork];
//    char buffer[26]= {0x02
//        ,0x45,0x43,0x7c
//        ,0x52,0x4e,0x30,0x38,0x35,0x31,0x7c
//        ,0x50,0x57,0x30,0x38,0x35,0x31,0x7c
//        ,0x4c,0x43,0x38,0x2c,0x30,0x7c
//        ,0x03,0x01
//    };
//    NSData *data = [[NSData alloc] initWithBytes:buffer length:26];
    
//    NSString *str = @"EC|RN0851|PW0851|LC8,0|";
//    NSString *string = [NSString stringWithFormat:@"%c%@%c%c",0x02,str,0x01,0x03];
    
//    char *buf = "EC|RN0851|PW0851|LC8,0|";
//    char *h = "hhh";
//    char *c = (char *) malloc(strlen(h) + strlen(buf));
//    char pried[] = {0x02};
//    char end[] = {0x03};
//    char c[] = {0x01};
//    strcat(h, buf);
//    strcpy(ch, buf);
//    strncat(c, buf, strlen(buf));
//    NSLog(@"buffer:%s",h);
//    buffer = strcat(buffer, end);
//    buffer = strcat(buffer, c);
    
    //ARC机制下操作内存需要申请
//    char *str = "EC|RN0851|PW0851|LC8,0:9,0:10,0|";
//    char pried = 0x02;
//    char end = 0x03;
//    char check = 0x01;
//    char *buff = (char *) malloc(3 + strlen(str));
//    
//    strncpy(buff, &pried,1);
//
//    strncat(buff, str, strlen(str));
//
//    strncat(buff, &end,1);
//
//    strncat(buff, &check,1);
//
//    NSLog(@"length:%ld",strlen(&pried));//输出为4
//    
//    for (int i = 0; i < strlen(buff); i++) {
//        printf("-%x", buff[i]);
//    }
//    
//
//    
//    
//    
//    
//    NSData *data = [NSData dataWithBytes:buff length:strlen(buff)];
//
//    [sharedUDPNetwork sendDataToRCU:data];
    
//    测试数据中心
//    NSLog(@"%@", [DataCenter sharedDataCenter].localInfoDic);
    
}

#pragma mark - 文本处理
//检查四位的房间号是否符合规范
- (BOOL)isFourBitOfRoomNumbersWithString:(NSString *)string{
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

#pragma mark - textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
   
    if (self.keyTextField == textField)
     {
        if ([toBeString length] > 6) {
            [SVProgressHUD showInfoWithStatus:@"字符数超过限制！"];
             return NO;
        }
    }
    
    if (self.roomNumTextField == textField) {
        if ([toBeString length] > 4) {
            [SVProgressHUD showInfoWithStatus:@"字符数超过限制！"];
            return NO;
        }
    }
    return YES;
}



@end
