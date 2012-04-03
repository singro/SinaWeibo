//
//  CellBody.h
//  SinaWeiBoSDKDemo
//
//  Created by Singro on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellBody : UITableViewCell {
    NSDictionary *detail;
}

@property (strong, readwrite) NSDictionary *detail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(NSDictionary *)detail;
- (NSString *)convertDate:(NSString *)date;
@end
