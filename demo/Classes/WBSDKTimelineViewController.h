//
//  WBSDKTimelineViewController.h
//  SinaWeiBoSDKDemo
//
//  Created by Wang Buping on 11-12-15.
//  Copyright (c) 2011 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBEngine.h"
#import "WBSendView.h"
#import "WeiboCell.h"
#import "WeiboDetailViewController.h"
#import "HJObjManager.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"


@interface WBSDKTimelineViewController : UIViewController <EGORefreshTableHeaderDelegate,UITableViewDelegate, UITableViewDataSource, WBEngineDelegate, WBSendViewDelegate, LoadMoreTableFooterDelegate>
{
    NSString *appKey;
    NSString *appSecret;
    
    WBEngine *engine;
    NSMutableArray *timeLine;
    NSString *next_cursor;
//    NSMutableArray *weiboHeight;
    
    UITableView *timeLineTableView;
    UIActivityIndicatorView *indicatorView;
    
    UINavigationController *nav;
    
    HJObjManager* objMan;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreTableFooterView *_loadMoreFooterView;
    BOOL _reloading;
    BOOL _reloading_f;
    
    BOOL isFooter;
}

//@property (assign, nonatomic) HJObjManager * objMan;
@property (nonatomic, retain) NSString *next_cursor;

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)loadMoreTableViewDataSource;
- (void)doneLoadingMoreTableViewData;

@end
