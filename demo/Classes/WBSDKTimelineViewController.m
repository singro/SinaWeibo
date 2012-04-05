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

//@synthesize objMan;

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
        
        nav = [[UINavigationController alloc] initWithRootViewController:self];
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
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    timeLineTableView = [[UITableView alloc] init];
    [timeLineTableView setDelegate:self];
    [timeLineTableView setDataSource:self];
    [timeLineTableView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:timeLineTableView];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:indicatorView];
    
    //draw navi
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [back setFrame:CGRectMake(2, 2+10, 100, 37)];
    [back setTitle:@"Logout" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    UIButton *write = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [write setFrame:CGRectMake(218, 2+10, 100, 37)];
    [write setTitle:@"Write" forState:UIControlStateNormal];
    [write addTarget:self action:@selector(onSendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:write];

    BOOL hasStatusBar = ![UIApplication sharedApplication].statusBarHidden;
    int height = ((hasStatusBar) ? 20 : 0);
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        [timeLineTableView setFrame:CGRectMake(0, 0, 480, 320 - height - 32)];
        [indicatorView setCenter:CGPointMake(240, 160)];
    }
    else
    {
        [timeLineTableView setFrame:CGRectMake(0, 0+37, 320, 480 - height - 44)];
        [indicatorView setCenter:CGPointMake(160, 240)];
    }
    
    [self refreshTimeline];
    
    // asynchronous load images
    /**/
    // Create the object manager
	objMan = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:20];
	
	//if you are using for full screen images, you'll need a smaller memory cache than the defaults,
	//otherwise the cached images will get you out of memory quickly
	//objMan = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:1];
	
	// Create a file cache for the object manager to use
	// A real app might do this durring startup, allowing the object manager and cache to be shared by several screens
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/weiboimg/"] ;
	HJMOFileCache* fileCache = [[[HJMOFileCache alloc] initWithRootPath:cacheDirectory] autorelease];
	objMan.fileCache = fileCache;
	
	// Have the file cache trim itself down to a size & age limit, so it doesn't grow forever
	fileCache.fileCountLimit = 100;
	fileCache.fileAgeLimit = 60*60*24*7; //1 week
	[fileCache trimCacheUsingBackgroundThread];
    //[fileCache deleteAllFilesInDir:cacheDirectory];
     
    
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
    WBSendView *sendView = [[WBSendView alloc] initWithAppKey:appKey appSecret:appSecret text:@"test" image:[UIImage imageNamed:@"bg.png"] weiboType:Post Id:nil];
    [sendView setDelegate:self];
    
    [sendView show:YES];
    [sendView release];
}

- (void)logout {
    [engine logOut];
    NSLog(@"\n\n\nLogout \n\n");
}
#pragma mark - WBSDKTimelineViewController Private Methods

- (void)refreshTimeline
{
    //NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"1972172260", @"uid", nil];
    [engine loadRequestWithMethodName:@"statuses/home_timeline.json"
                           httpMethod:@"GET"
                               params:nil //param
                         postDataType:kWBRequestPostDataTypeNone
                     httpHeaderFields:nil];
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboDetailViewController *weibo = [[WeiboDetailViewController alloc] initWithData:[timeLine objectAtIndex:indexPath.row] obj:objMan];
//    [weibo initWithData:[timeLine objectAtIndex:indexPath.row]];
    
    //[self.view setFrame:CGRectMake(-100, -300, 320, 480)];
    [[self navigationController] pushViewController:weibo animated:YES];
    //[self presentModalViewController:weibo animated:YES];
    //[nav pushViewController:weibo animated:YES];
    //[self presentModalViewController:weibo animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *detail = [timeLine objectAtIndex:indexPath.row];
    CGFloat contentWidth = 240.000;
    NSString *content1    = [detail objectForKey:@"text"];
    NSString *content2 = [NSString stringWithFormat:@"%@:%@", [[[detail objectForKey:@"retweeted_status"] objectForKey:@"user"]objectForKey:@"screen_name"], [[detail objectForKey:@"retweeted_status"] objectForKey:@"text"]];
    CGSize  contentSize1  = [content1 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(contentWidth, 10000) lineBreakMode:UILineBreakModeWordWrap];
    CGSize  contentSize2  = [content2 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(contentWidth, 10000) lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height1 = contentSize1.height;
    CGFloat height2 = contentSize2.height;
    CGFloat height = 37 + height1;
    if ([detail objectForKey:@"bmiddle_pic"] != NULL) {
        height = height + 75+7;
    }
    if ([detail objectForKey:@"retweeted_status"] != NULL) {
        height = height + 34 + height2;
        if ([[detail objectForKey:@"retweeted_status"] objectForKey:@"bmiddle_pic"] != NULL) {
            height = height + 75 + 2;
        }
    } else if ([detail objectForKey:@"bmiddle_pic"] == NULL) {
        height += 8;
    }
    return height;
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
    NSDictionary *detail = [timeLine objectAtIndex:indexPath.row];
    NSString *cellIndentifier = [NSString stringWithFormat:@"cell_%d", indexPath.row];
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    NSLog(@"%@", cell);
    if (cell == nil)
    {
        //cell = [[[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier data:detail] autorelease];
        cell = [[[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier data:detail obj:objMan] autorelease];
        NSLog(@"%@",cell);
    }
    NSLog(@"%@", cell);
    return cell;
}

#pragma mark - WeiboCellDelegate methods



#pragma mark - WBEngineDelegate Methods

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    [indicatorView stopAnimating];
    //[self.view setAlpha:0.2];
    
//    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    [back setBackgroundColor:[UIColor grayColor]];
//    [back setAlpha:0.6];
//    [self.view addSubview:back];
    NSLog(@"requestDidSucceedWithResult: %@", result);
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        [timeLine addObjectsFromArray:[dict objectForKey:@"statuses"]];
//        NSInteger height = [[[[dict objectForKey:@"statuses"] objectForKey:@"retweeted_status"] objectForKey:@"text"] lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        [timeLineTableView reloadData];
    }
    //NSLog(@"%@", timeLine);
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
