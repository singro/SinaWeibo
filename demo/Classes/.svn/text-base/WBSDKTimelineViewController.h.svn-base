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

@interface WBSDKTimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, WBEngineDelegate, WBSendViewDelegate>
{
    NSString *appKey;
    NSString *appSecret;
    
    WBEngine *engine;
    NSMutableArray *timeLine;
    
    UITableView *timeLineTableView;
    UIActivityIndicatorView *indicatorView;
}

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret;

@end
