//
//  DrawerViewController.m
//  DrawerDemo
//
//  Created by Eugene on 2017/4/6.
//  Copyright © 2017年 Eugene. All rights reserved.
//

#import "DrawerViewController.h"



@interface DrawerViewController ()<UIGestureRecognizerDelegate>

{
    CGFloat _scalef;  //实时横向位移
}

@property (nonatomic,assign) CGFloat leftTableviewW;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UITableView *leftTableview;

@property (nonatomic, assign) CGFloat screenW;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, strong) UIButton *coverBtn;

@end

@implementation DrawerViewController

-(instancetype)initWithMainVC:(UIViewController *)mainVC andLeftVC:(UIViewController *)leftVC andLeftWidth:(CGFloat)leftWidth
{
    if (self = [super init]) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.speedf = vSpeedFloat;
        
        self.mainVC = mainVC;
        self.leftVC = leftVC;
        self.maxWidth = leftWidth;
        
        //滑动手势
        self.pan = [[UIPanGestureRecognizer  alloc] initWithTarget:self action:@selector(handlePan:)];
        ;
        [self.mainVC.view addGestureRecognizer:self.pan];
        [self.pan setCancelsTouchesInView:YES];
        self.pan.delegate = self;
        
        self.leftVC.view.hidden = YES;
        [self.view addSubview:self.leftVC.view];
        
        //蒙版
        UIView *view = [[UIView alloc] init];
        view.frame = self.leftVC.view.bounds;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        self.contentView = view;
        
        //获取左侧tableView
        for (UIView *view in self.leftVC.view.subviews) {
            if ([view isKindOfClass:[UITableView class]]) {
                self.leftTableview = (UITableView *)view;
            }
        }
        
        self.leftTableview.backgroundColor = [UIColor clearColor];
        self.leftTableview.frame = CGRectMake(0, 0, kScreenWidth - kMainPageDistance, kScreenHeight);
        //设置左侧tableView的初始位置和缩放系数
        self.leftTableview.transform  = CGAffineTransformMakeScale(kLeftScale, kLeftScale);
        self.leftTableview.center = CGPointMake(kLeftCenterX, kScreenHeight *0.5);
        
        [self.view addSubview:self.mainVC.view];
        self.closed = YES;//初始时侧滑窗关闭
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.leftVC.view.hidden = NO;
}

#pragma mark --- 滑动手势
-(void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint point  = [pan translationInView:self.view];
    _scalef = point.x *self.speedf + _scalef;
    
    BOOL needMoveWithTap = YES; //是否需要跟随手势移动
    if ((self.mainVC.view.x <= 0 && _scalef <= 0) || (self.mainVC.view.x >= kScreenWidth - kMainPageDistance  &&  _scalef >= 0)) {
        //边界值管控
        _scalef = 0;
        needMoveWithTap = NO;
    }
    
    //根据视图位置判断是左滑还是右边滑动
    if (needMoveWithTap && (pan.view.frame.origin.x >= 0) && (pan.view.frame.origin.x <=  kScreenWidth - kMainPageDistance)) {
        
        CGFloat recCenterX = pan.view.center.x + point.x *self.speedf;
        if (recCenterX < kScreenWidth *0.5 - 2) {
            recCenterX = kScreenWidth *0.5;
        }
        
        CGFloat recCenterY = pan.view.center.y;
        pan.view.center = CGPointMake(recCenterX, recCenterY);
        
        //scale 1.0 ~ kMainPageScale
        CGFloat scale = 1 - (1 - kMainPageScale)*(pan.view.frame.origin.x /(kScreenWidth - kMainPageDistance));
        pan.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        [pan setTranslation:CGPointMake(0, 0) inView:self.view];
        
        CGFloat leftTabCenterX = kLeftCenterX + ((kScreenWidth - kMainPageDistance) * 0.5 - kLeftCenterX) * (pan.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
        
        //leftScale kLeftScale~1.0
        CGFloat leftScale = kLeftScale + (1 - kLeftScale) * (pan.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
        
        self.leftTableview.center = CGPointMake(leftTabCenterX, kScreenHeight * 0.5);
        self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftScale,leftScale);
        
        //tempAlpha kLeftAlpha~0
        CGFloat tempAlpha = kLeftAlpha - kLeftAlpha * (pan.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
        self.contentView.alpha = tempAlpha;
    }else{
        //超出范围，
        if (self.mainVC.view.x < 0)
        {
            [self closeLeftView];
            _scalef = 0;
        }
        else if (self.mainVC.view.x > (kScreenWidth - kMainPageDistance))
        {
            [self openLeftView];
            _scalef = 0;
        }
    }
    
    //手势结束后修正位置,超过约一半时向多出的一半偏移
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (fabs(_scalef) > vCouldChangeDeckStateDistance)
        {
            if (self.closed)
            {
                [self openLeftView];
            }
            else
            {
                [self closeLeftView];
            }
        }
        else
        {
            if (self.closed)
            {
                [self closeLeftView];
            }
            else
            {
                [self openLeftView];
            }
        }
        _scalef = 0;
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap{
    
    if ((!self.closed) && (tap.state == UIGestureRecognizerStateEnded))
    {
        [UIView beginAnimations:nil context:nil];
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        self.closed = YES;
        
        self.leftTableview.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
        self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,kLeftScale);
        self.contentView.alpha = kLeftAlpha;
        
        [UIView commitAnimations];
        _scalef = 0;
        [self removeSingleTap];
    }
    
}

#pragma mark - 修改视图位置
/**
 @brief 关闭左视图
 */
- (void)closeLeftView
{
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.mainVC.view.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    self.closed = YES;
    
    self.leftTableview.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
    self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,kLeftScale);
    self.contentView.alpha = kLeftAlpha;
    
    [UIView commitAnimations];
    [self removeSingleTap];
}

/**
 @brief 打开左视图
 */
- (void)openLeftView;
{
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kMainPageScale,kMainPageScale);
    self.mainVC.view.center = kMainPageCenter;
    self.closed = NO;
    
    self.leftTableview.center = CGPointMake((kScreenWidth - kMainPageDistance) * 0.5, kScreenHeight * 0.5);
    self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.contentView.alpha = 0;
    
    [UIView commitAnimations];
    [self disableTapButton];
}

#pragma mark - 行为收敛控制
- (void)disableTapButton
{
    for (UIButton *tempButton in [_mainVC.view subviews])
    {
        [tempButton setUserInteractionEnabled:NO];
    }
    //单击
    if (!self.sideslipTapGes)
    {
        //单击手势
        self.sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
        [self.sideslipTapGes setNumberOfTapsRequired:1];
        
        [self.mainVC.view addGestureRecognizer:self.sideslipTapGes];
        self.sideslipTapGes.cancelsTouchesInView = YES;  //点击事件盖住其它响应事件,但盖不住Button;
    }
}

//关闭行为收敛
- (void) removeSingleTap
{
    for (UIButton *tempButton in [self.mainVC.view  subviews])
    {
        [tempButton setUserInteractionEnabled:YES];
    }
    [self.mainVC.view removeGestureRecognizer:self.sideslipTapGes];
    self.sideslipTapGes = nil;
}

/**
 *  设置滑动开关是否开启
 *
 *  @param enabled YES:支持滑动手势，NO:不支持滑动手势
 */

- (void)setPanEnabled: (BOOL) enabled
{
    [self.pan setEnabled:enabled];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if(touch.view.tag == vDeckCanNotPanViewTag)
    {
        //        NSLog(@"不响应侧滑");
        return NO;
    }
    else
    {
        //        NSLog(@"响应侧滑");
        return YES;
    }
}

/*
#pragma mark --- 侧边栏跳转功能
-(void)LeftViewController:(UIViewController  *)didSelectController
{
    UITabBarController  *tabbarVC = (UITabBarController*)self.mainVC;
    UINavigationController *nav  = (UINavigationController *)[tabbarVC selectedViewController];
    didSelectController.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:didSelectController animated:NO];
    [self closeLeftMenu];
}


#pragma mark --- 添加屏幕左侧边缘手势
-(void)addScreenEdgePanGestureRecognizerToView:(UIView *)view
{
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgPanGesture:)];
    pan.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:pan];
}

#pragma mark --- 屏幕左侧边缘手势
-(void)edgPanGesture:(UIScreenEdgePanGestureRecognizer *)pan
{
    CGFloat offsetX = [pan translationInView:pan.view].x;
    if (pan.state == UIGestureRecognizerStateChanged && offsetX <= self.maxWidth) {
        self.mainVC.view.transform = CGAffineTransformMakeTranslation(MAX(offsetX, 0), 0);
        self.leftVC.view.transform = CGAffineTransformMakeTranslation(- self.maxWidth + offsetX, 0);
        
    }else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled ||  pan.state == UIGestureRecognizerStateFailed){
        if (offsetX > _screenW *0.5) {
            [self openLeftMenu];
        }else{
            
        }
    }
}

-(void)panCloseLeftMenu:(UIPanGestureRecognizer *)pan
{
    CGFloat offsetX = [pan translationInView:pan.view].x;
    if (offsetX > 0) return;
    
    if (pan.state == UIGestureRecognizerStateChanged &&  offsetX >= -self.maxWidth) {
        
        CGFloat distance = self.maxWidth + offsetX;
        self.mainVC.view.transform  = CGAffineTransformMakeTranslation(distance, 0);
        self.leftVC.view.transform  = CGAffineTransformMakeTranslation(offsetX, 0);
        
    }else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateCancelled){
    
        if (offsetX > _screenW *0.5) {
            [self openLeftMenu];
        }else{
            [self closeLeftMenu];
        }
    }
}

#pragma mark --- 打开左侧菜单
-(void)openLeftMenu
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.leftVC.view.transform = CGAffineTransformIdentity;
        self.mainVC.view.transform = CGAffineTransformMakeTranslation(self.maxWidth, 0);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self.mainVC.view addSubview:self.coverBtn];
        }
        
    }];
}

#pragma mark --- 关闭左侧菜单
-(void)closeLeftMenu
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.leftVC.view.transform = CGAffineTransformMakeTranslation(-self.maxWidth, 0);
        self.mainVC.view.transform  = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self.coverBtn removeFromSuperview];
        }
        
    }];
}

#pragma mark --- 灰色背景按钮
-(UIButton *)coverBtn
{
    if (!_coverBtn) {
        UIButton *btn = [[UIButton alloc]initWithFrame:self.mainVC.view.bounds];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(closeLeftMenu) forControlEvents:UIControlEventTouchUpInside];
        [btn addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panCloseLeftMenu:)]];
        
    }
    return _coverBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

*/
@end
