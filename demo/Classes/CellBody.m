//
//  CellBody.m
//  SinaWeiBoSDKDemo
//
//  Created by Singro on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellBody.h"


@implementation CellBody

@synthesize detail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(NSDictionary *)data
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detail = data;
        // get content height    
        CGFloat contentWidth = 255.000;
        UIFont *baseFone     = [UIFont systemFontOfSize:14];
        NSString *content1    = [detail objectForKey:@"text"];
        CGSize  contentSize1  = [content1 sizeWithFont:baseFone constrainedToSize:CGSizeMake(contentWidth, 10000) lineBreakMode:UILineBreakModeWordWrap];
        NSInteger height1 = contentSize1.height;
        
        // Title time
        NSString *date = [detail objectForKey:@"created_at"];
        NSString *outputdate = [self convertDate:date];
        NSLog(@"%@", date);
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(248, 3, 70, 14)];
        //[title setText:[NSString stringWithFormat:@"r:%d c:%d w:%d id:%@", 1, height, height2, wid]];
        [title setFont:[UIFont fontWithName:@"Helvetica" size:9]];
        [title setTextColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
        //[title setBackgroundColor:[UIColor yellowColor]];
        [title setText:outputdate];
        [title setTextAlignment:UITextAlignmentRight];
        [self addSubview:title];
        [title release];
        
        // Content & background
        UIImage *img = [UIImage imageNamed:@"buble.png"];
        
        
        UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(60, 17, 255, height1)];
        [txt setText:[detail objectForKey:@"text"]];
        [txt setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [txt setLineBreakMode:UILineBreakModeWordWrap];
        [txt setNumberOfLines:0];
        [txt setTextAlignment:UITextAlignmentLeft];
        UIColor *org = [UIColor colorWithRed:249.0/255 green:251.0/255 blue:253.0/255 alpha:1];
        [txt setBackgroundColor:org];
        [self addSubview:txt];
        [txt release];
        
        // Retweeted origin
        NSDictionary *retweeted = [detail objectForKey:@"retweeted_status"];
        NSInteger height2_ = 0;
        if (retweeted != NULL) {
            NSString *content2 = [NSString stringWithFormat:@"%@:%@", [[retweeted objectForKey:@"user"] objectForKey:@"screen_name"], [retweeted objectForKey:@"text"]];
            CGSize  contentSize2  = [content2 sizeWithFont:baseFone constrainedToSize:CGSizeMake(contentWidth, 10000) lineBreakMode:UILineBreakModeWordWrap];
            NSInteger height2 = contentSize2.height;
            height2_ = height2;
            
            UILabel *retweetedTxt = [[UILabel alloc] initWithFrame:CGRectMake(60, 17+height1+3, 255, height2)];
            NSString *txt = [NSString stringWithFormat:@"%@:%@", [[retweeted objectForKey:@"user"] objectForKey:@"screen_name"], [retweeted objectForKey:@"text"]];
            [retweetedTxt setText:txt];
            [retweetedTxt setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            [retweetedTxt setLineBreakMode:UILineBreakModeWordWrap];
            [retweetedTxt setNumberOfLines:0];
            [retweetedTxt setTextAlignment:UITextAlignmentLeft];
            UIColor *com = [UIColor colorWithRed:244.0/255 green:243.0/255 blue:253.0/255 alpha:1];
            [retweetedTxt setBackgroundColor:com];
            
            [self addSubview:retweetedTxt];
            [retweetedTxt release];
            
            NSString *picURL = [retweeted objectForKey:@"bmiddle_pic"];
            if (picURL != NULL) {
                UIButton *photo = [[UIButton alloc] initWithFrame:CGRectMake(60, 17+height1+3+height2+3, 75, 75)];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
                [photo setBackgroundImage:image forState:UIControlStateNormal];
                [self addSubview:photo];
                [photo release];
                
            }
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)convertDate:(NSString *)date {
    NSDate *mydate;// = [NSDate dateWithTimeIntervalSinceNow:0];
    //    NSLog(@"%@", mydate);
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    //Tue May 31 17:46:55 +0800 2011
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss zzzz yyyy"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:timeZone];
    //mydate = [dateFormatter dateFromString:@"Tue May 31 17:46:55 +0800 2011"];
    mydate = [dateFormatter dateFromString:date];
    
    NSLog(@"%@", mydate);
    
    NSTimeInterval interval = [mydate timeIntervalSinceNow];
    interval = -interval;
    NSInteger time = 0;
    NSString *result;
    if (interval < 60) {
        time = (NSInteger)interval;
        result = [NSString stringWithFormat:@"%d秒前",time];
    } else if (interval/60 < 60) {
        time = (NSInteger)(interval/60);
        result = [NSString stringWithFormat:@"%d分钟前",time];
    } else if (interval/3600 < 12) {
        time = (NSInteger)(interval/3600);
        result = [NSString stringWithFormat:@"%d小时前", time];
    } else {
        NSDateFormatter *dateFormaterToString = [[NSDateFormatter alloc] init];
        [dateFormaterToString setDateFormat:@"MM-dd HH:mm"];
        [dateFormaterToString setTimeZone:timeZone];
        result =[dateFormaterToString stringFromDate:mydate]; 
    }
    return result;
}

@end
