//
//  NGView.h
//  LZHGRControl
//
//  Created by Jony on 17/4/7.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NGView;
@protocol  NGViewDelegate<NSObject>

@optional
- (void)NGView:(NGView *)NGView didSelectedFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface NGView : UIView
@property (nonatomic, weak) id<NGViewDelegate>delegate;

-(void)addNGViewButtonWithRoomInfoDictionary:(NSDictionary *)roomInfoDic;

@end

