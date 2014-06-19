//
//  CircleView.m
//  Dots
//
//  Created by Bastien Cojan on 18/06/2014.
//  Copyright (c) 2014 Imano. All rights reserved.
//

#import "DotView.h"

@implementation DotView


#define kMINRADIUS 10
#define kMAXRADIUS 50
#define kMAXCIRCLES 80
#define kNBDOTSPERLINE 6


+(DotView*)randomDotView {
    int radius = kMINRADIUS + (arc4random()%(kMAXRADIUS-kMINRADIUS))+1 ;
    DotView *dotView = [[DotView alloc] initWithFrame:CGRectMake(0, 0, radius*2.0, radius*2.0)];
    
    //generate random color
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    dotView.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    [dotView.layer setCornerRadius:radius];
    [dotView.layer setMasksToBounds:YES];
    
    return dotView;
}

+(void)arrangeDotsRandomlyInView:(UIView*)view {
    for(UIView* subView in view.subviews) {
        subView.center = CGPointMake((CGFloat)(arc4random() % (int)view.bounds.size.width) +1, (arc4random() % (int)view.bounds.size.height) +1);
    }
}

+(void) arrangeDotsNeatlyInViewWithAnimation:(UIView *)view {
    float padding = (view.bounds.size.width - (kNBDOTSPERLINE*kMAXRADIUS*2.0))/(kNBDOTSPERLINE+1);
    
    NSArray *orderedArray = [view.subviews sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        DotView *circle1 = (DotView*)obj1;
        DotView *circle2 = (DotView*)obj2;
        
        int c1Col = (circle1.center.x+kMAXRADIUS) / (padding+kMAXRADIUS*2.0);
        int c2Col = (circle2.center.x+kMAXRADIUS) / (padding+kMAXRADIUS*2.0);
        
        int c1Row = (circle1.center.y+kMAXRADIUS) / (padding+kMAXRADIUS*2.0);
        int c2Row = (circle2.center.y+kMAXRADIUS) / (padding+kMAXRADIUS*2.0);
        
        if (c1Row<c2Row)
            return NSOrderedAscending;
        else if (c1Row==c2Row)
            return (c1Col<c2Col)?NSOrderedAscending:NSOrderedDescending;
        else
            return NSOrderedDescending;
    }];
    
    
    int col = 1 ;
    int row = 1 ;
    for (DotView *circleView in orderedArray) {
        [UIView animateWithDuration:.3 animations:^{
            [circleView setCenter:CGPointMake(col*padding+(col-1)*kMAXRADIUS*2.0+kMAXRADIUS,row*padding+(row-1)*kMAXRADIUS*2.0+kMAXRADIUS)];
        }];
        
        col++;
        if (col>kNBDOTSPERLINE) {
            col=1;
            row++;
        }
    }
}

-(void)setHighLighted:(BOOL)highlighted {
    CGFloat hue,saturation,brightness,alpha;
    [self.backgroundColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    self.backgroundColor = [[UIColor alloc] initWithHue:hue saturation:saturation brightness:highlighted?brightness/2.0:brightness*2.0 alpha:alpha];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setHighLighted:YES];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setHighLighted:NO];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setHighLighted:NO];
}


@end
