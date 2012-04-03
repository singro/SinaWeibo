//
//  WeiboCell.h
//  SinaWeiBoSDKDemo
//
//  Created by Singro on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSDKTimelineViewController.h"



@interface WeiboCell : UITableViewCell   {
    NSDictionary * detail_;
}

@property (strong, readwrite) NSDictionary * detail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(NSDictionary *)detail;//data:(NSMutableArray *)timeLine index:(NSInteger)row;
- (NSString *)convertDate:(NSString *)date;
@end
