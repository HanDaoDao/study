//
//  ViewController.m
//  study
//
//  Created by 韩钊 on 2017/11/20.
//  Copyright © 2017年 韩钊. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"
#import "ReactiveObjC.h"
#import "SDWebImage-umbrella.h"
#import "FLAnimatedImage-umbrella.h"
#import "UIImageView+WebCache.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@interface ViewController ()

@property(nonatomic,strong) UIButton *button;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) FLAnimatedImageView *animateImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self test1];
//    [self test2];
//    [self test3];
//    [self test4];

    _imageView = [[UIImageView alloc] init];
    [_imageView setFrame:CGRectMake(85, 100, 200, 200)];
    [self.view addSubview:_imageView];
    
    _animateImageView = [[FLAnimatedImageView alloc] init];
    [_animateImageView setFrame:CGRectMake(85, 400, 200, 200)];
    [self.view addSubview:_animateImageView];
    
    __block UIProgressView *pv;
    
    //1、基本用法
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1513590259646&di=a4ffb8fddf6844c832f1d061fca14b59&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fbba1cd11728b47108ab14228c9cec3fdfd0323b3.jpg"] placeholderImage:[UIImage imageNamed:@"lufei.jpg"]];
    
    //通过progressBar显示下载进度
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1513595824047&di=25c581851452c11a6adc2fd14ac22200&imgtype=0&src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201604%2F09%2F214443sxvr8vo6850c50o8.jpg"] placeholderImage:[UIImage imageNamed:@"lufei.jpg"] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            NSLog(@"%ld--%ld",receivedSize,expectedSize);

        //在渲染时必须在主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            pv = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
            pv.frame = CGRectMake(0, 0, 200, 20);
            pv.center = self.view.center;
            [pv setProgress:0 animated:YES];
            float currentProgress = (float)receivedSize/(float)expectedSize;
            pv.progress = currentProgress;
            [self.view addSubview:pv];
        });

    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        [pv removeFromSuperview];//下载完成时，进度条移除
        NSLog(@"%ld",[[SDImageCache sharedImageCache] getSize]);//观察图片缓存的大小
    }];

    [_animateImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img4.duitang.com/uploads/item/201211/24/20121124112047_KUFxK.gif"]];
    
//    FLAnimatedImageView *gifView = [[FLAnimatedImageView alloc] initWithFrame:self.view.bounds];
//    NSString *urlStr = @"http://7jpnak.com1.z0.glb.clouddn.com/-2_1508812812584_扭蛋机动效3.gif";
//    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    [gifView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
//    gifView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:gifView];

}


/**
 使用RACSubject
 */
-(void)test1{
    RACSubject *subject = [RACSubject subject];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"first:%@",x);
    }];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"second:%@",x);
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
}

/**
 使用RACSignal
 */
-(void)test2{
    __block int num = 0;
    RACSignal* signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        num++;
        [subscriber sendNext:@(num++)];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"one---%@",x);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"two---%@",x);
    }];
    
    
}

/**
 使用RACReplaySubject
 */
-(void)test3{
    RACReplaySubject* replaySubject = [RACReplaySubject subject];
    
    [replaySubject sendNext:@"1、hello"];
    [replaySubject sendNext:@"2、你好"];
    
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"FirstSubscribeNext:%@",x);
    }];
    
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"SecondSubscribeNext:%@",x);
    }];
    
}


/**
 使用RACSequence
 */
-(void)test4{
    RACSignal *signal = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
