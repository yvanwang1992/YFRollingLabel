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
    
    
    //Add ScrollView
    UIScrollView *scrollView = [[UIScrollView  alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    [self.view addSubview:scrollView];
    
    //Add YFRollingLabel
    NSArray *textArray = @[@"THIS IS THE FIRST TEXT",
                           @"THIS IS THE SECOND TEXT",
                           @"THIS IS THE THIRD TEXT",
                           @"THIS IS THE FOURTH TEXT",
                           @"THIS IS THE FIFTH TEXT"];
    //@[@"THERE IS ONLY ONE TEXT IN THIS VIEW......"];
    
    
    _label = [[YFRollingLabel alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 40)  textArray:textArray font:[UIFont systemFontOfSize:20] textColor:[UIColor whiteColor]];
    [scrollView addSubview:_label];
    _label.backgroundColor = [UIColor orangeColor];
    _label.speed = 2;
    [_label setOrientation:RollingOrientationLeft];
    [_label setInternalWidth:_label.frame.size.width / 3];;
    
    //Label Click Event Using Block
    _label.labelClickBlock = ^(NSInteger index){
        NSString *text = [textArray objectAtIndex:index];
        NSLog(@"You Tapped item:%li , and the text is %@",(long)index,text);
    };

    
    //Timer Control & Property Changed
    NSArray *array = @[@"Timer Start",@"Timer Pause",@"Timer Stop",
                       @"Set Orientation:Left/Right",@"Set Slow Speed(0.1)",@"Set InternalWidth"];
    for (int i = 0; i < array.count ; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:
                         CGRectMake(50,CGRectGetMaxY(_label.frame) + i * 50 + 20, self.view.frame.size.width - 100, 40)];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor blueColor]];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        [scrollView addSubview:btn];
    }
}

-(void)buttonAction:(UIButton *)btn{
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
            if(_label.orientation == RollingOrientationLeft){
                [_label setOrientation:RollingOrientationRight];
            }else{
                [_label setOrientation:RollingOrientationLeft];
            }
            break;
        case 4:
            [_label setSpeed:0.1];
            break;
        case 5:
            [_label setInternalWidth:_label.frame.size.width / 2];
            break;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
