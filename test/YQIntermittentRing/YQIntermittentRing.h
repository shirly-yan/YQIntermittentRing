//
//  YQIntermittentRing.h
//  test
//
//  Created by shirly on 16/9/4.
//  Copyright © 2016年 shirly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQIntermittentRing : UIView

@property (nonatomic, strong) UIColor *highColor;
@property (nonatomic, strong) UIColor *nomarlColor;

- (void)startToPercent:(CGFloat)percent;

@end
