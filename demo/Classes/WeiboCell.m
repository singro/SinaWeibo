//
//  WeiboCell.m
//  SinaWeiBoSDKDemo
//
//  Created by Singro on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeiboCell.h"


@implementation WeiboCell

@synthesize detail = detail_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(NSDictionary *)detail {
    
    //NSLog(@"%@", detail);
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        // show user avatar
        UIButton *photo = [[UIButton alloc] initWithFrame:CGRectMake(3, 3, 40, 40)];
        
        //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[detail objectForKey:@"user"] objectForKey:@"profile_image_url"]]]];
        UIImage *image = [UIImage imageNamed:@"photo.png"];
        [photo setBackgroundImage:image forState:UIControlStateNormal];
        [photo.layer setCornerRadius:20.0];
        [self addSubview:photo];
        [photo release];
        
        // get content height    
        CGFloat contentWidth = 240.000;
        //UIFont *baseFone     = [UIFont systemFontOfSize:14];
        NSString *content1    = [detail objectForKey:@"text"];
        CGSize  contentSize1  = [content1 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(contentWidth, 10000) lineBreakMode:UILineBreakModeWordWrap];
        NSInteger height1 = contentSize1.height;
        
        // Title User name
        NSString *nameStr = [[detail objectForKey:@"user"] objectForKey:@"screen_name"];
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60, 3, 200, 16)];
        //[title setText:[NSString stringWithFormat:@"r:%d c:%d w:%d id:%@", 1, height, height2, wid]];
        [name setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [name setFont:[UIFont boldSystemFontOfSize:14]];
        //        name.layer.borderColor = [UIColor blackColor].CGColor;
        //        name.layer.borderWidth = 1.0;
        [name setTextColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
        //[title setBackgroundColor:[UIColor yellowColor]];
        [name setText:nameStr];
        [name setTextAlignment:UITextAlignmentLeft];
        [self addSubview:name];
        [name release];
        
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
        
        // weibo txt
        UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(60, 23, 240, height1)];
        [txt setText:[detail objectForKey:@"text"]];
        [txt setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        [txt setLineBreakMode:UILineBreakModeWordWrap];
        [txt setNumberOfLines:0];
        [txt setTextAlignment:UITextAlignmentLeft];
        UIColor *org = [UIColor colorWithRed:249.0/255 green:251.0/255 blue:253.0/255 alpha:0];
        [txt setBackgroundColor:org];
        [self addSubview:txt];
        [txt release];
        
        // weibo image
        NSString *picURL1 = [detail objectForKey:@"bmiddle_pic"];
        if (picURL1 != NULL) {
            UIButton *photo = [[UIButton alloc] initWithFrame:CGRectMake(60, 25+height1, 75, 75)];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL1]]];
            [photo setBackgroundImage:image forState:UIControlStateNormal];
            [self addSubview:photo];
            [photo release];
            height1 = height1 + 77;
        }
        
        // Retweeted origin
        NSDictionary *retweeted = [detail objectForKey:@"retweeted_status"];
        NSInteger height2_ = 0;
        if (retweeted != NULL) {
            NSString *content2 = [NSString stringWithFormat:@"%@:%@", [[retweeted objectForKey:@"user"] objectForKey:@"screen_name"], [retweeted objectForKey:@"text"]];
            CGSize  contentSize2  = [content2 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(contentWidth, 10000) lineBreakMode:UILineBreakModeWordWrap];
            NSInteger height2 = contentSize2.height;
            height2_ = height2 + 30;
            
            UILabel *retweetedTxt = [[UILabel alloc] initWithFrame:CGRectMake(60, height1 + 27 + 15, 240, height2)];
            NSString *txt = [NSString stringWithFormat:@"%@:%@", [[retweeted objectForKey:@"user"] objectForKey:@"screen_name"], [retweeted objectForKey:@"text"]];
            [retweetedTxt setText:txt];
            [retweetedTxt setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            [retweetedTxt setLineBreakMode:UILineBreakModeWordWrap];
            [retweetedTxt setNumberOfLines:0];
            [retweetedTxt setTextAlignment:UITextAlignmentLeft];
            //UIColor *com = [UIColor colorWithRed:244.0/255 green:243.0/255 blue:253.0/255 alpha:1];
            //[retweetedTxt setBackgroundColor:com];
            [retweetedTxt setBackgroundColor:[UIColor clearColor]];
            [self addSubview:retweetedTxt];
            [retweetedTxt release];
            
            NSString *picURL = [retweeted objectForKey:@"bmiddle_pic"];
            if (picURL != NULL) {
                UIButton *photo = [[UIButton alloc] initWithFrame:CGRectMake(60, height1 + 27 + 15 +2 + height2, 75, 75)];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
                [photo setBackgroundImage:image forState:UIControlStateNormal];
                [self addSubview:photo];
                [photo release];
                height2_+=77;
            }
            
            // bubble 
            UIImage *background = [[UIImage imageNamed:@"post_bubble_2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 60, 19, 19)];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:background];
            [imgView setFrame:CGRectMake(50, height1+27, 260, height2_)];
            [self addSubview:imgView];
            [self sendSubviewToBack:imgView];
            
        }
        // Retweet & Comment Num
        //UILabel *retweet = [[UILabel alloc]initWithFrame:CGRectMake(230, 17+height1+3+height2_+3+2, 86, 14)];
        NSInteger cellHeight;
        if (height1 + height2_ < 50) {
            cellHeight = 50;
        } else {
            cellHeight = height1 + height2_ + 27;
        }
        UILabel *retweet = [[UILabel alloc]initWithFrame:CGRectMake(230, cellHeight, 86, 14)];
        NSString *rtStr = [NSString stringWithFormat:@"转发:%@  评论:%@", [detail objectForKey:@"reposts_count"], [detail objectForKey:@"comments_count"]];
        [retweet setText:rtStr];
        [retweet setFont:[UIFont fontWithName:@"Helvetica" size:9]];
        [retweet setTextAlignment:UITextAlignmentRight];
        [self addSubview:retweet];
    }

    // for custom selected color
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btn setFrame:CGRectMake(0, 0, 255, 17+height1+3+height2_+3)];
//    [btn setAlpha:0.4];
//    btn setBackgroundImage:<#(UIImage *)#> forState:<#(UIControlState)#>
    
   return self;
}


- (void)initViewWithDetail:(NSDictionary *)detail {
    ;
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
    //NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    //[dateFormatter setTimeZone:timeZone];
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
        //[dateFormaterToString setTimeZone:timeZone];
        result =[dateFormaterToString stringFromDate:mydate]; 
    }
    return result;
}

@end
