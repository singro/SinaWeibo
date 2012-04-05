//
//  CellBody.h
//  SinaWeiBoSDKDemo
//
//  Created by Singro on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"
#import "HJObjManager.h"

@interface CellBody : UITableViewCell {
    NSDictionary *detail;
    HJObjManager *objMan;
}

@property (strong, readwrite) NSDictionary *detail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(NSDictionary *)data obj:(HJObjManager *)_objMan;  // asynchronous load images
- (NSString *)convertDate:(NSString *)date;
@end
