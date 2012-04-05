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
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //draw navi
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [back setFrame:CGRectMake(2, 2, 100, 37)];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    // draw tableview
    WeiboDetailContentViewController *vc = [[WeiboDetailContentViewController alloc] init];
    [vc initWithData:detail obj:objMan];
    vc.view.frame = CGRectMake(0, 50+40, 320, 300);
    
    [self.view addSubview:vc.view];
    
    // draw header
    // show user avatar
    UIButton *photo = [[UIButton alloc] initWithFrame:CGRectMake(3, 3+40, 40, 40)];
    //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[detail objectForKey:@"user"] objectForKey:@"profile_image_url"]]]];
    UIImage *image =[UIImage imageNamed:@"photo.png"];
    [photo setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:photo];
    [photo release];
    
    // show user name
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(50, 5+40, 200, 14)];
    [name setText:[[detail objectForKey:@"user"] objectForKey:@"screen_name"]];
    [name setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [self.view addSubview:name];
    [name release];
    
    // show bio
    UILabel *bio = [[UILabel alloc] initWithFrame:CGRectMake(50, 25+40, 200, 24)];
    [bio setText:[[detail objectForKey:@"user"] objectForKey:@"description"]];
    [bio setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [bio setLineBreakMode:UILineBreakModeWordWrap];
    [bio setNumberOfLines:0];
    [self.view addSubview:bio];
    [bio release];
    
    // draw bottom bar
    UIButton *retweet = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [retweet setFrame:CGRectMake(3, 370, 100, 44)];
    [retweet setTitle:@"Repost" forState:UIControlStateNormal];
    [retweet addTarget:self action:@selector(onRepostButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retweet];
    
    UIButton *comment = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [comment setFrame:CGRectMake(217, 370, 100, 44)];
    [comment setTitle:@"Comment" forState:UIControlStateNormal];
    [comment addTarget:self action:@selector(onCommentButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comment];
    
    UIButton *favourate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [favourate setFrame:CGRectMake(110, 370, 100, 44)];
    [favourate setTitle:@"Favour" forState:UIControlStateNormal];
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

- (void)onSendButtonPressed
{
    WBSendView *sendView = [[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:@"" image:[UIImage imageNamed:@"bg.png"] weiboType:Comment Id:nil];
    [sendView setDelegate:self];
    
    [sendView show:YES];
    [sendView release];
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
