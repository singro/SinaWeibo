//
//  WeiboDetailViewController.m
//  SinaWeiBoSDKDemo
//
//  Created by Singro on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeiboDetailViewController.h"


@implementation WeiboDetailViewController 

@synthesize detail;

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.detail = data;
    }
    return self;
}


- (void)back {
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //draw navi
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [back setFrame:CGRectMake(2, 2, 100, 37)];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    // draw tableview
    WeiboDetailContentViewController *vc = [[WeiboDetailContentViewController alloc] init];
    [vc initWithData:detail];
    vc.view.frame = CGRectMake(0, 50+40, 320, 300);
    
    [self.view addSubview:vc.view];
    
    // draw header
    // show user avatar
    UIButton *photo = [[UIButton alloc] initWithFrame:CGRectMake(3, 3+40, 40, 40)];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[detail objectForKey:@"user"] objectForKey:@"profile_image_url"]]]];
    [photo setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:photo];
    [photo release];
    
    // show user name
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(50, 5+40, 200, 14)];
    [name setText:[[detail objectForKey:@"user"] objectForKey:@"screen_name"]];
    [name setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [self.view addSubview:name];
    [name release];
    
    // show bio
    UILabel *bio = [[UILabel alloc] initWithFrame:CGRectMake(50, 25+40, 200, 24)];
    [bio setText:[[detail objectForKey:@"user"] objectForKey:@"description"]];
    [bio setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [bio setLineBreakMode:UILineBreakModeWordWrap];
    [bio setNumberOfLines:0];
    [self.view addSubview:bio];
    [bio release];
    
    // draw bottom bar
    UIButton *retweet = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [retweet setFrame:CGRectMake(0, 370, 150, 44)];
    [retweet setTitle:@"Retweet" forState:UIControlStateNormal];
    [self.view addSubview:retweet];
    
    UIButton *comment = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [comment setFrame:CGRectMake(170, 370, 150, 44)];
    [comment setTitle:@"Comment" forState:UIControlStateNormal];
    [self.view addSubview:comment];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
