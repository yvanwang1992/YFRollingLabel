# YFRollingLabel
YFRollingLabel 

Introduction:
YFRollingLabel is an rolling Label......

if only one text need to be shown
    it will roll in a fixed orientation automatic.

 ![oneText](https://github.com/yvanwang1992/YFRollingLabel/blob/master/OneText.gif)

if more than one text should be shown
    it will roll and recycle.

 ![TextArray](https://github.com/yvanwang1992/YFRollingLabel/blob/master/TextArray.gif)


Please notice that Only Two Labels are used in this "YFRollingLabel".
so if you set the InternalWidth a short distance and the text is not long enought,
it will break into showing the next label suddenly instead of smothly;

# How To Use It?

#  
   1.#import "YFRollingLabel.h"

   2._label = [[YFRollingLabel alloc] initWithFrame:frame textArray:@[@The first One”,@“The Second One”,@“The Third One”,@“The Last One”] font:[UIFont systemFontOfSize:20] textColor:[UIColor whiteColor]];

and you can set speed  orientation  internalWidth etc. in the while.


ClickEvent  Is a Block:
you can use like this:
_label.labelClickBlock = ^(NSInteger index){	
	//Code
};



