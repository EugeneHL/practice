//
//  LeftMenuViewController.m
//  DrawerDemo
//
//  Created by Eugene on 2017/4/6.
//  Copyright © 2017年 Eugene. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "DrawerViewController.h"
#import "AppDelegate.h"
#import "OtherViewController.h"
@interface LeftMenuViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LeftMenuViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:@"开机自启",@"消息通知",@"校区设置",@"帮助中心",@"功能介绍",@"缓存清理",@"意见反馈", nil];
        self.dataArray = dataArray;
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.image = [UIImage imageNamed:@"leftbackiamge"];
    [self.view addSubview:imageview];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    self.tableView = tableview;
    [self setFooterView];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
    UIButton *iconView = [[UIButton alloc]initWithFrame:CGRectMake(20, 60, 60, 60)];
    iconView.layer.cornerRadius = 30;
    iconView.layer.masksToBounds = YES;
    iconView.backgroundColor = [UIColor greenColor];
    [iconView addTarget:self action:@selector(iconClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:iconView];
    
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}

-(void)iconClick
{
    
}

-(void)setFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 30, self.view.width, 30)];
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 120, 30)];
    shareLabel.text = @"一键分享";
    shareLabel.textColor = [UIColor whiteColor];
    shareLabel.font = [UIFont systemFontOfSize:15];
    shareLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:shareLabel];
    [self.view addSubview:footerView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"leftCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate ];
    
    OtherViewController *other = [[OtherViewController alloc] init];
    other.titleString = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    other.hidesBottomBarWhenPushed = YES;
    [delegate.drawer closeLeftView];
    [delegate.main.selectedViewController pushViewController:other animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
