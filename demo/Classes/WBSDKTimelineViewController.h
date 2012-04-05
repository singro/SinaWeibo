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


@interface WBSDKTimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, WBEngineDelegate, WBSendViewDelegate>
{
    NSString *appKey;
    NSString *appSecret;
    
    WBEngine *engine;
    NSMutableArray *timeLine;
//    NSMutableArray *weiboHeight;
    
    UITableView *timeLineTableView;
    UIActivityIndicatorView *indicatorView;
    
    UINavigationController *nav;
    
    HJObjManager* objMan;
}

//@property (assign, nonatomic) HJObjManager * objMan;

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret;

@end
