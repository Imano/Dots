//
//  CircleView.h
//  Dots
//
//  Created by Bastien Cojan on 18/06/2014.
//  Copyright (c) 2014 Imano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

// add comment interview 1

@interface DotView : UIView

+(DotView*)randomDotView;
+(void)arrangeDotsRandomlyInView:(UIView*)view;
+(void)arrangeDotsNeatlyInViewWithAnimation:(UIView*)view;
@end
