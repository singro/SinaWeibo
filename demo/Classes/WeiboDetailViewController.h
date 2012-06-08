//
//  WeiboDetailViewController.h
//  SinaWeiBoSDKDemo
//
//  Created by Singro on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboDetailContentViewController.h"
#import "WBSendView.h"
#import "WBEngine.h"
#import "AppKey.h"
#import "HJObjManager.h"
#import "MBProgressHUD.h"

@interface WeiboDetailViewController : UIViewController <WBEngineDelegate,WBSendViewDelegate, MBProgressHUDDelegate> {
    NSDictionary *detail;
    HJObjManager *objMan;
}

@property (strong, readwrite) NSDictionary *detail;

- (id)initWithData:(NSDictionary *)data obj:(HJObjManager *)_objMan;

@end
