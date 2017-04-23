//
//  DDBannerItem.m
//  DDKit
//
//  Created by Song on 16/10/11.
//  Copyright © 2016年 https://github.com/China-ZWS. All rights reserved.
//

#import "DDBannerItem.h"

@interface DDBannerItem ()


@end

@implementation DDBannerItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _imageView = UIImageView.new;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES ;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

@end
