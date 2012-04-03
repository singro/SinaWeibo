//
//  WBSDKTimelineViewController.m
//  SinaWeiBoSDKDemo
//
//  Created by Wang Buping on 11-12-15.
//  Copyright (c) 2011 Sina. All rights reserved.
//

#import "WBSDKTimelineViewController.h"

@interface WBSDKTimelineViewController (Private)

- (void)refreshTimeline;

@end

@implementation WBSDKTimelineViewController

#pragma mark - WBSDKTimelineViewController Life Circle

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret
{
    if (self = [super init])
    {
        appKey = [theAppKey retain];
        appSecret = [theAppSecret retain];
        
        engine = [[WBEngine alloc] initWithAppKey:appKey appSecret:appSecret];
        [engine setDelegate:self];
        
        timeLine = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    
    [appKey release], appKey = nil;
    [appSecret release], appSecret = nil;
    
    [engine setDelegate:nil];
    [engine release], engine = nil;
    
    [timeLine release], timeLine = nil;
    
    [timeLineTableView setDelegate:nil];
    [timeLineTableView setDataSource:nil];
    [timeLineTableView release], timeLineTableView = nil;
    
    [indicatorView release], indicatorView = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    timeLineTableView = [[UITableView alloc] init];
    [timeLineTableView setDelegate:self];
    [timeLineTableView setDataSource:self];
    [timeLineTableView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:timeLineTableView];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:indicatorView];

    BOOL hasStatusBar = ![UIApplication sharedApplication].statusBarHidden;
    int height = ((hasStatusBar) ? 20 : 0);
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        [timeLineTableView setFrame:CGRectMake(0, 0, 480, 320 - height - 32)];
        [indicatorView setCenter:CGPointMake(240, 160)];
    }
    else
    {
        [timeLineTableView setFrame:CGRectMake(0, 0, 320, 480 - height - 44)];
        [indicatorView setCenter:CGPointMake(160, 240)];
    }
    
    [self refreshTimeline];
    
    [indicatorView startAnimating];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [timeLineTableView setDelegate:nil];
    [timeLineTableView setDataSource:nil];
    [timeLineTableView release], timeLineTableView = nil;
    
    [indicatorView release], indicatorView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    BOOL hasStatusBar = ![UIApplication sharedApplication].statusBarHidden;
    int height = (hasStatusBar) ? 20 : 0;
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        [timeLineTableView setFrame:CGRectMake(0, 0, 480, 320 - height - 32)];
        [indicatorView setCenter:CGPointMake(240, 160)];
    }
    else
    {
        [timeLineTableView setFrame:CGRectMake(0, 0, 320, 480 - height - 44)];
        [indicatorView setCenter:CGPointMake(160, 240)];
    }
}

#pragma mark - WBSDKTimelineViewController User Actions

- (void)onSendButtonPressed
{
    WBSendView *sendView = [[WBSendView alloc] initWithAppKey:appKey appSecret:appSecret text:@"test" image:[UIImage imageNamed:@"bg.png"]];
    [sendView setDelegate:self];
    
    [sendView show:YES];
    [sendView release];
}

#pragma mark - WBSDKTimelineViewController Private Methods

- (void)refreshTimeline
{
    [engine loadRequestWithMethodName:@"statuses/home_timeline.json"
                           httpMethod:@"GET"
                               params:nil
                         postDataType:kWBRequestPostDataTypeNone
                     httpHeaderFields:nil];
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 66;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timeLine count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Timeline Cell"];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Timeline Cell"] autorelease];
    }
    
    NSDictionary *detail = [timeLine objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[[detail objectForKey:@"user"] objectForKey:@"screen_name"]];
    [cell.detailTextLabel setText:[detail objectForKey:@"text"]];
    
    return cell;
}

#pragma mark - WBEngineDelegate Methods

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    [indicatorView stopAnimating];
    NSLog(@"requestDidSucceedWithResult: %@", result);
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        [timeLine addObjectsFromArray:[dict objectForKey:@"statuses"]];
        [timeLineTableView reloadData];
    }
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    [indicatorView stopAnimating];
    NSLog(@"requestDidFailWithError: %@", error);
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

@end
