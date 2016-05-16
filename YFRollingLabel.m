//
//  YFRollingLabel.m
//  YFRollingLabel
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 Yvan Wang. All rights reserved.
//

#import "YFRollingLabel.h"

#define KSelfWith self.frame.size.width
#define KSelfHeight self.frame.size.height

#define kFont [UIFont systemFontOfSize:18]

@implementation YFRollingLabel

-(id)initWithFrame:(CGRect)frame textArray:(NSArray *)textArray{
    if(self = [super initWithFrame:frame]){
        _textArray = textArray;
        [self commonInit];
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame textArray:(NSArray *)textArray font:(UIFont *)font textColor:(UIColor *)textColor{
    if(self = [super initWithFrame:frame]){
        _textArray = textArray;
        _font = font;
        _textColor = textColor;
        [self commonInit];
    }
    return self;
}


-(void)commonInit{
    _CanRolling = NO;
    
    _currentIndex = 0;
    _textRectArray = [NSMutableArray arrayWithCapacity:_textArray.count];
    
    self.offsetX = 0;
    self.internalWidth = KSelfWith / 3;
    self.speed = 0.1f;
    self.orientation = RollingOrientationNone;
    self.clipsToBounds = YES;
    
    //Get all the auto layout Size of arrayText;
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, KSelfHeight);
    for (int i = 0; i < _textArray.count; i++) {
        CGRect textRect = [((NSString *)_textArray[i]) boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:(_font ? _font : kFont)} context:nil];
        [_textRectArray addObject:[NSValue valueWithCGRect:textRect]];
    } 
    
    //Add Subviews
    if(_textArray.count == 1){
        CGRect rect = [((NSValue *)[_textRectArray firstObject]) CGRectValue];
        if(rect.size.width > KSelfWith){
            _CanRolling = YES;
        }else{
            //Add Another Single UILabel which won't roll.
            _CanRolling = NO;
            UILabel *label = [[UILabel alloc] initWithFrame:
                              CGRectMake((KSelfWith - rect.size.width) / 2, (KSelfHeight - rect.size.height) / 2, rect.size.width, rect.size.height)];
            label.numberOfLines = 1;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [_textArray firstObject];
            label.userInteractionEnabled = YES;
            label.textColor = _textColor ? _textColor : [UIColor blackColor];
            label.font = _font ? _font : kFont;
            label.tag = 100 + 2;
            [self addSubview:label];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
            [label addGestureRecognizer:tapGesture];
        }
    }else{  //>1
        _CanRolling = YES;
    }
    //Add Two UILabels which can roll
    if(_CanRolling){
        self.orientation = RollingOrientationLeft;
        for (int i = 0; i < kNumberOfLabel; i++) {
            _labels[i] = [[UILabel alloc] init];
            _labels[i].numberOfLines = 1;
            _labels[i].textAlignment = NSTextAlignmentCenter;
            _labels[i].tag = 100 + i;
            _labels[i].userInteractionEnabled = YES;
            _labels[i].textColor = _textColor ? _textColor : [UIColor whiteColor];
            _labels[i].font = _font ? _font : kFont;
            [self addSubview:_labels[i]];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
            [_labels[i] addGestureRecognizer:tapGesture];
        }
        [self startTimer];
    }
}

//UILabel Tap Event
-(void)labelTap:(UITapGestureRecognizer *)gesture{
    NSInteger tag = ((UILabel *)[gesture view]).tag - 100;
    NSInteger index;
    if(tag == 0){   //The First One
        index = _currentIndex;
    }else if (tag == 1){  //The Next One
        index = (_currentIndex + 1) % _textArray.count;
    }else{  //Only One Label
        index = _currentIndex;
    }
        
    //Label Click Block
    if(self.labelClickBlock){
        self.labelClickBlock(index);
    }
}

-(void)dealloc{
    [self stopTimer];
}

#pragma Relation Methods of _timer
-(void)beginTimer{
    if(_timer == nil){
        [self startTimer];
        return;
    }
    if(_timer && [_timer isValid] && _CanRolling){
        [_timer setFireDate:[NSDate date]];
    }
}

-(void)startTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)pauseTimer{
    if(_timer && [_timer isValid] && _CanRolling){
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

-(void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}

-(void)timerAction:(NSTimer *)timer{

    NSArray *labelArray = [self GetLabelRectArrayAtIndex:_currentIndex];//get reseted labelArray
    CGRect firstRect = [((NSValue *)[labelArray firstObject]) CGRectValue];
    CGRect lastRect = [((NSValue *)[labelArray lastObject]) CGRectValue];
    
    NSInteger sign; //sign for From Left To Right or From Right To Left.
    sign = (self.orientation == RollingOrientationLeft) ? 1 : -1;
    self.offsetX =  self.offsetX - sign * self.speed;   //frame.origin.X of first Rect
    
    // Next Label's OffsetX:
    // There is always internalWith's distance between Two Labels in Width.
    // Like : [firstLabel][internalWidth][lastLabel] or Left-side right
    CGFloat nextOffX = self.offsetX + sign * (((self.orientation == RollingOrientationLeft)? firstRect.size.width : lastRect.size.width) + self.internalWidth);   //frame.origin.X of last Rect
    
    
    //get reseted labelTextArray
    NSArray *labelTextArray = [self GetLabelTextArrayAtIndex:_currentIndex];
    
    //        from Right to Left
    //  <===============================
    //firstLabel is always on the left.
    //if the offsetX is bigger than Width of the firstLabel , offsetX and nextOffX
    //      are both divided by speed for every _timer's Intervel(0.02);
    //otherwise when firstLabel is invisible, Set FirstLabel's offsetX with LastLabel's
    //      and change next two Labels whitch will be visible.
    
    //         from Left to Right
    //  ===============================>
    //firstLabel is always on the right.
    //if the offsetX is bigger than Width of the View,        offsetX and nextOffX
    //      are both added by speed for every _timer's Intervel(0.02);
    //otherwise when firstLabel is invisible, Set FirstLabel's offsetX with LastLabel's
    //      and change next two Labels whitch will be visible.
    
    //So The next time , Two Labels is exchanged;
    //Set Two Label's Background and you'll observe it clearly;
    
    if((self.offsetX > -firstRect.size.width && self.orientation == RollingOrientationLeft) ||
           (self.offsetX < KSelfWith && self.orientation == RollingOrientationRight) ){
        
        _labels[0].frame = CGRectMake(self.offsetX, (KSelfHeight-firstRect.size.height)/2, firstRect.size.width, firstRect.size.height);
        _labels[0].text = [labelTextArray firstObject];
            
        _labels[1].frame = CGRectMake(nextOffX, (KSelfHeight-lastRect.size.height) / 2, lastRect.size.width, lastRect.size.height);
        _labels[1].text = [labelTextArray lastObject];
    }
    else if((self.offsetX <= -firstRect.size.width  && self.orientation == RollingOrientationLeft) ||
                (self.offsetX >= KSelfWith && self.orientation == RollingOrientationRight)){
        self.offsetX = _labels[1].frame.origin.x;
            
        _currentIndex = (_currentIndex + 1)  % _textArray.count;
    }
}


-(NSArray *)GetLabelTextArrayAtIndex:(NSInteger)index{
    NSMutableArray *labelTextArray = [NSMutableArray arrayWithCapacity:kNumberOfLabel];
    [labelTextArray removeAllObjects];
    [labelTextArray addObject:[_textArray objectAtIndex:index]];
    [labelTextArray addObject:[_textArray objectAtIndex:(index + 1) % _textArray.count]];
    return labelTextArray;
}

-(NSArray *)GetLabelRectArrayAtIndex:(NSInteger)index{
    NSMutableArray *labelRectArray = [NSMutableArray arrayWithCapacity:kNumberOfLabel];
    [labelRectArray removeAllObjects];
    NSValue *firstValue = [_textRectArray objectAtIndex:index];
    NSValue *lastValue = [_textRectArray objectAtIndex:(index + 1) % _textArray.count];
    [labelRectArray addObject:firstValue];
    [labelRectArray addObject:lastValue];
    return labelRectArray;
}



#pragma setter and getter
//the speed should be setted bigger than 0 and no smaller than 5;
-(void)setSpeed:(CGFloat)speed{
    if(speed > 0){
        _speed = speed;
    }
}

-(void)setInternalWidth:(CGFloat)internalWidth{
    if(internalWidth > 0){
        _internalWidth = internalWidth;
    }
}

-(BOOL)isCanRolling{
    return _CanRolling;
}



@end
