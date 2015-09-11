//
//  DFSRemoteControlView.m
//  PopcornTimeRemote
//
//  Created by Preston Brown on 9/10/15.
//  Copyright © 2015 skaggivara. All rights reserved.
//

#import "DFSRemoteControlView.h"

@implementation DFSRemoteControlView

@synthesize up, down, left, right, delegate, back, mute;

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame: frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        
        up = [[UIButton alloc] initWithFrame: CGRectMake((self.frame.size.width*.5)-20, 5, 40, 40)];
        [up setBackgroundImage: [UIImage imageNamed: @"up"] forState: UIControlStateNormal];
        [self addSubview: up];

        
        down = [[UIButton alloc] initWithFrame: CGRectMake((self.frame.size.width*.5)-20, self.frame.size.height-45, 40, 40)];
        [down setBackgroundImage: [UIImage imageNamed: @"down"] forState: UIControlStateNormal];
        [self addSubview: down];

        
        left = [[UIButton alloc] initWithFrame: CGRectMake(5, (self.frame.size.height*.5)-45, 40, 40)];
        [left setBackgroundImage: [UIImage imageNamed: @"left"] forState: UIControlStateNormal];
        [self addSubview: left];

        
        right = [[UIButton alloc] initWithFrame: CGRectMake((self.frame.size.width)-45, (self.frame.size.height*.5)-45, 40, 40)];
        [right setBackgroundImage: [UIImage imageNamed: @"right"] forState: UIControlStateNormal];
        [self addSubview: right];


        
        UILabel *description = [[UILabel alloc] initWithFrame: CGRectMake((self.frame.size.width*.5)-100, (self.frame.size.height*.5)-100, 200, 200)];
        description.backgroundColor = [UIColor clearColor];
        description.numberOfLines = 0;
        description.textColor = [UIColor lightTextColor];
        description.textAlignment = NSTextAlignmentCenter;
        description.text = @"Swipe to move\nTap to select";
        description.font = [UIFont systemFontOfSize: 26.0f];
        [self addSubview: description];
        
        
        
        back = [[UIButton alloc] initWithFrame: CGRectMake(45, (self.frame.size.height-70), 65, 65)];
        back.layer.cornerRadius = back.frame.size.width/2;
        [back setTitle:@"Back" forState: UIControlStateNormal];
        [back addTarget: self action: @selector(back:) forControlEvents: UIControlEventTouchUpInside];
        [back setBackgroundColor: [UIColor colorWithRed:0.22 green:0.58 blue:0.84 alpha:1]];
        [self addSubview:back];

        
        
        mute = [[UIButton alloc] initWithFrame: CGRectMake((self.frame.size.width - 110), (self.frame.size.height-70), 65, 65)];
        mute.layer.cornerRadius = mute.frame.size.width/2;
        [mute setImage: [UIImage imageNamed: @"mute"] forState: UIControlStateNormal];
        [mute addTarget: self action: @selector(mute:) forControlEvents: UIControlEventTouchUpInside];
        [mute setBackgroundColor: [UIColor colorWithRed:0.22 green:0.58 blue:0.84 alpha:1]];
        [self addSubview:mute];

        
        
        
        UISwipeGestureRecognizer* swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
        swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipeUpGestureRecognizer];
        
        
        UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
        swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swipeDownGestureRecognizer];
        
        
        UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftFrom:)];
        swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeLeftGestureRecognizer];
        
        
        UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightFrom:)];
        swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRightGestureRecognizer];
        
        
        UITapGestureRecognizer *tapGestureRecogizner = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapFrom:)];
        tapGestureRecogizner.numberOfTapsRequired = 1;
        [self addGestureRecognizer: tapGestureRecogizner];
        
    }
    
    return self;
}





#pragma mark - Actions


- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer {
    
    NSLog(@"Swipe Up");
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(executeCommand:)]) {
            
            [self.delegate performSelector: @selector(executeCommand:) withObject:[NSNumber numberWithInteger: POPControlViewUpCommand]];
            
            //[self.delegate selectedCommand:(POPControlViewCommand) tag];
        }
    }

    
}


- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    
    NSLog(@"Swipe Down");
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(executeCommand:)]) {
            
            [self.delegate performSelector: @selector(executeCommand:) withObject:[NSNumber numberWithInteger: POPControlViewDownCommand]];
            
            //[self.delegate selectedCommand:(POPControlViewCommand) tag];
        }
    }

    
}


- (void)handleSwipeLeftFrom:(UIGestureRecognizer*)recognizer {
    
    NSLog(@"Swipe Left");
    
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(executeCommand:)]) {
            
            [self.delegate performSelector: @selector(executeCommand:) withObject:[NSNumber numberWithInteger: POPControlViewLeftCommand]];
            
            //[self.delegate selectedCommand:(POPControlViewCommand) tag];
        }
    }

    
}


- (void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer {
    
    NSLog(@"Swipe Right");
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(executeCommand:)]) {
            
            [self.delegate performSelector: @selector(executeCommand:) withObject:[NSNumber numberWithInteger: POPControlViewRightCommand]];
            
            //[self.delegate selectedCommand:(POPControlViewCommand) tag];
        }
    }

    
}


- (void)tapFrom:(UIGestureRecognizer*)recognizer {
    
    NSLog(@"Tap");
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(executeCommand:)]) {
            
            [self.delegate performSelector: @selector(executeCommand:) withObject:[NSNumber numberWithInteger: POPControlViewEnterCommand]];
            
            //[self.delegate selectedCommand:(POPControlViewCommand) tag];
        }
    }

}




- (void)back:(id)sender {
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(executeCommand:)]) {
            
            [self.delegate performSelector: @selector(executeCommand:) withObject:[NSNumber numberWithInteger: POPControlViewBackCommand]];
            
            //[self.delegate selectedCommand:(POPControlViewCommand) tag];
        }
    }

}



- (void)mute:(id)sender {
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(executeCommand:)]) {
            
            [self.delegate performSelector: @selector(executeCommand:) withObject:[NSNumber numberWithInteger: POPControlViewMuteCommand]];
            
            //[self.delegate selectedCommand:(POPControlViewCommand) tag];
        }
    }
    
}


- (void)handleCommand:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
    if (self.delegate) {
       
        if ([self.delegate respondsToSelector:@selector(selectedCommand:)]) {
           
            [self.delegate performSelector: @selector(selectedCommand:) withObject:[NSNumber numberWithInteger: tag]];
            
            //[self.delegate selectedCommand:(POPControlViewCommand) tag];
        }
    }
}

@end
