//
//  WBViewController.m
//  SinaWeiBoSDKDemo
//
//  Created by Wang Buping on 11-12-7.
//  Copyright (c) 2011 Sina. All rights reserved.
//

#import "SinaWeiBoSDKDemoViewController.h"

// TODO:
// Define your AppKey & AppSecret here to eliminate the errors

//#define kWBSDKDemoAppKey
//#define kWBSDKDemoAppSecret

#ifndef kWBSDKDemoAppKey
#error
#endif

#ifndef kWBSDKDemoAppSecret
#error
#endif

#define kWBAlertViewLogOutTag 100
#define kWBAlertViewLogInTag  101

@interface SinaWeiBoSDKDemoViewController (Private)

- (void)dismissTimelineViewController;
- (void)presentTimelineViewController:(BOOL)animated;
- (void)presentTimelineViewControllerWithoutAnimation;

@end

@implementation SinaWeiBoSDKDemoViewController

@synthesize weiBoEngine;
@synthesize timeLineViewController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [weiBoEngine setDelegate:nil];
    [weiBoEngine release], weiBoEngine = nil;
    
    [timeLineViewController release], timeLineViewController = nil;
    
    [indicatorView release], indicatorView = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    WBEngine *engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [engine setRootViewController:self];
    [engine setDelegate:self];
    [engine setRedirectURI:@"http://"];
    [engine setIsUserExclusive:NO];
    self.weiBoEngine = engine;
    [engine release];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    logInBtnOAuth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logInBtnOAuth setFrame:CGRectMake(85, 160, 150, 40)];
    [logInBtnOAuth setTitle:@"Log In With OAuth" forState:UIControlStateNormal];
    [logInBtnOAuth addTarget:self action:@selector(onLogInOAuthButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logInBtnOAuth];
    
    logInBtnXAuth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logInBtnXAuth setFrame:CGRectMake(85, 280, 150, 40)];
    [logInBtnXAuth setTitle:@"Log In With XAuth" forState:UIControlStateNormal];
    [logInBtnXAuth addTarget:self action:@selector(onLogInXAuthButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logInBtnXAuth];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setCenter:CGPointMake(160, 240)];
    [self.view addSubview:indicatorView];
    
    if ([weiBoEngine isLoggedIn] && ![weiBoEngine isAuthorizeExpired])
    {
        [self performSelector:@selector(presentTimelineViewControllerWithoutAnimation) withObject:nil afterDelay:0.0];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [indicatorView release], indicatorView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        [logInBtnOAuth setFrame:CGRectMake(165, 80, 150, 40)];
        [logInBtnXAuth setFrame:CGRectMake(165, 160, 150, 40)];
        [indicatorView setCenter:CGPointMake(240, 160)];
    }
    else
    {
        [logInBtnOAuth setFrame:CGRectMake(85, 160, 150, 40)];
        [logInBtnXAuth setFrame:CGRectMake(85, 280, 150, 40)];
        [indicatorView setCenter:CGPointMake(160, 240)];
    }
}

#pragma mark - User Actions

- (void)onLogInOAuthButtonPressed
{
    [weiBoEngine logIn];
}

- (void)onLogInXAuthButtonPressed
{
    WBLogInAlertView *logInView = [[WBLogInAlertView alloc] init];
    [logInView setDelegate:self];
    [logInView show];
    [logInView release];
}

- (void)onLogOutButtonPressed
{
    [weiBoEngine logOut];
}

- (void)dismissTimelineViewController
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)presentTimelineViewController:(BOOL)animated
{
    WBSDKTimelineViewController *controller = [[WBSDKTimelineViewController alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    
    self.timeLineViewController = controller;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"登出" style:UIBarButtonItemStylePlain
                                                               target:self 
                                                               action:@selector(onLogOutButtonPressed)];
    
    
    [controller.navigationItem setLeftBarButtonItem:leftBtn];
    [leftBtn release];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"写微博" style:UIBarButtonItemStylePlain
                                                                target:controller 
                                                                action:@selector(onSendButtonPressed)];
    
    
    [controller.navigationItem setRightBarButtonItem:rightBtn];
    [rightBtn release];
    
    [controller.navigationItem setTitle:@"微博"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [controller release];
    [self presentModalViewController:navController animated:animated];
    [navController release];
}

- (void)presentTimelineViewControllerWithoutAnimation
{
    [self presentTimelineViewController:NO];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kWBAlertViewLogInTag)
    {
        [self presentTimelineViewController:YES];
    }
    else if (alertView.tag == kWBAlertViewLogOutTag)
    {
        [self dismissTimelineViewController];
    }
}

#pragma mark - WBLogInAlertViewDelegate Methods

- (void)logInAlertView:(WBLogInAlertView *)alertView logInWithUserID:(NSString *)userID password:(NSString *)password
{
    [weiBoEngine logInUsingUserID:userID password:password];
    
    [indicatorView startAnimating];
}

#pragma mark - WBEngineDelegate Methods

#pragma mark Authorize

- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    [indicatorView stopAnimating];
    if ([engine isUserExclusive])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"请先登出！" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    [indicatorView stopAnimating];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录成功！" 
													  delegate:self
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogInTag];
	[alertView show];
	[alertView release];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    [indicatorView stopAnimating];
    NSLog(@"didFailToLogInWithError: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登出成功！" 
													  delegate:self
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogOutTag];
	[alertView show];
	[alertView release];
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"请重新登录！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}




@end
