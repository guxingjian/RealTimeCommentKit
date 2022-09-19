//
//  ViewController.m
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/9.
//

#import "ViewController.h"
#import "SFStockDetailsRTCFacadeClass.h"
#import "SFStockDetailsRTCDataSource.h"

@interface SFTestObject : NSObject

@end

@implementation SFTestObject

- (void)dealloc{
    NSLog(@"SFTestObject dealloc");
}

@end

@interface SFTestVC : UIViewController

@end

@implementation SFTestVC

- (void)dealloc{
    NSLog(@"SFTestVC dealloc");
}

@end

@interface ViewController ()

@property(nonatomic, strong)UIView* rtcContentView;
@property(nonatomic, strong)SFStockDetailsRTCFacadeClass* rtcFacade;
@property(nonatomic, strong)UILabel* labelTimeInterval;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(!self.rtcFacade){
        
        UIButton* btnAction = [[UIButton alloc] initWithFrame:CGRectMake(100, 500, 100, 70)];
        btnAction.backgroundColor = [UIColor blueColor];
        [btnAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnAction];
        
        UIButton* btnStopAction = [[UIButton alloc] initWithFrame:CGRectMake(100, 620, 100, 70)];
        btnStopAction.backgroundColor = [UIColor blueColor];
        [btnStopAction addTarget:self action:@selector(btnStopAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnStopAction];
        
        UILabel* labelTimeInterval = [[UILabel alloc] initWithFrame:CGRectMake(280, 500, 100, 70)];
        labelTimeInterval.backgroundColor = [UIColor grayColor];
        labelTimeInterval.font = [UIFont systemFontOfSize:15];
        labelTimeInterval.textColor = [UIColor blackColor];
        labelTimeInterval.textAlignment = NSTextAlignmentCenter;
        labelTimeInterval.text = @"5";
        [self.view addSubview:labelTimeInterval];
        self.labelTimeInterval = labelTimeInterval;
        
        UIView* rtcContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
        rtcContentView.backgroundColor = [UIColor blueColor];
        [self.view addSubview:rtcContentView];
        self.rtcContentView = rtcContentView;
        
        self.rtcFacade = [[SFStockDetailsRTCFacadeClass alloc] initWithCommentContainerView:rtcContentView];
        self.rtcFacade.status = SFRealTimeCommentStatus_Running;
    }
}

- (void)btnAction:(UIButton*)btnAction{
    btnAction.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btnAction.enabled = YES;
    });
    
    if(SFRealTimeCommentStatus_Running == self.rtcFacade.status){
        self.rtcFacade.status = SFRealTimeCommentStatus_Paused;
    }else{
        self.rtcFacade.status = SFRealTimeCommentStatus_Running;
    }
}

- (void)btnStopAction:(UIButton*)btnAction{
    btnAction.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btnAction.enabled = YES;
    });
    
    if(SFRealTimeCommentStatus_Running == self.rtcFacade.status){
        self.rtcFacade.status = SFRealTimeCommentStatus_Stop;
    }else{
        self.rtcFacade.status = SFRealTimeCommentStatus_Running;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    NSInteger timeInterval[5] = {1, 2, 3, 4, 5};
    
    CGPoint pt = [[touches anyObject] locationInView:self.view];
    CGFloat distance = self.view.bounds.size.width/5;
    
    NSInteger index = pt.x / distance;
    if(index < 5){
        SFStockDetailsRTCDataSource* retDataSource = (SFStockDetailsRTCDataSource*)self.rtcFacade.commentListDataSource;
        retDataSource.resetTimeInterval = timeInterval[index];
        
        self.labelTimeInterval.text = [NSString stringWithFormat:@"%ld", timeInterval[index]];
    }
}

@end
