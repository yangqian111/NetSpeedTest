//
//  ViewController.m
//  网络速度测试
//
//  Created by 羊谦 on 2017/2/21.
//  Copyright © 2017年 羊谦. All rights reserved.
//

#import "ViewController.h"
#import "PPSNetSpeedTest.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)startTest:(id)sender {
    PPSNetSpeedTest *test = [[PPSNetSpeedTest alloc] init];
    [test startDownLoadTestWithCallBlock:^(NSString *speed) {
        self.speedLabel.text = speed;
        NSLog(@"%@",speed);
    } completeBlock:^(NSString *speed) {
        self.speedLabel.text = speed;
        NSLog(@"%@",speed);
    }];

    
}

@end
