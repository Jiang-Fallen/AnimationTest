//
//  ViewController.m
//  AnimationTest
//
//  Created by Mr_J on 16/7/7.
//  Copyright © 2016年 Mr_Jiang. All rights reserved.
//

#import "ViewController.h"

#define kTAG_BASE_VALUE 90

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secodView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *fourthView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //离屏后会remove animation，这里重新添加
    [self restartAnimation];
    //程序从后台进入激活状态需要重新添加Animation
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartAnimation) name:@"kAPPEnterForeground" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kAPPEnterForeground" object:nil];
}

- (void)initSubViews{
    [self createSubViews];
    [self restartAnimation];
}

- (void)restartAnimation{
    [self startAnimationForFirstView];
    [self startAnimationForSecodView];
    [self startAnimationForThirdView];
    [self startAnimationForFourthView];
}

- (UIImageView *)createImageViewWithFrame:(CGRect)frame tag:(NSInteger)tag named:(NSString *)name{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.tag = tag;
    imageView.image = [UIImage imageNamed:name];
    return imageView;
}

- (void)createSubViews{
    //1
    CGRect frame = self.firstView.bounds;
    UIImageView *imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE named:@"pic_ceshi2_biaoqian"];
    imageView.layer.anchorPoint = CGPointMake(28.5/ 45.0, 16/ 45.0);
    imageView.frame = frame;
    [self.firstView addSubview:imageView];
    imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE+1 named:@"pic_ceshi2_xingxing1"];
    [self.firstView addSubview:imageView];
    imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE+2 named:@"pic_ceshi2_xingxing2"];
    [self.firstView addSubview:imageView];
    
    //2
    frame = self.secodView.bounds;
    imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE named:@"pic_ceshi1_biaoqian"];
    [self.secodView addSubview:imageView];
    
    frame = CGRectMake(45 - 18, 0, 18, 19.5);
    UIView *contentView = [[UIView alloc]init];
    contentView.layer.anchorPoint = CGPointMake(0, 1);
    contentView.frame = frame;
    contentView.tag = kTAG_BASE_VALUE + 10;
    [self.secodView addSubview:contentView];
    imageView = [self createImageViewWithFrame:contentView.bounds tag:kTAG_BASE_VALUE named:@"pic_ceshi1_qipao(1)"];
    [contentView addSubview:imageView];
    imageView = [self createImageViewWithFrame:contentView.bounds tag:kTAG_BASE_VALUE+1 named:@"pic_ceshi1_zi"];
    imageView.layer.anchorPoint = CGPointMake(0, 1);
    imageView.frame = contentView.bounds;
    [contentView addSubview:imageView];
    
    //3
    frame = self.thirdView.bounds;
    imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE named:@"pic_ceshi3_biaoqian"];
    imageView.layer.anchorPoint = CGPointMake(0.5, 12/ 45.0);
    imageView.frame = frame;
    [self.thirdView addSubview:imageView];
    
    //4
    frame = self.fourthView.bounds;
    imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE named:@"pic_ceshi2_biaoqian"];
    [self.fourthView addSubview:imageView];
    imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE+1 named:@"pic_ceshi2_xingxing1"];
    [self.fourthView addSubview:imageView];
    imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE+2 named:@"pic_ceshi2_xingxing2"];
    [self.fourthView addSubview:imageView];
}

- (void)startAnimationForFirstView{
    id fromValue = [NSNumber numberWithFloat:-M_PI/ 10.0];
    id toValue = [NSNumber numberWithFloat:M_PI/ 10.0];
    UIImageView *imageView = [self.firstView viewWithTag:kTAG_BASE_VALUE];
    [self animationWithView:imageView keyPath:@"transform.rotation.z" fromValue:fromValue toValue:toValue];
    
    fromValue = @1;
    toValue = @0.1;
    imageView = [self.firstView viewWithTag:kTAG_BASE_VALUE + 1];
    [self animationWithView:imageView keyPath:@"opacity" fromValue:fromValue toValue:toValue];
    
    fromValue = @0.1;
    toValue = @1;
    imageView = [self.firstView viewWithTag:kTAG_BASE_VALUE + 2];
    [self animationWithView:imageView keyPath:@"opacity" fromValue:fromValue toValue:toValue];
}

- (void)startAnimationForSecodView{
    id fromValue = [NSNumber numberWithFloat:-M_PI/ 12.0];
    id toValue = [NSNumber numberWithFloat:0];
    NSString *rAnimationKey = @"transform.rotation.z";
    NSString *sAnimationKey = @"transform.scale";
    
    CAAnimation *rAnimation = [self createSAnimationWithKeyPath:rAnimationKey fromValue:fromValue toValue:toValue];
    CAAnimation *sAnimation = [self createSAnimationWithKeyPath:sAnimationKey fromValue:@0.9 toValue:@1];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.repeatCount = HUGE_VALF;
    animationGroup.duration = 1;
    animationGroup.autoreverses = YES;
    animationGroup.animations = @[rAnimation, sAnimation];
    UIView *contentView = [self.secodView viewWithTag:kTAG_BASE_VALUE + 10];
    [contentView.layer addAnimation:animationGroup forKey:nil];
    
    UIImageView *imageView = [contentView viewWithTag:kTAG_BASE_VALUE + 1];
    fromValue = [NSNumber numberWithFloat:0];
    toValue = [NSNumber numberWithFloat:-M_PI/ 30.0];
    CAAnimation *ziAnimation = [self createKAnimationWithKeyPath:rAnimationKey fromValue:fromValue toValue:toValue];
    [imageView.layer addAnimation:ziAnimation forKey:nil];
}

- (void)startAnimationForThirdView{
    id fromValue = [NSNumber numberWithFloat:-M_PI/ 10.0];
    id toValue = [NSNumber numberWithFloat:M_PI/ 10.0];
    UIImageView *imageView = [self.thirdView viewWithTag:kTAG_BASE_VALUE];
    [self animationWithView:imageView keyPath:@"transform.rotation.z" fromValue:fromValue toValue:toValue];
}

- (void)startAnimationForFourthView{
    UIImageView *imageView = [self.fourthView viewWithTag:kTAG_BASE_VALUE];
    id fromValue = [NSValue valueWithCGPoint:CGPointMake(45/ 2 + 1.5, 45/ 2 + 1.5)];
    id toValue = [NSValue valueWithCGPoint:CGPointMake(45/ 2 - 1.5, 45/ 2 - 1.5)];
    [self animationWithView:imageView keyPath:@"position" fromValue:fromValue toValue:toValue duration:0.6];
    
    imageView = [self.fourthView viewWithTag:kTAG_BASE_VALUE + 1];
    fromValue = @1;
    toValue = @0.1;
    [self animationWithView:imageView keyPath:@"opacity" fromValue:fromValue toValue:toValue duration:0.6];
    
    imageView = [self.fourthView viewWithTag:kTAG_BASE_VALUE + 2];
    fromValue = @0.1;
    toValue = @1;
    [self animationWithView:imageView keyPath:@"opacity" fromValue:fromValue toValue:toValue duration:0.6];
}

- (void)animationWithView:(UIView *)view keyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue{
    CAAnimation *animation = [self createAnimationWithKeyPath:keyPath fromValue:fromValue toValue:toValue];
    [view.layer addAnimation:animation forKey:nil];
}

- (void)animationWithView:(UIView *)view
                  keyPath:(NSString *)keyPath
                fromValue:(id)fromValue
                  toValue:(id)toValue
                 duration:(CGFloat)duration{
    CAAnimation *animation = [self createAnimationWithKeyPath:keyPath fromValue:fromValue toValue:toValue];
    animation.duration = duration;
    [view.layer addAnimation:animation forKey:nil];
}

- (CAAnimation *)createSAnimationWithKeyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue{
    CAMediaTimingFunction *mediaTiming = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.timingFunction = mediaTiming;
    animation.duration = 0.2;
    animation.repeatCount = 1;
    animation.fromValue =  fromValue;// 起始角度
    animation.toValue = toValue; // 终止角度
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    return animation;
}

- (CAAnimation *)createKAnimationWithKeyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.duration = 2;
    animation.calculationMode = kCAAnimationCubic;
    animation.repeatCount = HUGE_VALF;
    animation.values = @[fromValue, fromValue, @(-[toValue floatValue]/ 2.0), toValue, fromValue, fromValue];
    animation.keyTimes = @[@(0), @(0.075), @(0.09), @(0.13), @(0.16), @(1)];
    return animation;
}

- (CAAnimation *)createAnimationWithKeyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.duration = 1.5; // 持续时间
    
    CAMediaTimingFunction *mediaTiming = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.timingFunction = mediaTiming;
    animation.repeatCount = HUGE_VALF; // 重复次数
    animation.fromValue =  fromValue;// 起始角度
    animation.toValue = toValue; // 终止角度
    animation.autoreverses = YES;
    return animation;
}

@end
