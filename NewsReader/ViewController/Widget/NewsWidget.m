//
//  NewsWidget.m
//  NewsReader
//
//  Created by 唐有欢 on 15/10/13.
//  Copyright © 2015年 tangtech. All rights reserved.
//

#import "NewsWidget.h"
#import "GetNews.h"
#import "BaseCell.h"
#import "DetailPage.h"

@implementation NewsWidget

- (void)viewDidLoad
{
    self.cellIdentifier = @"NewsCell";
    _cellHeight = 80;
    _pageIndex = 0;
    _hasNextPage = NO;
    self.listData = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
}

- (void)reloadData
{
    // 停止网络请求
    [_operation cancelOp];
    _operation = nil;
    _pageIndex = 0;
    
    // 先清除上次内容
    [self.listData removeAllObjects];
    [super reloadData];
}

- (BOOL)isReloadLocalData
{
    //NSArray *datas = [FxDBManager fetchNews:self.columnInfo.ID];
    
    //[self.listData addObjectsFromArray:datas];
    
    return [super isReloadLocalData];
}

- (void)requestServerOp
{
    NSString *url = [NSString stringWithFormat:NewsURLFmt,
                     self.columnInfo.ID];
    NSDictionary *dictInfo = @{@"url":url,
                               @"body":self.columnInfo.ID,
                               };
    
    _operation = [[GetNews alloc] initWithDelegate:self opInfo:dictInfo];
    [_operation executeOp];
}

- (void)requestNextPageServerOp
{
    NSString *url = [NSString stringWithFormat:NewsURLFmt,
                     self.columnInfo.ID];
    NSString *body = [NSString stringWithFormat:@"pageindex=%@",@(_pageIndex)];
    NSDictionary *dictInfo = @{@"url":url,
                               @"body":body
                               };
    
    _operation = [[GetNews alloc] initWithDelegate:self opInfo:dictInfo];
    [_operation executeOp];
}

- (void)opSuccess:(NSArray *)data
{
    _hasNextPage = YES;
    _operation = nil;
    
    if (_pageIndex == 0) {
        [self.listData removeAllObjects];
    }
    _pageIndex++;
    
    [self.listData addObjectsFromArray:data];
    [self updateUI];
    [self hideIndicator];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row < self.listData.count ? _cellHeight:44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _hasNextPage?self.listData.count+1:self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = nil;
    BaseInfo *info = nil;
    
    if (indexPath.row < self.listData.count) {
        cellIdentifier = self.cellIdentifier;
        info = [self.listData objectAtIndex:indexPath.row];
    }
    else {
        cellIdentifier = @"NewsMoreCell";
        [self requestNextPageServerOp];
    }
    
    BaseCell *cell = (BaseCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray* Objects = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:tableView options:nil];
        
        cell = [Objects objectAtIndex:0];
        [cell initCell];
    }
    [cell setCellData:info];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailPage *page = [[DetailPage alloc] init];
    
    page.newsInfo = [self.listData objectAtIndex:indexPath.row];
    page.hidesBottomBarWhenPushed = YES;
    
    UIViewController *owner =  self.owner;
    [owner.navigationController pushViewController:page animated:YES];
}
@end
