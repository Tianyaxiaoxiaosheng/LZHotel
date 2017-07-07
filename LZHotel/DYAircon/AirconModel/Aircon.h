//
//  Aircon.h
//  LZHotel
//
//  Created by Jony on 17/7/7.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Heating,
    Cooling,
    Ventilation,
} ModelType;

typedef enum : NSUInteger {
    LowSpeed,
    MediumSpeed,
    HighSpeed,
    AutoSpeed,
    Stop,
} WindType;

@interface Aircon : NSObject

@property (nonatomic, assign) NSUInteger actualTemp;
@property (nonatomic, assign) NSUInteger setTemp;
@property (nonatomic, assign) ModelType modelType;
@property (nonatomic, assign) WindType windType;

@end
