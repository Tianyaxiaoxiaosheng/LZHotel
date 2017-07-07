//
//  ACNavigationView.h
//  LZHGRControl
//
//  Created by Jony on 17/4/7.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACNavigationView;
@protocol  ACNavigationViewDelegate<NSObject>

@optional
- (void)aCNavigationView:(ACNavigationView *)aCNavigationView didSelectedFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface ACNavigationView : UIView
@property (nonatomic, weak) id<ACNavigationViewDelegate>delegate;

-(void)addACNavigationViewButtonWithChineseName:(NSString *)name_zh andEnglishName:(NSString *)name_en;

@end

