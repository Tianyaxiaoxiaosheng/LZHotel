//
//  OverAllControlView.h
//  LZHGRControl
//
//  Created by Jony on 17/4/7.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OverAllControlViewDelegate <NSObject>

@optional
- (void)OverAllSwitchONAndOFF:(NSInteger)tag;

@end

@interface OverAllControlView : UIView
@property (nonatomic, weak) id<OverAllControlViewDelegate>delegate;

@end
