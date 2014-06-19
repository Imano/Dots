//
//  ViewController.m
//  Dots
//
//  Created by Bastien Cojan on 19/06/2014.
//  Copyright (c) 2014 Imano. All rights reserved.
//

#import "ViewController.h"
#import "DotView.h"

#define kMINRADIUS 25
#define kMAXRADIUS 60
#define kMAXCIRCLES 80

@interface ViewController ()

@end


@implementation ViewController {

    UIScrollView *_scrollView ;
    UIView *_canvasView ;
    UIView *_drawerView ;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //create the canvas
    _canvasView = [[UIView alloc]initWithFrame:self.view.bounds];
    _canvasView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_canvasView];
    
    // add 25 dots to the canvas
    [self addDots:25 toView:_canvasView];
    [DotView arrangeDotsRandomlyInView:_canvasView];
    
    // add the scrollview that contains the drawer
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    // add the drawer
    _drawerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 650.0)];
    _drawerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [_scrollView addSubview:_drawerView];
    
    // add 20 dots to the drawer and organise them neatly
    [self addDots:20 toView:_drawerView];
    [DotView arrangeDotsNeatlyInViewWithAnimation:_drawerView];
    
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+_drawerView.frame.size.height);
    _scrollView.contentOffset = CGPointMake(0, _drawerView.frame.size.height);

    _scrollView.userInteractionEnabled=NO;
    [self.view addGestureRecognizer:_scrollView.panGestureRecognizer];
    
}

-(void)addDots:(NSUInteger)count toView:(UIView*)view {
    for (int i=0 ; i<count;i++) {
        DotView *dotView = [DotView randomDotView];
        [view addSubview:dotView];
        
        // Add gesture recogniser to the dot, so we can drag and drop it
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.minimumPressDuration=0.3;
        [dotView addGestureRecognizer:longPress];
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer*)gesture {
    UIView *dot = gesture.view;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self grabDot:dot withGesture:gesture];
            break;
        case UIGestureRecognizerStateChanged:
            [self moveDot:dot withGesture:gesture];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [self dropDot:dot withGesture:gesture];
        default:
            break;
    }
}

-(void)grabDot:(UIView*)dot withGesture:(UIGestureRecognizer*)gesture {
    dot.center = [self.view convertPoint:dot.center fromView:dot.superview];
    [self.view addSubview:dot];
    [UIView animateWithDuration:0.2 animations:^{
        dot.transform = CGAffineTransformMakeScale(1.2, 1.2);
        dot.alpha=0.8;
        [self moveDot:dot withGesture:gesture];
    }];
    
    _scrollView.panGestureRecognizer.enabled = NO ;
    _scrollView.panGestureRecognizer.enabled = YES ;
    
    [DotView arrangeDotsNeatlyInViewWithAnimation:_drawerView];
}

-(void)moveDot:(UIView*)dot withGesture:(UIGestureRecognizer*)gesture {
    dot.center = [gesture locationInView:self.view];
}

-(void)dropDot:(UIView*)dot withGesture:(UIGestureRecognizer*)gesture {
    [UIView animateWithDuration:0.2 animations:^{
        dot.transform = CGAffineTransformIdentity;
        dot.alpha=1.0;
    }];
    CGPoint locationInDrawer = [gesture locationInView:_drawerView];
    if (CGRectContainsPoint([_drawerView bounds], locationInDrawer)) {
        [_drawerView addSubview:dot];
    } else {
        [_canvasView addSubview:dot];
    }
    dot.center = [self.view convertPoint:dot.center toView:dot.superview];
    [DotView arrangeDotsNeatlyInViewWithAnimation:_drawerView];
}


@end
