//
//  WBViewController.h
//  SinaWeiBoSDKDemo
//
//  Created by Wang Buping on 11-12-7.
//  Copyright (c) 2011 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "WBSendView.h"
#import "WBLogInAlertView.h"
#import "WBSDKTimelineViewController.h"

@interface SinaWeiBoSDKDemoViewController : UIViewController <WBEngineDelegate, UIAlertViewDelegate, WBLogInAlertViewDelegate> {
    WBEngine *weiBoEngine;
    
    WBSDKTimelineViewController *timeLineViewController;
    UIActivityIndicatorView *indicatorView;
    
    UIButton *logInBtnOAuth;
    UIButton *logInBtnXAuth;
}

@property (nonatomic, retain) WBEngine *weiBoEngine;
@property (nonatomic, retain) WBSDKTimelineViewController *timeLineViewController;

@end
