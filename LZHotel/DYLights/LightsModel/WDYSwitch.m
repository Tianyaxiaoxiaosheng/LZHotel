//
//  WDYSwitch.m
//  LZHotel
//
//  Created by Jony on 17/7/11.
//  Copyright © 2017年 yavatop. All rights reserved.
//

#import "WDYSwitch.h"

@interface WDYSwitch ()

@property (strong, nonatomic) IBOutlet NHButton *button;
@property (strong, nonatomic, ) IBOutlet UILabel *label_zh;
@property (strong, nonatomic) IBOutlet UILabel *label_en;
@end

@implementation WDYSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"WDYSwitch" owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    
    return self;
}

- (void)setIsOpen:(BOOL)isOpen {
    _isOpen = isOpen;
    self.button.selected = isOpen ? YES:NO;
}

- (void)setName_en:(NSString *)name_en {
    self.label_en.text = name_en;
}

- (void)setName_zh:(NSString *)name_zh {
    self.label_zh.text = name_zh;
}

- (IBAction)buttonClicked:(UIButton *)sender {
//    NSLog(@"tag = %ld", self.tag);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedWDYSwitch:)]) {
        [self.delegate clickedWDYSwitch:self];
    }
}



@end
