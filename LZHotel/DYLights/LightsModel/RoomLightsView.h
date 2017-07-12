//
//  RoomLightsView.h
//  LZHotel
//
//  Created by Jony on 17/7/11.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomLightsView : UIView

@property (nonatomic, strong) NSArray *lightsArray;

- (void)allLightsSwitch:(BOOL)isOpen;

@end
