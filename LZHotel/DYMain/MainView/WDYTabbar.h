//
//  WDYTabbar.h
//  LZHGRControl
//
//  Created by Jony on 17/4/23.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDYTabbar;
@protocol  WDYTabbarDelegate<NSObject>

- (void)tabbar:(WDYTabbar *)tabbar didSelectedFrom:(NSInteger)from to:(NSInteger)to;

@end



@interface WDYTabbar : UIView

@property (nonatomic, weak) id<WDYTabbarDelegate> delegate;


/**
 Add button to tabBar View

 @param name_zh ChineseName
 @param name_en EnglishName
 */
-(void)addTabbarButtonWithChineseName:(NSString *)name_zh andEnglishName:(NSString *)name_en;


@end

