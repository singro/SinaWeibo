//
//  WeiboDetailViewController.h
//  SinaWeiBoSDKDemo
//
//  Created by Singro on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboDetailContentViewController.h"

@interface WeiboDetailViewController : UIViewController {
    NSDictionary *detail;
}

@property (strong, readwrite) NSDictionary *detail;

- (id)initWithData:(NSDictionary *)data;

@end
