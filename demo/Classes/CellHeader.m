//
//  CellHeader.m
//  SinaWeiBoSDKDemo
//
//  Created by Singro on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellHeader.h"

@implementation CellHeader

@synthesize detail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(NSDictionary *)data
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detail = data;
        // show user avatar
        UIButton *photo = [[UIButton alloc] initWithFrame:CGRectMake(3, 3, 40, 40)];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[detail objectForKey:@"user"] objectForKey:@"profile_image_url"]]]];
        [photo setBackgroundImage:image forState:UIControlStateNormal];
        [self addSubview:photo];
        [photo release];
        
        // show user name
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 14)];
        [name setText:[[detail objectForKey:@"user"] objectForKey:@"screen_name"]];
        [name setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        [self addSubview:name];
        [name release];
        
        // show bio
        UILabel *bio = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, 200, 24)];
        [bio setText:[[detail objectForKey:@"user"] objectForKey:@"description"]];
        [bio setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [bio setLineBreakMode:UILineBreakModeWordWrap];
        [bio setNumberOfLines:0];
        [self addSubview:bio];
        [bio release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
