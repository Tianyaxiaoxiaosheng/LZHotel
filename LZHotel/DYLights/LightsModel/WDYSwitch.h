//
//  WDYSwitch.h
//  LZHotel
//
//  Created by Jony on 17/7/11.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDYSwitch;
@protocol WDYSwitchDelegate <NSObject>

@optional
- (void)clickedWDYSwitch:(WDYSwitch *)sw;

@end



@interface WDYSwitch : UIView

@property (nonatomic, weak) id<WDYSwitchDelegate> delegate;

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, copy) NSString *name_zh;
@property (nonatomic, copy) NSString *name_en;

@end
