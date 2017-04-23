//
//  DDScrollView.m
//  DDKit
//
//  Created by Song on 16/10/11.
//  Copyright © 2016年 https://github.com/China-ZWS. All rights reserved.
//

#import "DDBanner.h"

#import "DDBannerItem.h"

#import <libkern/OSAtomic.h>

@interface DDBanner () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong)  UIView *pageControl ;
@property (nonatomic, strong) UICollectionView *containerView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGFloat unitLength;
@property (nonatomic, assign) CGFloat offsetLength;
@property (nonatomic, assign) CGFloat contentLength;
@property (nonatomic, assign) CGFloat oldOffsetLength;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation DDBanner

- (void)dealloc
{
    [self removeTimer];
}

- (instancetype)initWithFrame:(CGRect)frame canLoop:(BOOL)canLoop duration:(NSInteger)duration;
{
    if ((self = [super initWithFrame:frame])) {
        _canLoop = canLoop;
        _duration = duration;
        self.backgroundColor = [UIColor whiteColor];
        [self layoutViews];
        [self startLoop];
    }
    return self;
}

- (void)startLoop
{
    [self addTimer];
}

- (void)stopLoop
{
    [self removeTimer];
}

- (void)configBanner:(NSArray *)imageArray;
{
    _imageUrls = imageArray;
    [_containerView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (imageArray.count > 1) {
            [_containerView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    });
}

- (DDBanner *(^)(UIView *view))addPageControl;
{
    __weak typeof(self) weakSelf = self;
    return ^DDBanner *(UIView *view)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            weakSelf.pageControl = view;
            [weakSelf addSubview:view];
            return weakSelf;
        }
        return nil;
    };
}

- (void)layoutViews
{
    [self addSubview:self.containerView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.flowLayout.itemSize = self.frame.size;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
    }
    return _flowLayout;
}

- (UICollectionView *)containerView
{
    if (!_containerView) {
        _containerView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _containerView.bounces = NO;
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.pagingEnabled = YES;
        _containerView.showsHorizontalScrollIndicator = NO;
        _containerView.showsVerticalScrollIndicator = NO;
        [_containerView registerClass:[DDBannerItem class] forCellWithReuseIdentifier:@"banner"];
        _containerView.dataSource = self;
        _containerView.delegate = self;

    }
    return _containerView;
}

#pragma mark - collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(_imageUrls.count == 1) {
        return 1;
    }
    return _imageUrls.count + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDBannerItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"banner" forIndexPath:indexPath];

    id data = [self getImageUrlForIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(imageView:loadImageForData:)]) {
        [self.delegate imageView:cell.imageView loadImageForData:data];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelectAtIndex:)]) {
        [self.delegate bannerView:self didSelectAtIndex:_currentPage];
    }
}

- (NSString *)getImageUrlForIndexPath:(NSIndexPath *)indexPath {
    if (!(_imageUrls.count > 0)) {
        return nil;
    }
    if (indexPath.row == 0){
        return _imageUrls.lastObject;
    } else if (indexPath.row - 1 == _imageUrls.count){
        return _imageUrls.firstObject;
    }else {
        return _imageUrls[indexPath.row - 1];
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopLoop];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    [self startLoop];
    NSInteger currentPage = self.offsetLength / self.unitLength;

    [self changeCurrentPage:currentPage scrollView:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    NSInteger currentPage = self.offsetLength / self.unitLength;
    [self changeCurrentPage:currentPage scrollView:scrollView];
}

- (void)changeCurrentPage:(NSInteger )currentPage scrollView:(UIScrollView *)scrollView
{
    _currentPage = currentPage - 1;


    if (currentPage == 0)
    {
        CGFloat newOffSetLength =  self.unitLength * (_imageUrls.count);
        CGPoint offSet;
        if (self.scrollDirection == DDBannerScrollDirectionHorizontal) {
            offSet = CGPointMake(newOffSetLength, 0);
        }else{
            offSet = CGPointMake(0,newOffSetLength);
        }
        scrollView.contentOffset = offSet;
        _currentPage = _imageUrls.count;
    }
    else if (currentPage == _imageUrls.count + 1)
    {
        CGPoint offSet;
        if (self.scrollDirection == DDBannerScrollDirectionHorizontal) {
            offSet = CGPointMake(self.unitLength, 0);
        }else{
            offSet = CGPointMake(0, self.unitLength);
        }

        scrollView.contentOffset = offSet;
        _currentPage = 0;
    }

    if ([self.delegate respondsToSelector:@selector(bannerView:currentPageAtIndex:)]) {
        [_delegate bannerView:self currentPageAtIndex:_currentPage];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startLoop];
}

#pragma - mark - private

- (void)removeTimer
{
    if (!_timer) return;

    [_timer invalidate];
    self.timer = nil;
}

- (void)addTimer
{
    if (!_canLoop || _duration == 0) return;

    if (_timer) return  ;

    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(changePage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

- (void)changePage {

    CGFloat newOffSetLength = self.offsetLength + self.unitLength;

    CGPoint offSet;
    if (self.scrollDirection == DDBannerScrollDirectionHorizontal) {
        offSet = CGPointMake(newOffSetLength, 0);
    }else{
        offSet = CGPointMake(0,newOffSetLength);
    }


    [_containerView setContentOffset:offSet  animated:YES];
    //修复在滚动动画进行中切换tabbar或push一个新的controller时导致图片显示错位问题。
    //原因：系统会在view not-on-screen时移除所有coreAnimation动画，导致动画无法完成，轮播图停留在切换中间的状态。
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //动画完成后的实际offset和应该到达的offset不一致，重置offset。
//        if (self.offsetLength!=newOffSetLength && self.offsetLength!=0) {
//            _containerView.contentOffset = offSet;
//        }
//    });

}

- (CGFloat)offsetLength {
    return _scrollDirection == DDBannerScrollDirectionHorizontal ? _containerView.contentOffset.x : _containerView.contentOffset.y;
}

- (CGFloat)unitLength {
    return _scrollDirection == DDBannerScrollDirectionHorizontal ? CGRectGetWidth(self.frame) : CGRectGetHeight(self.frame);
}

- (CGFloat)contentLength {
    return _scrollDirection == DDBannerScrollDirectionHorizontal ? _containerView.contentSize.width : _containerView.contentSize.height;
}

- (void)setScrollDirection:(DDBannerScrollDirection)scrollDirection {
    if (_scrollDirection != scrollDirection) {
        _scrollDirection = scrollDirection;
        if (scrollDirection == DDBannerScrollDirectionVertical) {
            self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        }else{
            self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        }
        [_containerView reloadData];
    }
}

@end
