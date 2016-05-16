//
//  YFRollingLabel.h
//  YFRollingLabel
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 Yvan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNumberOfLabel 2

typedef  void(^LabelClickBlock)(NSInteger index);

typedef NS_ENUM(NSInteger, RollingOrientation){
    RollingOrientationNone = 0,
    RollingOrientationLeft,
    RollingOrientationRight
};

@interface YFRollingLabel : UIView{
    NSTimer *_timer;
    
    UILabel *_labels[kNumberOfLabel];
    
    NSArray *_textArray;
    
    BOOL _CanRolling;
    
    NSMutableArray *_textRectArray;
    
    NSInteger _currentIndex;//index of the Current Display Label
    
    UIColor *_textColor;
    
    UIFont *_font;
}



@property (nonatomic, assign) RollingOrientation orientation;

@property (nonatomic, assign) CGFloat speed;

//In order to limit only two Labels showing in the view,
//the internalWidth can't be too big.
@property (nonatomic, assign) CGFloat internalWidth;

@property (nonatomic, assign) CGFloat offsetX;

@property (nonatomic, copy) LabelClickBlock labelClickBlock;

-(id)initWithFrame:(CGRect)frame textArray:(NSArray *)textArray;

-(id)initWithFrame:(CGRect)frame textArray:(NSArray *)textArray font:(UIFont *)font textColor:(UIColor *)textColor;

-(void)beginTimer;

-(void)pauseTimer;

-(void)stopTimer;

-(BOOL)isCanRolling;

@end
