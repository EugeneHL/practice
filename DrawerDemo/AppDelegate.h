//
//  AppDelegate.h
//  DrawerDemo
//
//  Created by Eugene on 2017/4/6.
//  Copyright © 2017年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuViewController.h"
#import "DrawerViewController.h"
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) LeftMenuViewController *left;
@property (nonatomic, strong) MainViewController *main;
@property (nonatomic, strong) DrawerViewController *drawer;

@end

