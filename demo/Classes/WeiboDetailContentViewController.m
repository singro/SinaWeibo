//
//  WeiboDetailViewController.m
//  SinaWeiBoSDKDemo
//
//  Created by Singro on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeiboDetailContentViewController.h"

@implementation WeiboDetailContentViewController

@synthesize detail;

- (id)initWithData:(NSDictionary *)data obj:(HJObjManager *)_objMan
{
    self = [super init];
    if (self) {
        self.detail = data;
        objMan = _objMan;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
//    [top setBackgroundColor:[UIColor blueColor]];
//    [self.tableView addSubview:top];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    if (indexPath.row == 1) {
        cell = [[CellHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier data:self.detail];
    }
    if (indexPath.row == 0) {
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[CellBody alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier data:self.detail obj:objMan];
    }
    if (indexPath.row == 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height_ = 1;
    if (indexPath.row == 0) {
        height_ = 70;
    }
    if (indexPath.row == 0) {
        // UILable的宽度
        CGFloat contentWidth = 255.000;
        // 根据字体计算高度
        UIFont *baseFone     = [UIFont systemFontOfSize:13];
        // 获取UILabel将要显示的数据
        NSString *content1    = [detail objectForKey:@"text"];
        NSString *content2 = [[detail objectForKey:@"retweeted_status"] objectForKey:@"text"];
        // 1000仅仅是个约数，只要保证content能显示完整就行
        // 在IB中要把UILabel的换行类型设置为UILineBreakModeWordWrap
        CGSize  contentSize1  = [content1 sizeWithFont:baseFone constrainedToSize:CGSizeMake(contentWidth, 10000) lineBreakMode:UILineBreakModeWordWrap];
        CGSize  contentSize2  = [content2 sizeWithFont:baseFone constrainedToSize:CGSizeMake(contentWidth, 10000) lineBreakMode:UILineBreakModeWordWrap];
        CGFloat height = contentSize1.height + contentSize2.height + 20;  // extra 60 for retweeted pic
        if ([[detail objectForKey:@"retweeted_status"] objectForKey:@"bmiddle_pic"] != NULL) {
            height += 80;
        }
        if (height <= 50) 
            height_ = 50;
        else 
            height_ = height;
    } else {
        height_ = 60;
    }
    return height_ + 70;
}


@end
