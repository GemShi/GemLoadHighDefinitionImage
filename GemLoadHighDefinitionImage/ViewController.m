//
//  ViewController.m
//  GemLoadHighDefinitionImage
//
//  Created by GemShi on 2017/3/10.
//  Copyright © 2017年 GemShi. All rights reserved.
//

#import "ViewController.h"
#import "ImageCell.h"
#define k_WIDTH [UIScreen mainScreen].bounds.size.width
#define k_HEIGHT [UIScreen mainScreen].bounds.size.height

static NSString *cellID = @"cellIdentify";
static CGFloat cell_HEIGHT = 130.f;

typedef BOOL(^RunloopBlock)(void);

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSMutableArray *tasks;//任务数组
@property(nonatomic,assign)NSUInteger maxQueueLength;//最大任务数
@end

@implementation ViewController
{
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createUI];
    
    //默认添加在default中
    //创建刚开始运行时有点卡顿，原因：定时器一启动添加在default模式上了，程序一启动对UI进行操作tracking模式，tracking会阻塞default模式。
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeMethod) userInfo:nil repeats:YES];
    
    self.tasks = [[NSMutableArray alloc]init];
    self.maxQueueLength = 18;
    
    [self addRunloopObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)timeMethod
{
    
}

#pragma mark - <关于runloop的方法和函数>
//添加任务的方法
-(void)addTask:(RunloopBlock)unit
{
    //添加任务到数组
    [self.tasks addObject:unit];
    //保证只会渲染屏幕上的图片
    if (self.tasks.count > self.maxQueueLength) {
        [self.tasks removeObjectAtIndex:0];
    }
}

void CallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    printf("__CallBack__\n");
    //每次来到这里，就加载一张图片，就往数组里面拿任务处理
    ViewController *vc = (__bridge ViewController *)info;
    if (vc.tasks.count == 0) {
        return;
    }
    BOOL result = NO;
    while (result == NO && vc.tasks.count) {
        //取出任务
        RunloopBlock unit = vc.tasks.firstObject;
        //执行任务
        result = unit();
        //删除已经完成的任务
        [vc.tasks removeObjectAtIndex:0];
    }
}

-(void)addRunloopObserver
{
    //拿到当前runloop
    //凡是在CoreFoundation里面看到Ref，就代表指针！
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    
    /**
     参数说明：
     CFOptionFlags activities:枚举类型
     CFRunLoopObserverCallBack callout:函数指针
     CFRunLoopObserverContext *context:给callback函数传递的参数
     */
    static CFRunLoopObserverRef observer;
    
    //定义一个结构体类型context
    CFRunLoopObserverContext context = {
        /**
         CFIndex	version;
         void *	info;信息
         const void *(*retain)(const void *info);处理哪个函数
         void	(*release)(const void *info);
         CFStringRef	(*copyDescription)(const void *info);
         */
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    //创建观察者
    observer = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &CallBack, &context);
    
    //添加观察者
    CFRunLoopAddObserver(runloop, observer, kCFRunLoopDefaultMode);
    
    //必须释放观察者
    CFRelease(observer);
}

#pragma mark - 布局
-(void)createUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, k_WIDTH, k_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - tableDelegateMethod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [self addTask:^BOOL{
        cell.imgView1.image = [UIImage imageNamed:@"kobe.jpeg"];
        return YES;
    }];
    [self addTask:^BOOL{
        cell.imgView2.image = [UIImage imageNamed:@"kobe.jpeg"];
        return YES;
    }];
    [self addTask:^BOOL{
        cell.imgView3.image = [UIImage imageNamed:@"kobe.jpeg"];
        return YES;
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cell_HEIGHT;
}

@end
