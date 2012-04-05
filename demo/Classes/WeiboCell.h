//
//  WeiboCell.h
//  SinaWeiBoSDKDemo
//
//  Created by Singro on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSDKTimelineViewController.h"
#import "HJObjManager.h"
#import "HJManagedImageV.h"



@interface WeiboCell : UITableViewCell   {
    NSDictionary * detail_;
    HJObjManager *objMan;
}

@property (strong, readwrite) NSDictionary * detail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(NSDictionary *)detail obj:(HJObjManager *)_objMan;  // asynchronous load images
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(NSDictionary *)detail;
- (NSString *)convertDate:(NSString *)date;
@end
