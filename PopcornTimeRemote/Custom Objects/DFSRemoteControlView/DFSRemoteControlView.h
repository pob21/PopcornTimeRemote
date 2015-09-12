//
//  DFSRemoteControlView.h
//  PopcornTimeRemote
//
//  Created by Preston Brown on 9/10/15.
//  Copyright © 2015 skaggivara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POPControlView.h"

@interface DFSRemoteControlView : UIView



-(void)enablePlayerMode:(BOOL)playerMode;


@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) UIButton *up;
@property (nonatomic, strong) UIButton *down;
@property (nonatomic, strong) UIButton *left;
@property (nonatomic, strong) UIButton *right;
@property (nonatomic, strong) UIButton *back;
@property (nonatomic, strong) UIButton *mute;
@property (assign) BOOL playbackMode;


@end
