//
//  POPAppDelegate.h
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/22/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POPConnectViewController.h"

@import CoreTelephony;

@interface POPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) CTCallCenter *callCenter;
@property (strong, nonatomic) id callingDelegate;


@end
