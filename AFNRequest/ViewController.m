//
//  ViewController.m
//  AFNRequest
//
//  Created by 谭杰 on 2016/12/13.
//  Copyright © 2016年 谭杰. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

//定时器对象
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"AFNRequest";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"请求" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)click:(id)sender
{
    //请求链接
    NSDictionary *postDic = @{@"pageNum":[NSString stringWithFormat:@"1"], @"pageSize":[NSString stringWithFormat:@"20"]};
    
    [[AFNRequest manager] Post:@"http://115.28.144.79/serviceapi" parameters:postDic success:^(id responseObject) {
        NSLog(@"responseObject=======%@",responseObject);
    } failure:^(NSError *error) {
        
    }];
    
    __block int i = 0;
    //GCD定时器，精度高
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 3.0 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"计时器i=%d",i++);
        
        [AFNRequest getNetWorkingStatus:^(AFNetworkReachabilityStatus status) {
            NSLog(@"%ld",(long)status);
        }];

    });
    //启动定时器
    dispatch_resume(self.timer);
    
}

- (void)dealloc {
    //关闭定时器
    dispatch_source_cancel(self.timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
