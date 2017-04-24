//
//  DDViewController.m
//  DDBanner
//
//  Created by China-ZWS on 04/23/2017.
//  Copyright (c) 2017 China-ZWS. All rights reserved.
//

#import "DDViewController.h"
#import "DDBannerViewController.h"

@interface DDViewController ()

@end

@implementation DDViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    UIButton *(^cteateBtn)(NSString *, CGRect, SEL) = ^UIButton *(NSString *title,CGRect frame, SEL action){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.frame = frame;
        btn.backgroundColor = [UIColor redColor];
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        return btn;
    };
    UIButton *HBtn = cteateBtn(@"横向",CGRectMake(90, 30, 50, 50),@selector(onclickWithH));
    [self.view addSubview:HBtn];
    UIButton *VBtn = cteateBtn(@"竖向",CGRectMake(CGRectGetMaxX(self.view.frame) - 140, 30, 50, 50),@selector(onclickWithV));
    [self.view addSubview:VBtn];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void) onclickWithH {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[DDBannerViewController alloc] initWithDDBannerScrollDirection:DDBannerScrollDirectionHorizontal]] animated:YES completion:NULL];
}

- (void) onclickWithV {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[DDBannerViewController alloc] initWithDDBannerScrollDirection:DDBannerScrollDirectionVertical]] animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
