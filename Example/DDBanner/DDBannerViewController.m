//
//  DDBannerViewController.m
//  DDBanner
//
//  Created by 周文松 on 2017/4/24.
//  Copyright © 2017年 China-ZWS. All rights reserved.
//

#import "DDBannerViewController.h"

#import "UIImageView+YYWebImage.h"

@interface DDBannerViewController () <DDBannerDelegate>

@property (nonatomic, assign) DDBannerScrollDirection scrollDirection;
@property (nonatomic, strong) DDBanner *banner;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation DDBannerViewController

- (instancetype)initWithDDBannerScrollDirection:(DDBannerScrollDirection)scrollDirection {
    if ((self = [super init])) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        self.scrollDirection = scrollDirection;
    }
    return self;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (UIPageControl *)pageControl {
    return _pageControl = ({
        UIPageControl *page = nil;
        if (_pageControl) {
            page = _pageControl;
        } else {
            page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 200 - 25, CGRectGetWidth(self.view.frame), 20)];
        }
        page;
    });
}

- (DDBanner *)banner {
    return _banner = ({
        DDBanner *view = nil;
        if (_banner) {
            view = _banner;
        } else {
            view = [[DDBanner alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200) canLoop:YES duration:3.f];
            view.delegate = self;
            view.scrollDirection = _scrollDirection;
            view.addPageControl(self.pageControl);
        }
        view;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.banner];
   
    NSArray *datas = @[
                       [UIImage imageNamed:@"组-49"],
                       @"http://eshop.argentina.zjtech.cc/storage/app/uploads/image/2017/03/05/f231393ce0f0ebe9942f8cb1a0cd89e5.png",
                       [UIImage imageNamed:@"组-49"],
                       ];
    _pageControl.numberOfPages = datas.count;
    _pageControl.currentPage = 0;

    [_banner configBanner:datas];

}

- (void)imageView:(UIImageView *)imageView loadImageForData:(id)data {
    imageView.backgroundColor = [UIColor redColor];
    imageView.image = nil;
    if ([data isKindOfClass:[NSString class]]) {
        [imageView yy_setImageWithURL:[NSURL URLWithString:data]
                     placeholder:nil
                         options:YYWebImageOptionSetImageWithFadeAnimation
                      completion:NULL];
    } else {
        imageView.image = data;
    }
}

- (void)bannerView:(DDBanner *)bannerView didSelectAtIndex:(NSUInteger)index {

}

- (void)bannerView:(DDBanner *)bannerView  currentPageAtIndex:(NSInteger)currentPageAtIndex {
    _pageControl.currentPage = currentPageAtIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
