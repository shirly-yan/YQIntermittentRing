//
//  YQIntermittentRing.m
//  test
//
//  Created by shirly on 16/9/4.
//  Copyright © 2016年 shirly. All rights reserved.
//

#import "YQIntermittentRing.h"
#define degToRad(x) ((x) * M_PI / 180.0f)
#import "YQMath.h"

@interface YQIntermittentRing()

//圆环的度数
@property (nonatomic, assign) CGFloat ringDegree;
//圆环的宽度
@property (nonatomic, assign) CGFloat ringWidth;
//内部圆环的宽度
@property (nonatomic, assign) CGFloat insideRingWidth;
//内部圆环的半径
@property (nonatomic, assign) CGFloat insideRingRadius;
@property (nonatomic, strong) CAShapeLayer *percentLayer;
@property (nonatomic, assign) CGFloat currentDegree;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YQIntermittentRing

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self creatSubViews];
    }
    return self;
}
- (void)creatSubViews {
}
- (void)drawRect:(CGRect)rect {
    self.layer.shouldRasterize = YES;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldAntialias(context, YES);
    self.ringWidth = 20;
    self.ringDegree = 1;
    self.insideRingWidth = 5;
    self.insideRingRadius = self.frame.size.width/2-25;
    [self drawRing];
    
}
- (void)drawRing {
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.shouldRasterize = YES;
    circleLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    circleLayer.fillColor = self.nomarlColor.CGColor;
    circleLayer.lineWidth = 0;
    circleLayer.strokeColor = [UIColor blackColor].CGColor;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    for (float i = 0; i < 360; i = i+self.ringDegree*3) {
        
    [bezierPath moveToPoint:CGPointMake((self.frame.size.width/2+(self.frame.size.width/2)*[YQMath cosOfAngle:i]),( self.frame.size.width/2+(self.frame.size.width/2)*[YQMath sinOfAngle:i]))];
    [bezierPath addArcWithCenter:CGPointMake((self.frame.size.width/2),( self.frame.size.width/2))
                              radius:(self.frame.size.width/2)
                          startAngle:(degToRad(i))
                            endAngle:(degToRad(i+self.ringDegree))
                           clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake((self.frame.size.width/2+(self.frame.size.width/2-self.ringWidth)*[YQMath cosOfAngle:i+self.ringDegree]), (self.frame.size.width/2+(self.frame.size.width/2-self.ringWidth)*[YQMath sinOfAngle:i+self.ringDegree]))];
    [bezierPath addArcWithCenter:CGPointMake((self.frame.size.width/2), (self.frame.size.width/2))
                          radius:(self.frame.size.width/2-self.ringWidth)
                      startAngle:(degToRad(i+self.ringDegree))
                        endAngle:(degToRad(i))
                       clockwise:NO];
    [bezierPath closePath];

    [bezierPath moveToPoint:CGPointMake((self.frame.size.width/2+(self.insideRingRadius)*[YQMath cosOfAngle:i]),( self.frame.size.width/2+(self.insideRingRadius)*[YQMath sinOfAngle:i]))];
    [bezierPath addArcWithCenter:CGPointMake((self.frame.size.width/2),( self.frame.size.width/2))
                          radius:(self.insideRingRadius)
                      startAngle:(degToRad(i))
                        endAngle:(degToRad(i+self.ringDegree))
                       clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake((self.frame.size.width/2+(self.insideRingRadius-self.insideRingWidth)*[YQMath cosOfAngle:i+self.ringDegree]), (self.frame.size.width/2+(self.insideRingRadius-self.insideRingWidth)*[YQMath sinOfAngle:i+self.ringDegree]))];
    [bezierPath addArcWithCenter:CGPointMake((self.frame.size.width/2), (self.frame.size.width/2))
                          radius:(self.insideRingRadius-self.insideRingWidth)
                      startAngle:(degToRad(i+self.ringDegree))
                        endAngle:(degToRad(i))
                       clockwise:NO];
    [bezierPath closePath];

    }
    // 设置CAShapeLayer与UIBezierPath关联
    circleLayer.path = bezierPath.CGPath;
    
    // 将CAShaperLayer放到某个层上显示
    [self.layer addSublayer:circleLayer];

}
- (void)startToPercent:(CGFloat)percent {
    if (!(percent >= 0 && percent <= 1)) {
        return;
    }
    [self.percentLayer removeFromSuperlayer];
    self.currentDegree = 0;
    [self.timer invalidate];
    self.timer = nil;
    [self drawRingToPercent:percent];
}
- (void)drawRingToPercent:(CGFloat)percent {
    
    self.percentLayer = [CAShapeLayer layer];
    self.percentLayer.shouldRasterize = YES;
    self.percentLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    self.percentLayer.transform = CATransform3DMakeRotation(M_PI_2 , 0, 0, -1);
    self.percentLayer.fillColor = self.highColor.CGColor;
    self.percentLayer.lineWidth = 0;
    self.percentLayer.strokeColor = [UIColor blackColor].CGColor;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    self.percentLayer.path = bezierPath.CGPath;

    [self.layer addSublayer:self.percentLayer];
    self.timer =
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerAction:) userInfo:[NSNumber numberWithFloat:percent] repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer
                              forMode:NSRunLoopCommonModes];
 
}
- (void)timerAction:(NSTimer *)timer {
    CGFloat degree = [timer.userInfo floatValue]*360;
    if (self.currentDegree >= degree) {

        [timer invalidate];
        timer = nil;
        return;
    }
   //NSLog(@"b %@ %@",NSStringFromCGPoint(CGPointMake((self.frame.size.width/2+(self.frame.size.width/2)*[YQMath cosOfAngle:self.currentDegree]),( self.frame.size.width/2+(self.frame.size.width/2)*[YQMath sinOfAngle:self.currentDegree]))),NSStringFromCGPoint(CGPointMake((self.frame.size.width/2+(self.frame.size.width/2-self.ringWidth)*[YQMath cosOfAngle:self.currentDegree+self.ringDegree]),( self.frame.size.width/2+(self.frame.size.width/2-self.ringWidth)*[YQMath sinOfAngle:self.currentDegree+self.ringDegree]))));
    // 使用UIBezierPath创建路径
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:self.percentLayer.path];
    
    [bezierPath moveToPoint:CGPointMake((self.frame.size.width/2+(self.frame.size.width/2)*[YQMath cosOfAngle:self.currentDegree]), (self.frame.size.width/2+(self.frame.size.width/2)*[YQMath sinOfAngle:self.currentDegree]))];
    [bezierPath addArcWithCenter:CGPointMake((self.frame.size.width/2), (self.frame.size.width/2))
                              radius:(self.frame.size.width/2)
                          startAngle:(degToRad(self.currentDegree))
                            endAngle:(degToRad(self.currentDegree+self.ringDegree))
                           clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake((self.frame.size.width/2+(self.frame.size.width/2-self.ringWidth)*[YQMath cosOfAngle:self.currentDegree+self.ringDegree]), (self.frame.size.width/2+(self.frame.size.width/2-self.ringWidth)*[YQMath sinOfAngle:self.currentDegree+self.ringDegree]))];
    [bezierPath addArcWithCenter:CGPointMake((self.frame.size.width/2), (self.frame.size.width/2))
                              radius:(self.frame.size.width/2-self.ringWidth)
                          startAngle:(degToRad(self.currentDegree+self.ringDegree))
                            endAngle:(degToRad(self.currentDegree))
                           clockwise:NO];
    [bezierPath closePath];

    [bezierPath moveToPoint:CGPointMake((self.frame.size.width/2+(self.insideRingRadius)*[YQMath cosOfAngle:self.currentDegree]),( self.frame.size.width/2+(self.insideRingRadius)*[YQMath sinOfAngle:self.currentDegree]))];
    [bezierPath addArcWithCenter:CGPointMake((self.frame.size.width/2),( self.frame.size.width/2))
                          radius:(self.insideRingRadius)
                      startAngle:(degToRad(self.currentDegree))
                        endAngle:(degToRad(self.currentDegree+self.ringDegree))
                       clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake((self.frame.size.width/2+(self.insideRingRadius-self.insideRingWidth)*[YQMath cosOfAngle:self.currentDegree+self.ringDegree]), (self.frame.size.width/2+(self.insideRingRadius-self.insideRingWidth)*[YQMath sinOfAngle:self.currentDegree+self.ringDegree]))];
    [bezierPath addArcWithCenter:CGPointMake((self.frame.size.width/2), (self.frame.size.width/2))
                          radius:(self.insideRingRadius-self.insideRingWidth)
                      startAngle:(degToRad(self.currentDegree+self.ringDegree))
                        endAngle:(degToRad(self.currentDegree))
                       clockwise:NO];
    [bezierPath closePath];
    
    // 设置CAShapeLayer与UIBezierPath关联
    self.percentLayer.path = bezierPath.CGPath;
    
    // 将CAShaperLayer放到某个层上显示
    self.currentDegree += self.ringDegree *3;


}
#pragma mark - setter getter
- (UIColor *)highColor {
    if (_highColor) {
        return _highColor;
    }
    return [UIColor yellowColor];
}
- (UIColor *)nomarlColor {
    if (_nomarlColor) {
        return _nomarlColor;
    }
    return [UIColor colorWithWhite:1.000 alpha:0.596];
}
@end
