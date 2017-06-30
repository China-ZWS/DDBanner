//
//  DDScrollView.h
//  DDKit
//
//  Created by Song on 16/10/11.
//  Copyright © 2016年 https://github.com/China-ZWS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DDBannerScrollDirection) {
    DDBannerScrollDirectionHorizontal,
    DDBannerScrollDirectionVertical
};


@class DDBanner;

@protocol DDBannerDelegate <NSObject>

@required

/**
 *  加载图片的代理，由自己指定加载方式。便于统一网络图片管理
 *
 */
- (void)imageView:(UIImageView *)imageView loadImageForData:(id)data;
/**
 *  banner的点击回调
 */
- (void)bannerView:(DDBanner *)bannerView didSelectAtIndex:(NSUInteger)index;

@optional

/**
 *  @brief  当前Page的Index
 *
 *  @param bannerView         bannerView description
 *  @param currentPageAtIndex currentPageAtIndex description
 */
- (void)bannerView:(DDBanner *)bannerView  currentPageAtIndex:(NSInteger)currentPageAtIndex;

@end

@interface DDBanner : UIView

@property (nonatomic, weak) id<DDBannerDelegate> delegate;
@property (nonatomic, assign) BOOL canLoop;
@property (nonatomic, assign) BOOL allowCycle;
@property (nonatomic, assign) CGFloat duration;                        //!< 自动换页时间间隔，0s 不自动滚动
@property (nonatomic, strong) UIColor *itemBackgroundColor;                //!< item背景颜色
@property (nonatomic, assign) DDBannerScrollDirection scrollDirection; //!< 默认 横向

- (instancetype)initWithFrame:(CGRect)frame
                      canLoop:(BOOL)canLoop
                   allowCycle:(BOOL)allowCycle
                     duration:(NSInteger)duration ;

- (DDBanner *(^)(UIView *view))addPageControl;

- (void)startLoop ;
- (void)stopLoop ;

/**
 *  banners数据源
 *
 *  @param imageArray url字符串数组
 */
- (void)configBanner:(NSArray *)imageArray;

@end
