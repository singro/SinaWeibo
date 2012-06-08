//
//  WeiboDetailViewController.m
//  SinaWeiBoSDKDemo
//
//  Created by Singro on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeiboDetailViewController.h"



@implementation WeiboDetailViewController 

@synthesize detail;

- (id)initWithData:(NSDictionary *)data obj:(HJObjManager *)_objMan
{
    self = [super init];
    if (self) {
        self.detail = data;
        objMan = _objMan;
    }
    return self;
}


- (void)back {
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"微博正文"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"green.png"] forBarMetrics:UIBarMetricsDefault];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem *back= [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //back.tintColor=[UIColor colorWithRed:(CGFloat)107.0/255.0 green:(CGFloat)178.0/255.0 blue:(CGFloat)52.0/255.0 alpha:1];
    self.navigationItem.leftBarButtonItem=back;
    [back release];
    
    //draw navi
    //    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [back setFrame:CGRectMake(2, 2, 100, 37)];
    //    [back setTitle:@"Back" forState:UIControlStateNormal];
    //    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:back];
    
    // draw tableview
    WeiboDetailContentViewController *vc = [[WeiboDetailContentViewController alloc] init];
    [vc initWithData:detail obj:objMan];
    vc.view.frame = CGRectMake(0, 50, 320, 367);
    
    [self.view addSubview:vc.view];
    
    //    // draw back
    //    UIButton *backtop = [[UIButton alloc] initWithFrame:CGRectMake(0, 36, 320, 70)];
    //    //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[detail objectForKey:@"user"] objectForKey:@"profile_image_url"]]]];
    //    UIImage *imageback =[UIImage imageNamed:@"feather.png"];
    //    //[backtop setBackgroundColor:[UIColor clearColor]];
    //    [backtop setBackgroundImage:imageback forState:UIControlStateNormal];
    //    [backtop setEnabled:NO];
    //    [self.view addSubview:backtop];
    //    [backtop release];
    
    // draw back
    UIImageView *backtop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feather.png"]];
    //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[detail objectForKey:@"user"] objectForKey:@"profile_image_url"]]]];
    //UIImage *imageback =[UIImage imageNamed:@"feather.png"];
    //[backtop setBackgroundColor:[UIColor clearColor]];
    //[backtop setBackgroundImage:imageback forState:UIControlStateNormal];
    //[backtop setEnabled:NO];
    [backtop setFrame:CGRectMake(0, 0, 320, 70)];
    [self.view addSubview:backtop];
    [backtop release];
    
    // draw header
    // show user avatar
    //    UIButton *photo = [[UIButton alloc] initWithFrame:CGRectMake(3, 3, 40, 40)];
    //    //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[detail objectForKey:@"user"] objectForKey:@"profile_image_url"]]]];
    //    UIImage *image =[UIImage imageNamed:@"iconv.png"];
    //    [photo setBackgroundImage:image forState:UIControlStateNormal];
    //    [self.view addSubview:photo];
    //    [photo release];
    
    // With HJManageImage
    HJManagedImageV *avatar = [[[HJManagedImageV alloc] initWithFrame:CGRectMake(3, 2, 40, 40)] autorelease];
    avatar.tag = 977;
    //[mi setBackgroundColor:[UIColor whiteColor]];
    avatar.layer.cornerRadius = 4;
    avatar.layer.masksToBounds = YES;
    [self.view addSubview:avatar];
    avatar.url = [NSURL URLWithString:[[detail objectForKey:@"user"] objectForKey:@"profile_image_url"]];
    [objMan manage:avatar];
    
    // show user name
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(50+10, 5+5, 200, 18)];
    [name setText:[[detail objectForKey:@"user"] objectForKey:@"screen_name"]];
    [name setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    [name setFont:[UIFont boldSystemFontOfSize:17]];
    [name setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:name];
    [name release];
    
    
    //    // show bio
    //    UILabel *bio = [[UILabel alloc] initWithFrame:CGRectMake(50, 25+40, 200, 24)];
    //    [bio setText:[[detail objectForKey:@"user"] objectForKey:@"description"]];
    //    [bio setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    //    [bio setLineBreakMode:UILineBreakModeWordWrap];
    //    [bio setNumberOfLines:0];
    //    [self.view addSubview:bio];
    //    [bio release];
    
    // draw bottom bar
    UIImage *back_tool =[UIImage imageNamed:@"toolbar.png"];
    UIImageView *backView = [[UIImageView alloc] initWithImage:back_tool];
    [backView setFrame:CGRectMake(0, 374, 320, 44)];
    [self.view addSubview:backView];
    [self.view sendSubviewToBack:backView];
    [self.view bringSubviewToFront:backView];
    [backView release];
    
    
    //UIButton *retweet = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *retweet = [UIButton buttonWithType:UIButtonTypeCustom];
    [retweet setBackgroundImage:[UIImage imageNamed:@"transpond.png"] forState:UIControlStateNormal];
    [retweet setBackgroundImage:[UIImage imageNamed:@"transpond_down.png"] forState:UIControlStateHighlighted];
    [retweet setFrame:CGRectMake(217, 374, 100, 44)];
    //[retweet setTitle:@"Repost" forState:UIControlStateNormal];
    [retweet addTarget:self action:@selector(onRepostButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retweet];
    
    UIButton *comment = [UIButton buttonWithType:UIButtonTypeCustom];
    [comment setBackgroundImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
    [comment setBackgroundImage:[UIImage imageNamed:@"comment_down.png"] forState:UIControlStateHighlighted];
    [comment setFrame:CGRectMake(3, 374, 100, 44)];
    //[comment setTitle:@"Comment" forState:UIControlStateNormal];
    [comment addTarget:self action:@selector(onCommentButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comment];
    
    UIButton *favourate = [UIButton buttonWithType:UIButtonTypeCustom];
    [favourate setBackgroundImage:[UIImage imageNamed:@"favor.png"] forState:UIControlStateNormal];
    [favourate setBackgroundImage:[UIImage imageNamed:@"favor_down.png"] forState:UIControlStateHighlighted];
    [favourate setFrame:CGRectMake(110, 374, 100, 44)];
    [favourate addTarget:self action:@selector(onFavorButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:favourate];
}

- (void)onCommentButtonPressed
{
    NSString *Id = [NSString stringWithFormat:@"%@",[self.detail objectForKey:@"id"]];
    
    WBSendView *sendView = [[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:@"" image:nil weiboType:Comment Id:Id];
    [sendView setDelegate:self];
    
    [sendView show:YES];
    [sendView release];
}

- (void)onRepostButtonPressed
{
    NSString *txt = [NSString stringWithFormat:@" //@%@:%@", [[self.detail objectForKey:@"user"] objectForKey:@"screen_name"], [self.detail objectForKey:@"text"]];
    NSString *Id = [NSString stringWithFormat:@"%@",[self.detail objectForKey:@"id"]];
    WBSendView *sendView = [[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:txt image:nil weiboType:Repost Id:Id];
    [sendView setDelegate:self];
    
    [sendView show:YES];
    [sendView release];
}

- (void)onFavorButtonPressed
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
	
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
	
    //HUD.delegate = self;
    HUD.labelText = @"已收藏";
	
    [HUD show:YES];
	[HUD hide:YES afterDelay:1];
}

#pragma mark - WBSendViewDelegate Methods

- (void)sendViewDidFinishSending:(WBSendView *)view
{
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送成功！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)sendView:(WBSendView *)view didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)sendViewNotAuthorized:(WBSendView *)view
{
    [view hide:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sendViewAuthorizeExpired:(WBSendView *)view
{
    [view hide:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

//  

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
