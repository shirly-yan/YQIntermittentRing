//
//  ViewController.m
//  test
//
//  Created by shirly on 16/8/31.
//  Copyright © 2016年 shirly. All rights reserved.
//

#import "ViewController.h"
#import "YQIntermittentRing.h"

@interface ViewController ()

@property (nonatomic, strong) YQIntermittentRing *ring;
@property (weak, nonatomic) IBOutlet UITextField *percentTF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.ring = [[YQIntermittentRing alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    [self.view addSubview:self.ring];
    self.ring.center = self.view.center;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.percentTF resignFirstResponder];
}
- (IBAction)startAction:(UIButton *)sender {
    [self.percentTF resignFirstResponder];
    [self.ring startToPercent:self.percentTF.text.floatValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
