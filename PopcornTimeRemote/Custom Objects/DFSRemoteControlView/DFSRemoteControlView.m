//
//  DFSRemoteControlView.m
//  PopcornTimeRemote
//
//  Created by Preston Brown on 9/10/15.
//  Copyright © 2015 skaggivara. All rights reserved.
//

#import "DFSRemoteControlView.h"

@implementation DFSRemoteControlView

@synthesize up, down, left, right, delegate, back, mute, playbackMode;

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame: frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        
        up = [[UIButton alloc] initWithFrame: CGRectMake((self.frame.size.width*.5)-20, 5, 40, 40)];
        up.alpha = 0.4f;
        [up setBackgroundImage: [UIImage imageNamed: @"up"] forState: UIControlStateNormal];
        [self addSubview: up];

        
        down = [[UIButton alloc] initWithFrame: CGRectMake((self.frame.size.width*.5)-20, self.frame.size.height-45, 40, 40)];
        down.alpha = 0.4f;
        [down setBackgroundImage: [UIImage imageNamed: @"down"] forState: UIControlStateNormal];
        [self addSubview: down];

        
        left = [[UIButton alloc] initWithFrame: CGRectMake(5, (self.frame.size.height*.5)-45, 40, 40)];
        left.alpha = 0.4f;
        [left setBackgroundImage: [UIImage imageNamed: @"left"] forState: UIControlStateNormal];
        [self addSubview: left];

        
        right = [[UIButton alloc] initWithFrame: CGRectMake((self.frame.size.width)-45, (self.frame.size.height*.5)-45, 40, 40)];
        right.alpha = 0.4f;
        [right setBackgroundImage: [UIImage imageNamed: @"right"] forState: UIControlStateNormal];
        [self addSubview: right];


        
        UILabel *description = [[UILabel alloc] initWithFrame: CGRectMake((self.frame.size.width*.5)-100, (self.frame.size.height*.5)-100, 200, 200)];
        description.backgroundColor = [UIColor clearColor];
        description.numberOfLines = 0;
        description.alpha = 0.5f;
        description.textColor = [UIColor lightTextColor];
        description.textAlignment = NSTextAlignmentCenter;
        description.text = @"Swipe to move\nTap to select";
        description.font = [UIFont systemFontOfSize: 22.0f];
        [self addSubview: description];
        
        
        
        back = [[UIButton alloc] initWithFrame: CGRectMake(45, (self.frame.size.height-80), 65, 65)];
        back.layer.borderWidth = 1;
        back.layer.borderColor = [UIColor colorWithRed:0.22 green:0.58 blue:0.84 alpha:1].CGColor;
        back.layer.cornerRadius = back.frame.size.width/2;
        [back setTitle:@"Back" forState: UIControlStateNormal];
        [back addTarget: self action: @selector(back:) forControlEvents: UIControlEventTouchUpInside];
        [back setBackgroundColor: [UIColor clearColor]];
        [self addSubview:back];

        
        
        mute = [[UIButton alloc] initWithFrame: CGRectMake((self.frame.size.width - 110), (self.frame.size.height-80), 65, 65)];
        mute.layer.borderWidth = 1;
        mute.layer.borderColor = [UIColor colorWithRed:0.22 green:0.58 blue:0.84 alpha:1].CGColor;
        mute.layer.cornerRadius = mute.frame.size.width/2;
        [mute setImage: [UIImage imageNamed: @"mute"] forState: UIControlStateNormal];
        [mute addTarget: self action: @selector(mute:) forControlEvents: UIControlEventTouchUpInside];
        [mute setBackgroundColor: [UIColor clearColor]];
        [mute setEnabled: NO];
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
        
        
        
        
        UIView *topBorder = [[UIView alloc] initWithFrame: CGRectMake(10, 0, self.frame.size.width-20, 1)];
        topBorder.backgroundColor = [UIColor lightGrayColor];
        topBorder.alpha = .1f;
        [self addSubview: topBorder];

        
        
        UIView *bottomBorder = [[UIView alloc] initWithFrame: CGRectMake(10, self.frame.size.height, self.frame.size.width-20, 1)];
        bottomBorder.backgroundColor = [UIColor lightGrayColor];
        bottomBorder.alpha = .1f;
        [self addSubview: bottomBorder];
        
    }
    
    return self;
}





#pragma mark - Actions


// TODO: Consolidate all these commands

- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer {
    
    [self executeCommand: POPControlViewUpCommand];
}


- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    
    [self executeCommand: POPControlViewDownCommand];
}


- (void)handleSwipeLeftFrom:(UIGestureRecognizer*)recognizer {
    
    [self executeCommand: POPControlViewLeftCommand];
}


- (void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer {

    [self executeCommand: POPControlViewRightCommand];
}


- (void)tapFrom:(UIGestureRecognizer*)recognizer {

    [self executeCommand: playbackMode ? POPControlViewPauseCommand : POPControlViewEnterCommand];
}


- (void)back:(id)sender {
    
    [self executeCommand: POPControlViewBackCommand];
}

- (void)mute:(id)sender {
    
    if(mute.isEnabled)
        [self executeCommand: POPControlViewMuteCommand];
}



- (void)executeCommand:(POPControlViewCommand)command {
    
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(executeCommand:)]) {
            
            [self.delegate performSelector: @selector(executeCommand:) withObject:[NSNumber numberWithInteger: command]];
            
        }
    }
}



-(void)enablePlayerMode:(BOOL)playerMode {
    
    playbackMode = playerMode;
    
    mute.enabled = playerMode;
}


@end
