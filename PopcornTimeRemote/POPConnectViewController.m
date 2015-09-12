//
//  POPConnectViewController.m
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/23/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import "POPConnectViewController.h"
#import "POPControlView.h"
#import "POPTypeSwitchView.h"
#import "MBProgressHUD.h"

@interface POPConnectViewController ()

@end

@implementation POPConnectViewController


@synthesize volumeStepper, controlPad;



- (id)initWithHost:(NSString *)host
              port:(int)port
              user:(NSString *)user
          password:(NSString *)password
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.host = host;
        self.port = port;
        self.user = user;
        self.pass = password;
        self.mode = POPCornTimeRemoteTypeMovie;
        self.currentViewStack = [@[@"main-browser"] mutableCopy];
        self.volume = 0.8;
        
        // Remove this once series nav bug is fixed in PopcornTime
        self.fixSeriesNavBug = kBugFix;
    }
    return self;
}



#pragma mark - Load View


- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundColor)];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    backgroundImageView.image = [UIImage imageNamed: @"background.jpg"];
    backgroundImageView.alpha = 0.7f;
    [self.view addSubview: backgroundImageView];
    
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [backgroundImageView addSubview:blurEffectView];
    
    
    controlPad = [[DFSRemoteControlView alloc] initWithFrame: CGRectMake((self.view.frame.size.width/2)-200, (self.view.frame.size.height/4), 400, 400)];
    controlPad.delegate = self;
    [self.view addSubview: controlPad];
    

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: self action: @selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    [self setupPreviousInterfaceItems];
    
    [self setupVolumeStepper];
}




- (void)back {
    
    [self.navigationController popViewControllerAnimated: YES];
}



- (void)setupPreviousInterfaceItems {
    
    self.typeSwitch = [[POPTypeSwitchView alloc] initWithFrameAndTitles:CGRectMake(0, 60, self.view.frame.size.width, 44) titles:@[NSLocalizedString(@"Movies", nil), NSLocalizedString(@"TV Series", nil)]];
    self.typeSwitch.delegate = self;
    [self.view addSubview:self.typeSwitch];
    
    //
    
    self.playToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playToggle setTitle:NSLocalizedString(@"Toggle Playstate", nil) forState:UIControlStateNormal];
    [self.playToggle setTitleColor:UIColorFromRGB(kBackgroundColor) forState:UIControlStateNormal];
    [self.playToggle setBackgroundColor:UIColorFromRGB(kDefaultColor)];
    
    [self.playToggle addTarget:self action:@selector(handlePlay) forControlEvents:UIControlEventTouchUpInside];
    
    self.playToggle.frame = CGRectMake(0, (self.view.frame.size.height - 64) - 62, self.view.frame.size.width, 62);
    self.playToggle.alpha = 0.0;
    
    [self.view addSubview:self.playToggle];
    
    //
    
    self.tvSeriesPrev = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tvSeriesPrev setTitle:NSLocalizedString(@"Prev season", nil) forState:UIControlStateNormal];
    self.tvSeriesPrev.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.tvSeriesPrev setTitleColor:UIColorFromRGB(kDefaultColor) forState:UIControlStateNormal];
    self.tvSeriesPrev.frame = CGRectMake(20, 100, 140, 30);
    [self.tvSeriesPrev addTarget:self action:@selector(handleSeriesNav:) forControlEvents:UIControlEventTouchUpInside];
    [self.tvSeriesPrev setHidden:YES];
    
    [self.view addSubview:self.tvSeriesPrev];
    
    //
    
    self.tvSeriesNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tvSeriesNext setTitle:NSLocalizedString(@"Next season", nil) forState:UIControlStateNormal];
    self.tvSeriesNext.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.tvSeriesNext setTitleColor:UIColorFromRGB(kDefaultColor) forState:UIControlStateNormal];
    self.tvSeriesNext.frame = CGRectMake(160, 100, 140, 30);
    [self.tvSeriesNext addTarget:self action:@selector(handleSeriesNav:) forControlEvents:UIControlEventTouchUpInside];
    [self.tvSeriesNext setHidden:YES];
    
    [self.view addSubview:self.tvSeriesNext];
    
    //
    
    self.category = [[POPFilterSelectView alloc] initWithFrameAndTitle:CGRectMake(40, 120, 140, 30) title:@"Genre" filter:@"All"];
    self.category.delegate = self;
    
    [self.view addSubview:self.category];
    
    //
    
    self.sort = [[POPFilterSelectView alloc] initWithFrameAndTitle:CGRectMake(230, 120, 140, 30) title:@"Sort by" filter:@"Popularity"];
    self.sort.delegate = self;
    
    [self.view addSubview:self.sort];
    
    //
    
    self.genres = @[@"All", @"Action", @"Adventure", @"Animation", @"Biography", @"Comedy", @"Crime", @"Documentary", @"Drama", @"Family", @"Fantasy", @"Film-Noir", @"History", @"Horror", @"Music", @"Musical", @"Mystery", @"Romance", @"Sci-Fi", @"Short", @"Sport", @"Thriller", @"War", @"Western"];
    self.genres_tv = @[@"All", @"Action", @"Adventure", @"Animation", @"Children", @"Comedy", @"Crime", @"Documentary", @"Drama", @"Family", @"Fantasy", @"Game Show", @"Home And Garden", @"Horror", @"Mini Series", @"Mystery", @"News", @"Reality", @"Romance", @"Science Fiction", @"Soap", @"Special Interest", @"Sport", @"Suspense", @"Talk Show", @"Thriller", @"Western"];
    
    //
    
    self.categoryList = [[POPFilterListView alloc] initWithFrameAndFilters:CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height) filters:self.genres];
    self.categoryList.delegate = self;
    
    [self.navigationController.view addSubview:self.categoryList];
    
    //
    
    self.ordering = @[@"Popularity", @"Date", @"Year", @"Rating"];
    
    self.ordering_tv = @[@"Popularity", @"Updated", @"Year", @"Name", @"Rating"];
    
    
    
    self.sortList = [[POPFilterListView alloc] initWithFrameAndFilters:CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height) filters:self.ordering];
    self.sortList.delegate = self;
    
    [self.navigationController.view addSubview:self.sortList];
    
    //
    
    self.cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cover setFrame:self.view.bounds];
    self.cover.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    self.cover.alpha = 0;
    self.cover.userInteractionEnabled = NO;
    [self.cover addTarget:self action:@selector(handleCover) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.cover];
    
    //
    
    [self setTitle:NSLocalizedString(@"Popcorn Time Remote", nil)];

}

- (void)setupVolumeStepper {
    
    // customize uicontrols exposed via property
    self.volumeStepper = [[PKYStepper alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2) - 150, self.view.frame.size.height-100, 300, 50)];
    self.volumeStepper.maximum = 1.0f;
    self.volumeStepper.minimum = 0.0f;
    self.volumeStepper.hidesDecrementWhenMinimum = YES;
    self.volumeStepper.hidesIncrementWhenMaximum = YES;
    self.volumeStepper.buttonWidth = 60.0f;

    self.volumeStepper.value = self.volume;
    [self.volumeStepper setBorderWidth:0.0f];
    self.volumeStepper.stepInterval = 0.1f;
    self.volumeStepper.countLabel.layer.borderWidth = 0.0f;
    [self.volumeStepper setButtonFont: [UIFont systemFontOfSize: 22]];
    [self.volumeStepper setLabelFont: [UIFont systemFontOfSize: 22]];
    self.volumeStepper.countLabel.textColor = [UIColor lightGrayColor];
    
    UIColor *buttonBackgroundColor = [UIColor clearColor];
    
    self.volumeStepper.incrementButton.layer.borderWidth = 1.0f;
    self.volumeStepper.incrementButton.layer.borderColor = buttonBackgroundColor.CGColor;
    [self.volumeStepper.incrementButton setBackgroundColor:buttonBackgroundColor];
    self.volumeStepper.incrementButton.layer.cornerRadius = 5.0f;
    
    self.volumeStepper.decrementButton.layer.borderWidth = 1.0f;
    self.volumeStepper.decrementButton.layer.borderColor = buttonBackgroundColor.CGColor;
    [self.volumeStepper.decrementButton setBackgroundColor:buttonBackgroundColor];
    self.volumeStepper.decrementButton.layer.cornerRadius = 5.0f;

    [self.volumeStepper setButtonTextColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    __weak typeof(self) weakSelf = self;
    
    self.volumeStepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {

        int value = roundf(count*10);
        
        stepper.countLabel.text = [NSString stringWithFormat:@" %i", value];
    };
    
    
    // Volume Increased
    self.volumeStepper.incrementCallback = ^(PKYStepper *stepper, float count) {
        
        [weakSelf selectedCommand: POPControlViewIncreaseVolumeCommand];
    };
    
    
    // Volume Decreased
    self.volumeStepper.decrementCallback = ^(PKYStepper *stepper, float count) {
        
        [weakSelf selectedCommand: POPControlViewDecreaseVolumeCommand];
    };
    
    
    
    [self.volumeStepper setup];
    [self.view addSubview:self.volumeStepper];

    
}


#pragma mark - View Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    //
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(handleSearch)];
    self.navigationItem.rightBarButtonItem = searchBtn;
    
    //
    
    self.listener = [[POPNetworking alloc] init];
    
    [self.listener connect:self.host port:self.port user:kPopcornUser password:kPopcornPass];
    
    [self.navigationItem setHidesBackButton:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated
{
    if (self.searchBar) {
        [self.searchBar removeFromSuperview];
        
        [self.viewStackTimer invalidate];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initializeController];
}


- (void)handleCover
{
    [self hideSearch];
    [self hideCover];
}

- (void)hideCover
{
    self.cover.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 0.0;
    }];
}

- (void)showCover
{
    self.cover.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 1.0;
    }];
}

- (void)handleSeriesNav:(id)sender
{
    if (sender == self.tvSeriesNext) {
        if (self.listener) {
            [self.listener send:@"nextseason" params:nil];
        }
    } else if(sender == self.tvSeriesPrev) {
        if (self.listener) {
            [self.listener send:@"previousseason" params:nil];
        }
    }
}

- (void)selectedFilter:(POPFilterListView *)filter
                 index:(int)index
{
    if (filter == self.categoryList) {
        
        if (self.mode == POPCornTimeRemoteTypeMovie){
            
            [self.category setFilterName:[self.genres objectAtIndex:index]];
        
            [self sendCommand:@"filtergenre" params:@[[self.genres objectAtIndex:index]]];
            
        } else if(self.mode == POPCornTimeRemoteTypeSeries) {
            
            [self.category setFilterName:[self.genres_tv objectAtIndex:index]];
            
            [self sendCommand:@"filtergenre" params:@[[self.genres_tv objectAtIndex:index]]];
        }
        
    } else if (filter == self.sortList) {
        
        if (self.mode == POPCornTimeRemoteTypeMovie){
            
            [self.sort setFilterName:[self.ordering objectAtIndex:index]];
        
            [self sendCommand:@"filtersorter" params:@[[self.ordering objectAtIndex:index]]];
            
        } else if(self.mode == POPCornTimeRemoteTypeSeries) {
            
            [self.sort setFilterName:[self.ordering_tv objectAtIndex:index]];
            
            [self sendCommand:@"filtersorter" params:@[[self.ordering_tv objectAtIndex:index]]];
        }
    }
}

- (void)sendCommand:(NSString *)command params:(NSArray *)params
{
    if (self.listener) {
        [self.listener send:command params:params];
    }
}

- (void)selectedFilter:(POPFilterSelectView *)filter
{
    if (filter == self.category) {
        
        [self.categoryList show];
        
    } else if(filter == self.sort) {
        
        [self.sortList show];
        
    }
}


- (void)executeCommand:(NSNumber *)command {
    
    NSLog(@"Command: %@", command);
    
    [self selectedCommand: (POPControlViewCommand)command.integerValue];
}

- (void)selectedCommand:(POPControlViewCommand)command
{
    switch (command) {
            
        case POPControlViewEnterCommand:

            [self sendCommand:@"enter" params:nil];
            
        break;
        case POPControlViewUpCommand:
            
            [self sendCommand:@"up" params:nil];
            
        break;
            
        case POPControlViewDownCommand:

            [self sendCommand:@"down" params:nil];

        break;
            
        case POPControlViewLeftCommand:

            [self sendCommand:@"left" params:nil];

        break;
            
        case POPControlViewRightCommand:

            [self sendCommand:@"right" params:nil];

        break;
            
        case POPControlViewBackCommand:
            
            if (!self.fixSeriesNavBugActive) {
                [self sendCommand:@"back" params:nil];
            } else {
                [self sendCommand:@"showslist" params:nil];
                self.fixSeriesNavBugActive = NO;
                
                [self clearSearch];
                [self hideSearch];
            }

        break;
            
        case POPControlViewMuteCommand:

            [self sendCommand:@"togglemute" params:nil];

        break;
            
        case POPControlViewIncreaseVolumeCommand:
            
            self.volume += 0.1;
            if (self.volume > 1.0) {
                self.volume = 1.0;
            }
            
            [self sendCommand:@"setvolume" params:@[@(self.volume)]];

        break;
            
        case POPControlViewDecreaseVolumeCommand:

            self.volume -= 0.1;
            if (self.volume < 0.0) {
                self.volume = 0.0;
            }
            
            [self sendCommand:@"setvolume" params:@[@(self.volume)]];

        break;
    }
}

- (void)selectedType:(POPTypeSwitchView *)type
               index:(int)index
{
    if (index == 0) {
        
        [self sendCommand:@"movieslist" params:nil];
        [self.tvSeriesNext setHidden:YES];
        [self.tvSeriesPrev setHidden:YES];
        
        [self.categoryList updateList:self.genres];
        [self.sortList updateList:self.ordering];
        
        [self.category setFilterName:[self.genres objectAtIndex:0]];
        [self.sort setFilterName:[self.ordering objectAtIndex:0]];
        
        self.mode = POPCornTimeRemoteTypeMovie;
        
    } else {
        
        [self sendCommand:@"showslist" params:nil];
        
        [self.categoryList updateList:self.genres_tv];
        [self.sortList updateList:self.ordering_tv];
        
        [self.category setFilterName:[self.genres_tv objectAtIndex:0]];
        [self.sort setFilterName:[self.ordering_tv objectAtIndex:0]];
        
        self.mode = POPCornTimeRemoteTypeSeries;
    }
    
    [self clearSearch];
}


- (void)initializeController
{
    [self updateViewStackWithDelay:.5];
    
    int __block responsCount = 4;
    BOOL __block hadError = NO;
    
    // lets get everything
    [self.listener send:@"getgenres" params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        

        NSDictionary *results = responseObject;

        NSArray *list = [results objectForKey: @"genres"];


        if (list) {
            self.genres = [list copy];
            
            [self.categoryList updateList:self.genres];
        }
        
        responsCount--;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hadError = YES;
        responsCount--;
    }];
    
    [self.listener send:@"getsorters" params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *results = responseObject;

        NSArray *list = [results objectForKey: @"sorters"];

        
        if (list) {
            self.ordering = [list copy];
            
            [self.sortList updateList:self.ordering];
        }
        
        responsCount--;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hadError = YES;
        responsCount--;
    }];
    
    [self.listener send:@"getgenres_tv" params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *results = (NSArray *)responseObject;
        NSArray *list = [results objectAtIndex:0];
        
        if (list) {
            self.genres_tv = [list copy];
        }
        
        responsCount--;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hadError = YES;
        responsCount--;
    }];
    
    [self.listener send:@"getsorters_tv" params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *results = (NSArray *)responseObject;

        NSLog(@"TV Sorters: %@", results);

        NSArray *list = [results objectAtIndex:0];
        
        if (list) {
            self.ordering_tv = [list copy];
        }
        
        responsCount--;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hadError = YES;
        responsCount--;
    }];
    
    // Reset to movielist so we know where we are
    [self sendCommand:@"movieslist" params:nil];
}


- (void)updateViewStackWithDelay:(float)delay
{
    if (self.viewStackTimer) {
        [self.viewStackTimer invalidate];
    }
    
    self.viewStackTimer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                           target:self
                                                         selector:@selector(handleViewStackTimer:)
                                                         userInfo:nil
                                                          repeats:YES];
    
}

- (void)handleViewStackTimer:(NSTimer *)timer
{
    [self updateViewStack:NO];
}

- (BOOL)viewStackHasChanged:(NSArray *)stack
{
    if (!self.currentViewStack) {
        return YES;
    }
    
    if (stack.count != self.currentViewStack.count) {
        return YES;
    }
    
    for (NSInteger i = 0; i < stack.count; i++) {
        NSString *view = [self.currentViewStack objectAtIndex:i];
        NSString *c_view = [stack objectAtIndex:i];
        if (![view isEqualToString:c_view]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)enableSeasonNav:(BOOL)enable
{
    if (enable) {
        [self.tvSeriesNext setHidden:NO];
        [self.tvSeriesPrev setHidden:NO];
    } else {
        [self.tvSeriesNext setHidden:YES];
        [self.tvSeriesPrev setHidden:YES];
    }
}

- (void)enableVideoControls:(BOOL)enable
{
    if (enable) {
        [self playToggle].alpha = 1;
        [self.control enableVideoControls:YES];
    } else {
        [self playToggle].alpha = 0;
        [self.control enableVideoControls:NO];
    }
}

- (void)handleViewStack:(NSArray *)stack
{
    
    if ([self viewStackHasChanged:stack]) {
        
        self.fixSeriesNavBugActive = NO;
        
        [self enableSeasonNav:NO];
        
        NSString *current_stack;
        
        if (stack.count == 1) {
            
            [self enableVideoControls:NO];
            
            
        } else if(stack.count == 2) {
            NSLog(@"We are 1 step in %@", [stack objectAtIndex:1]);
            
            current_stack = [stack objectAtIndex:1];
            
            [self enableVideoControls:NO];
            
            // Bug fix in PopcornTime
            if ([current_stack isEqualToString:@"shows-container-contain"]) {
                
                if (self.fixSeriesNavBug) {
                    self.fixSeriesNavBugActive = YES;
                    NSLog(@"TRIGGERING BUG FIX");
                }
                // Show series nav
                [self enableSeasonNav:YES];
            }
            
        } else if(stack.count == 3) {
            NSLog(@"We are 2 steps in %@", [stack objectAtIndex:2]);
            current_stack = [stack objectAtIndex:2];
            
            if ([current_stack isEqualToString:@"player"]) {
                [self enableVideoControls:YES];
            } else {
                [self enableVideoControls:NO];
            }
        }
        
        self.currentViewStack = [stack mutableCopy];
    }

}

- (void)updateViewStack:(BOOL)showHud
{
    
    MBProgressHUD *hud;
    
    if (showHud) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.5];
        hud.labelText = NSLocalizedString(@"Initializing controller...", nil);
    
        [hud show:YES];
    }
    
    [self.listener send:@"getviewstack" params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *stack = responseObject;

        NSArray *stack_list = [stack objectForKey: @"viewstack"];

        
        [self handleViewStack:stack_list];
        
        if (showHud) {
            [hud hide:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (showHud) {
            [hud hide:YES];
        }
    }];
}



- (void)updatePlayerView
{
    [self sendCommand:@"getviewstack" params:nil];
}

- (void)handlePlay
{
    [self sendCommand:@"toggleplaying" params:nil];
}

- (void)handleSearch
{
    if (self.hasSearched) {
        
        [self clearSearch];
        
        [self sendCommand:@"clearsearch" params:nil];
        
    } else {
        
        [self showSearch];
        [self showCover];
    }
}

- (void)clearSearch
{
    if (self.hasSearched) {
        self.hasSearched = NO;
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"search"];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar setHidden:YES];
    [self.searchBar resignFirstResponder];
    [self hideCover];
}

- (void)hideSearch
{
    [self.searchBar setHidden:YES];
    [self.searchBar resignFirstResponder];
}

- (void)showSearch
{
    if (!self.searchBar) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:self.navigationController.navigationBar.bounds];
        self.searchBar.showsCancelButton = YES;
        self.searchBar.placeholder = NSLocalizedString(@"Search", nil);
        self.searchBar.backgroundColor = UIColorFromRGB(kBackgroundColor);
        [self.navigationController.navigationBar addSubview:self.searchBar];
        self.searchBar.delegate = self;
        [self.searchBar setHidden:NO];
    } else {
        [self.searchBar setHidden:NO];
    }
    
    [self.searchBar becomeFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text length] > 0) {
        
        // TODO: do not hide instead, check for clear search
        [self sendCommand:@"filtersearch" params:@[searchBar.text]];
        
        [self.searchBar setHidden:YES];
        [self.searchBar setText:@""];
        [self.searchBar resignFirstResponder];
        [self hideCover];
        
        self.hasSearched = YES;
        
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"close-search"]];
    }
}



@end
