//
//  ViewController.m
//  YFRollingLabel
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 Yvan Wang. All rights reserved.
//

#import "YFViewController.h"
#import "YFRollingLabel.h"

@interface YFViewController (){
    YFRollingLabel *_label;
}
@end

@implementation YFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIScrollView *scrollView = [[UIScrollView  alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.contentSize = CGSizeMake(300, 1000);
    [self.view addSubview:scrollView];
    NSArray *textArray = //@[@"Windows Phone，力图打破人们与信息和应用之间的隔阂，提供适用于人们包括工作和娱乐在内完整生活的方方面面，最优秀的端到端体验。"];
    //  @[@"健康游戏忠告:",@"抵制不良游戏 拒绝盗版游戏",@"注意自我保护 谨防受骗上当",@"适度游戏益脑 沉迷游戏伤身",@"合理安排时间 享受健康生活"];
//    @[@"This is the first text",@"This is the second text",@"This is the third text",@"This is the fouth text",@"This is the fifth text"];
    
    @[@"THERE IS ONLY ONE TEXT IN THIS VIEW......"];
    
    _label = [[YFRollingLabel alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 40)  textArray:textArray font:[UIFont systemFontOfSize:20] textColor:[UIColor whiteColor]];
    [scrollView addSubview:_label];
    _label.backgroundColor = [UIColor orangeColor];
    _label.speed = 2;
    [_label setOrientation:RollingOrientationLeft];
    [_label setInternalWidth:_label.frame.size.width / 3];;
    
    
    __weak typeof(self) weakSelf = self;
    _label.labelClickBlock = ^(NSInteger index){
        NSString *result = [textArray objectAtIndex:index];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"第%li项", (long)index] message:result preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [weakSelf presentViewController:alert animated:YES completion:nil];
};

    
    NSArray *array = @[@"开始",@"暂停",@"停止", @"慢速"];
    for (int i = 0; i < array.count ; i++) {
        CGFloat width = (self.view.frame.size.width) / array.count;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * width + 10, 350, width - 20, 50)];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor blueColor]];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        [scrollView addSubview:btn];
    }
}

-(void)btnAction:(UIButton *)btn{
    NSInteger tag = btn.tag - 100;
    switch (tag) {
        case 0:
            [_label beginTimer];
            break;
        case 1:
            [_label pauseTimer];
            break;
        case 2:
            [_label stopTimer];
            break;
        case 3:
            _label.speed = 1;
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
