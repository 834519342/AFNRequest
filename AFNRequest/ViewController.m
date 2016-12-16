//
//  ViewController.m
//  AFNRequest
//
//  Created by 谭杰 on 2016/12/13.
//  Copyright © 2016年 谭杰. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"请求" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)click:(id)sender
{
    //请求链接
    NSDictionary *postDic = @{@"pageNum":[NSString stringWithFormat:@"1"], @"pageSize":[NSString stringWithFormat:@"20"]};
    
    [[AFNRequest manager] Post:@"home/homeMsg" parameters:postDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end