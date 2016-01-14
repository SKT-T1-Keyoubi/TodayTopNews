//
//  ViewController.m
//  小项目之仿今日头条导航标题栏
//
//  Created by LoveQiuYi on 15/12/27.
//  Copyright © 2015年 LoveQiuYi. All rights reserved.
//

#import "ViewController.h"
#import "sugViewController.h"
#import "hotViewController.h"
#import "videoViewController.h"
#import "societyViewController.h"
#import "subViewController.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
static CGFloat const titleHeight = 50;
//假设有导航条
static CGFloat const navHeight = 70;
@interface ViewController ()<UIScrollViewDelegate>
//标题ScrollView
@property (nonatomic,weak) UIScrollView * titleScrollView;
//内容scrollView
@property (nonatomic,weak) UIScrollView * contentScrollView;
//标题中的按钮
@property (nonatomic,weak) UIButton * selTitlebutton;

@property (nonatomic,strong) NSMutableArray * buttons;
@end

@implementation ViewController
-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //临时创建一个navigationBar
    CGRect rect = CGRectMake(0, 5, screenWidth, titleHeight);
    UINavigationBar * bar = [[UINavigationBar alloc]initWithFrame:rect];
    //bar.backgroundColor = [UIColor redColor];
    [bar pushNavigationItem:[self makeNavItem] animated:YES];
    
    [self.view addSubview:bar];
    //设置头标题栏
    [self setTitleScrollView];
    //设置内容
    [self setupContentScrollView];
    //添加自控制器
    [self addChildViewController];
    //设置标题
    [self setTitle];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * screenWidth, 0);
    //支持整页滑动
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;

}
-(UINavigationItem *) makeNavItem{
    UINavigationItem * navigationItem = [[UINavigationItem alloc]initWithTitle:@"今日头条"];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancle)];
    [navigationItem setLeftBarButtonItem:leftButton];
    [navigationItem setRightBarButtonItem:rightButton];
    
    
    return navigationItem;
}
-(void) add{
    NSLog(@"add");
}
-(void) cancle{
    NSLog(@"cancle");
}
#pragma mark - 设置头标题栏
-(void) setTitleScrollView{
    //先判断有没有导航栏
    CGFloat y = self.navigationController ? navHeight : 50;
    CGRect rect = CGRectMake(0, y, screenWidth, titleHeight);
    UIScrollView * titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    titleScrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:titleScrollView];
    self.titleScrollView = titleScrollView;
    
}
#pragma mark - 设置内容
-(void) setupContentScrollView{
    CGRect rect = CGRectMake(0, self.titleScrollView.frame.size.height+50, screenWidth, screenHeight);
    UIScrollView * contentScrollView = [[UIScrollView alloc]initWithFrame:rect];
    [self.view addSubview:contentScrollView];
    self.contentScrollView = contentScrollView;
}
#pragma mark - 加入子控制器
-(void) addChildViewController{
    sugViewController * vc = [[sugViewController alloc]init];
    vc.title = @"推荐";
    
    [self addChildViewController:vc];
    hotViewController * vc1 = [[hotViewController alloc]init];
    vc1.title = @"热点";
    
    [self addChildViewController:vc1];
    videoViewController * vc2 = [[videoViewController alloc]init];
    vc2.title = @"视频";
    [self addChildViewController:vc2];

    societyViewController * vc3 = [[societyViewController alloc]init];
    vc3.title = @"社会";
    [self addChildViewController:vc3];

    sugViewController * vc4 = [[sugViewController alloc]init];
    vc4.title = @"建议";
    [self addChildViewController:vc4];

    
}
#pragma mark - 设置标题
-(void) setTitle{
    //获取自控制器的个数
    NSUInteger count = self.childViewControllers.count;
    CGFloat x = 0;
    CGFloat w = 100;
    CGFloat h = titleHeight;
    for (int i = 0; i<count; i++) {
        UIViewController * vc = self.childViewControllers[i];
        //设置标题的位置
        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton * button = [[UIButton alloc]initWithFrame:rect];
        //按钮的标签
        button.tag = i;
        //设置标题为VC的title
        [button setTitle:vc.title forState:UIControlStateNormal];
        //设置字体颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置字体大小
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
        [self.buttons addObject:button];
        [self.titleScrollView addSubview:button];
        if(i == 0){
            [self click:button];
        }
    }
    //设置ScrollView的contentSize大小
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
}
#pragma mark - 按钮点击时间改变contentScrollView的值
-(void) click:(UIButton *) button{
    NSUInteger i = button.tag;
    CGFloat x = i * screenWidth;
    //改变按钮
    [self setTitleBtn:button];
    //转到下一个viewController
    [self setOnechildViewController:i];
    //移动childViewController
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
}

#pragma  mark - 改变按钮
-(void) setTitleBtn:(UIButton *) button{
    [self.selTitlebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selTitlebutton.transform = CGAffineTransformIdentity;
    //文字变红
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //放大的效果,放大1.5倍
    button.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.selTitlebutton = button;
    [self setUpTitleCenter:button];
    
}
-(void) setOnechildViewController:(NSUInteger) i{
    CGFloat x = i * screenWidth;
    UIViewController * vc = self.childViewControllers[i];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, screenWidth, screenHeight - self.contentScrollView.frame.origin.y);
    [self.contentScrollView addSubview:vc.view];
}
//实现一个移动后标题居中
-(void) setUpTitleCenter:(UIButton *) button{
    //判断ScrollView的contentoffset的值
    CGFloat offset = button.center.x - screenWidth * 0.5 ;
    //在当前的左边
    if(offset < 0){
        offset = 0;
    }
    CGFloat maxOffset = self.titleScrollView.contentSize.width - screenWidth;
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}
#pragma mark - 利用协议解决滑动contentViewController
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger i = self.contentScrollView.contentOffset.x / screenWidth;
    [self setTitleBtn:self.buttons[i]];
    [self setOnechildViewController:i];
}
#pragma mark - 实现字体颜色大小的渐变
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    //定义一个两个变量控制左右按钮的渐变
    NSInteger left = offset/screenWidth;
    NSInteger right = 1 + left;
    UIButton * leftButton = self.buttons[left];
    UIButton * rightButton = nil;
    if (right < self.buttons.count) {
        rightButton = self.buttons[right];
    }
    //切换左右按钮
    CGFloat scaleR = offset/screenWidth - left;
    CGFloat scaleL = 1 - scaleR;
    //左右按钮的缩放比例
    CGFloat tranScale = 1.2 - 1 ;
    //宽和高的缩放(渐变)
    leftButton.transform = CGAffineTransformMakeScale(scaleL * tranScale + 1, scaleL * tranScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(scaleR * tranScale + 1, scaleR * tranScale + 1);
    //颜色的渐变
    UIColor * rightColor = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
    UIColor * leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
    //重新设置颜色
    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
