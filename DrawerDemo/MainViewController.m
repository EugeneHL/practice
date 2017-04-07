//
//  MainViewController.m
//  DrawerDemo
//
//  Created by Eugene on 2017/4/6.
//  Copyright © 2017年 Eugene. All rights reserved.
//

#import "MainViewController.h"
#import "MessageViewController.h"
#import "PersonViewController.h"
#import "SceneViewController.h"
#import "MineNavViewController.h"
#import "FirstViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initChildViewControllers];
    
    self.selectedIndex = 0;
    
}

-(void)initChildViewControllers
{
    
//    [self setupController:[[MessageViewController alloc]init] image:@"" selectedImage:@"" title:@"消息"];
//     [self setupController:[[PersonViewController alloc]init] image:@"" selectedImage:@"" title:@"联系人"];
//     [self setupController:[[SceneViewController alloc]init] image:@"" selectedImage:@"" title:@"动态"];

    //修改下面文字大小和颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName,[UIColor colorWithRed:44/255.0 green:185/255.0 blue:176/255.0 alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName,[UIColor colorWithRed:44/255.0 green:185/255.0 blue:176/255.0 alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    //第三级控制器
    FirstViewController *first = [[FirstViewController alloc]init];
    first.title = @"首页";
    UIImage *image3 = [[UIImage imageNamed:@"icon_tabbar_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage3 = [[UIImage imageNamed:@"icon_tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    first.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:image3  selectedImage:selectImage3];
    
    MessageViewController *inforCtrl = [[MessageViewController alloc] init];
    inforCtrl.title = @"连接";
    UIImage *image = [[UIImage imageNamed:@"icon_tabbar_homepage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage = [[UIImage imageNamed:@"icon_tabbar_homepage_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    inforCtrl.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"连接" image:image  selectedImage:selectImage];
    
    
    PersonViewController *appCtrl = [[PersonViewController alloc] init];
    appCtrl.title = @"发现";
    UIImage *image1 = [[UIImage imageNamed:@"icon_tabbar_merchant_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage1 = [[UIImage imageNamed:@"icon_tabbar_merchant_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    appCtrl.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"发现" image:image1 selectedImage:selectImage1];
    
    //我的
    SceneViewController *myCtrl = [[SceneViewController alloc] init];
    myCtrl.title = @"我的";
    UIImage *image2 = [[UIImage imageNamed:@"icon_tabbar_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage2 = [[UIImage imageNamed:@"icon_tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myCtrl.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:image2 selectedImage:selectImage2];
    
    
    //创建数组
    NSArray *viewCtrls = @[first,inforCtrl,appCtrl,myCtrl];
    
    //创建可变数组,存储导航控制器
    NSMutableArray *navs = [NSMutableArray arrayWithCapacity:viewCtrls.count];
    
    //创建二级控制器导航控制器
    for (UIViewController *ctrl in viewCtrls) {
        MineNavViewController *nav = [[MineNavViewController alloc] initWithRootViewController:ctrl];
        
        //将导航控制器加入到数组中
        [navs addObject:nav];
    }
    
    //将导航控制器交给标签控制器管理
    self.viewControllers = navs;

    
}

-(void)setupController:(UIViewController *)childVc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    UIViewController *viewVc = childVc;
    viewVc.tabBarItem.title = title;
    MineNavViewController *nav = [[MineNavViewController alloc]initWithRootViewController:viewVc];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
