//
//  ViewController.m
//  QFMoveView
//
//  Created by QianFan_Ryan on 16/8/22.
//  Copyright © 2016年 QianFan. All rights reserved.
//

#import "ViewController.h"
#import "QFMoveView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    QFMoveView *aView = [[QFMoveView alloc]initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 0)];
    aView.leftMargin = 10;
    aView.rightMargin = 10;
    aView.verticalInterval = 5;
    aView.horizontalInterval = 5;
    aView.widthHeightScale = 1.2;
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [data addObject:[NSNull null]];
    }
    [aView setData:data];
    [self.view addSubview:aView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
