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
@synthesize next_cursor;

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
    
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    timeLineTableView = [[UITableView alloc] init];
    [timeLineTableView setDelegate:self];
    [timeLineTableView setDataSource:self];
    UIImage *backV = [[UIImage imageNamed:@"background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImageView *backView = [[UIImageView alloc] initWithImage:backV];
    [backView setFrame:CGRectMake(0, 0, 320, 640)];
    [timeLineTableView setBackgroundView:backView];
    
    [self.view addSubview:timeLineTableView];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:indicatorView];
    
//    //draw navi
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [back setFrame:CGRectMake(2, 2+10, 100, 37)];
//    [back setTitle:@"Logout" forState:UIControlStateNormal];
//    [back addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:back];
//    UIButton *write = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [write setFrame:CGRectMake(218, 2+10, 100, 37)];
//    [write setTitle:@"Write" forState:UIControlStateNormal];
//    [write addTarget:self action:@selector(onSendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:write];

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
     
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - timeLineTableView.bounds.size.height, self.view.frame.size.width, timeLineTableView.bounds.size.height)];
		view.delegate = self;
		[timeLineTableView addSubview:view];
		_refreshHeaderView = view;
		//[view release];
    }
    
    //  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    if (_loadMoreFooterView == nil) {		
		LoadMoreTableFooterView *view = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, timeLineTableView.contentSize.height, self.view.frame.size.width, timeLineTableView.bounds.size.height)];
		view.delegate = self;
        NSLog(@"%f",timeLineTableView.bounds.size.height);
		[timeLineTableView addSubview:view];
		_loadMoreFooterView = view;
		[view release];
		
	}
    
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
    WBSendView *sendView = [[WBSendView alloc] initWithAppKey:appKey appSecret:appSecret text:@"" image:nil weiboType:Post Id:nil];
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
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"20", @"count",
                           nil];
    [engine loadRequestWithMethodName:@"statuses/home_timeline.json"
                           httpMethod:@"GET"
                               params:param
                         postDataType:kWBRequestPostDataTypeNone
                     httpHeaderFields:nil];
}

- (void)loadMore
{
    //NSString *latestId = [[timeLine objectAtIndex:[timeLine count] - 1] objectForKey:@"id"];
//    NSLog(@"latestid: %lld", *((int64_t*)latestId)-1);
    //NSLog(@"max_id:%lld",*((int64_t*)latestId));
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           next_cursor, @"max_id",
                           @"20", @"count",
//                           @"1", @"page",
                           nil];
    [engine loadRequestWithMethodName:@"statuses/home_timeline.json"
                           httpMethod:@"GET"
                               params:param
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
    NSLog(@"%@", detail);
    NSString *cellIndentifier = [NSString stringWithFormat:@"cell_%d", indexPath.row];
    //WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    WeiboCell *cell = (WeiboCell *)[tableView cellForRowAtIndexPath:indexPath];
    //NSLog(@"%@", cell);
    if (cell == nil)
    {
        //cell = [[[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier data:detail] autorelease];
        cell = [[[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier data:detail obj:objMan] autorelease];
        NSLog(@"%@",cell);
    }
    //NSLog(@"%@", cell);
    return cell;
}

#pragma mark - WeiboCellDelegate methods


#pragma mark Data Source Loading / Reloading Methods

- (void)loadMoreTableViewDataSource{
	NSLog(@"loadMoreTableViewDataSource");
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    _reloading_f = YES;
    [self loadMore];
    
	
	
}

- (void)doneLoadingMoreTableViewData{
	
	//  model should call this when its done loading
    [timeLineTableView reloadData];
	_reloading_f = NO;
	[_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:timeLineTableView];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    //isFooter = TRUE;
    NSArray *indexex = [timeLineTableView indexPathsForVisibleRows];
    NSIndexPath *ip = [indexex objectAtIndex:0];
    NSLog(@"scrollViewDidScroll\n\nrow:%d\n\n", ip.row);
    if (ip.row < 10) {
        isFooter = FALSE;
    } else {
        isFooter = TRUE;
    }
	if (isFooter) {
        [_loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];
    } else {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //isFooter = TRUE;
    NSArray *indexex = [timeLineTableView indexPathsForVisibleRows];
    NSIndexPath *ip = [indexex objectAtIndex:0];
    if (ip.row < 10) {
        isFooter = FALSE;
    } else {
        isFooter = TRUE;
    }
    NSLog(@"scrollViewDidEndDragging\n");
	if (isFooter) {
        [_loadMoreFooterView loadMoreScrollViewDidEndDragging:scrollView];
    } else {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark LoadMoreTableFooterDelegate Methods

- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view {
    //isFooter = TRUE;
    NSLog(@"loadMoreTableFooterDidTriggerRefresh\n");
	//[self reloadTableViewDataSource];
    [self loadMoreTableViewDataSource];
//	[self performSelector:@selector(doneLoadingMoreTableViewData) withObject:nil afterDelay:0];
    
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view {
    //isFooter = TRUE;
    NSLog(@"loadMoreTableFooterDataSourceIsLoading\n");
	return _reloading_f;
}



#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
    
    [self refreshTimeline];
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	
	
}

- (void)doneLoadingTableViewData{
	[timeLineTableView reloadData];
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:timeLineTableView];
	
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	//isFooter = FALSE;
    NSLog(@"egoRefreshTableHeaderDidTriggerRefresh\n");
	[self reloadTableViewDataSource];
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	//isFooter = FALSE;
    NSLog(@"egoRefreshTableHeaderDataSourceIsLoading\n");
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	//isFooter = FALSE;
    NSLog(@"egoRefreshTableHeaderDataSourceLastUpdated\n");
	return [NSDate date]; // should return date data source was last changed
	
}


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
    NSLog(@"\n\n1111Loading000 head:   %d", _reloading);
    NSLog(@"\n\n1111Loading000 footer: %d", _reloading_f);
    //[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
    if ([timeLine count] != 0) {
        NSArray *indexex = [timeLineTableView indexPathsForVisibleRows];
        NSIndexPath *ip = [indexex objectAtIndex:0];
        if (ip.row < 10) {
            isFooter = FALSE;
        } else {
            isFooter = TRUE;
        }
        NSLog(@"scrollViewDidEndDragging\n");
        if (isFooter) {
            [self performSelector:@selector(doneLoadingMoreTableViewData) withObject:nil afterDelay:0];
        } else {
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
        }
    }
    
    
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        NSLog(@"\n\nLoading000 head:   %d", _reloading);
        NSLog(@"\n\nLoading000 footer: %d", _reloading_f);
        if (next_cursor == nil) {
            next_cursor = @"";
        }
        next_cursor = [NSString stringWithFormat:@"%@", [dict objectForKey:@"next_cursor"]];
        if ([next_cursor retainCount] < 2) {
            [next_cursor retain];
        }
        if (!isFooter) {
            [timeLine removeAllObjects];
        }
        NSLog(@"dict: \n%@", dict);
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
