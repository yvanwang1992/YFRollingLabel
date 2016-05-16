# YFRollingLabel
YFRollingLabel is a rolling Label using NSTimer.



[博客园记录: 【IOS】自定义可点击的多文本跑马灯YFRollingLabel](http://www.cnblogs.com/yffswyf/p/5498296.html) 

##Effection: 
<p/>

if only one text need to be shown
    it will roll in a fixed direction automatic.
<p/>
 ![LongText](https://github.com/yvanwang1992/YFRollingLabel/blob/master/LongText.gif)

if more than one text need to be shown 
    it will roll circularly.
<p/>
 ![TextArray](https://github.com/yvanwang1992/YFRollingLabel/blob/master/TextArray.gif)

if the width of the only one text is smaller than view's width 
    it won't roll.
 ![ShortText](https://github.com/yvanwang1992/YFRollingLabel/blob/master/ShortText.png)



Please notice that Only Two Labels are used in this "YFRollingLabel".
<p/>
so if you set the "InternalWidth" and text a short width,
it will break into showing the next label suddenly instead of smothly;

# How To Use It?

####1.import "YFRollingLabel.h"

####2.Initialization:<p/>
  	YFRollingLabel *label = [[YFRollingLabel alloc] initWithFrame:frame textArray:@[@The first One”,@“The Second One”,@“The Third One”,@“The Last One”] font:[UIFont systemFontOfSize:20] textColor:[UIColor whiteColor]];

####3.Property:<p/>
  	speed:         pixel rolling for every 0.02s, default : 1.0f.
  	internalWidth: the width between two labels, default : a third of view's width.
  	orientation:   rolling from left to right or not: default : RollingOrientationLeft.

####4.Method about Timer:<p/>
  	-(void)beginTimer;    start rolling. 
  	-(void)pauseTimer;    pause rolling. 
  	-(void)stopTimer;     stop  rolling. 

####5.ClickEventBlock:<p/>
  	label.labelClickBlock = ^(NSInteger index){	
		//Your Code.
  	};



