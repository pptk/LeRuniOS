//
//  PictureScrollView.m
//  PictureCarousel
//
//  Created by ianc-ios on 15/9/12.
//  Copyright (c) 2015年 DeadFish7/25. All rights reserved.
//

#import "PictureScrollView.h"
#import "ScrollImageView.h"
#import "UIImageView+WebCache.h"

@interface PictureScrollView()<UIScrollViewDelegate>
{
    NSInteger _temPage;
}
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;

@end

@implementation PictureScrollView

#pragma mark 设定初次显示的是第几张图。
-(void)startLoadingByIndex:(NSInteger)index{
    [self startLoading];
    _temPage = index;
    [self.scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width *(index+1), 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
}
#pragma mark 初始化frame
-(void)startLoading{
    [self initScrollView];
}
#pragma mark 初始化相关View
-(void)initScrollView{
    if(_scrollView){//如果_scrollView不为空
        return;
    }
    //设置ScrollView一些属性
    _scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        scrollView.bounces = NO;//默认是 yes，就是滚动超过边界会反弹有反弹回来的效果。假如是 NO，那么滚动到达边界会立刻停止。
        scrollView.pagingEnabled = YES;//当值是 YES 会自动滚动到 subview 的边界。默认是NO
        scrollView.delegate  = self;
        scrollView.userInteractionEnabled = YES;//一个布尔值，它决定了是否用户触发的事件被该视图对象忽略和把该视图对象从事件响应队列中移除
        scrollView.showsHorizontalScrollIndicator = NO;//滚动时是否显示水平滚动条
        scrollView.showsVerticalScrollIndicator = NO;//滚动时是否显示垂直滚动条
        if(self.slideImagesArray.count <2){
            scrollView.scrollEnabled = NO;//if slideImageArray小于2.那么scrollEnable = NO;
        }
        [self addSubview:scrollView];
        scrollView;
    });
    //设定有pageControl的情况下
    if(!self.withoutPageControl){
        _pageControl = ({
            UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((_scrollView.frame.size.width-100)/2, _scrollView.frame.size.height-18, 100, 15)];
            [pageControl setCurrentPageIndicatorTintColor:self.pageControlCurrentPageIndicatorTintColor ? self.pageControlCurrentPageIndicatorTintColor : [UIColor purpleColor]];
            [pageControl setPageIndicatorTintColor:self.pageControlPageIndicatorTintColor
             ? self.pageControlPageIndicatorTintColor : [UIColor grayColor]];
            
            pageControl.numberOfPages = [_slideImagesArray count];
            pageControl.currentPage = 0;
            if(self.slideImagesArray.count <2){
                pageControl.hidden = YES;
            }
            [self addSubview:pageControl];
            pageControl;
        });
    }
    //布置ImageView
    for(NSInteger i = 0;i<_slideImagesArray.count; i++){
        ScrollImageView *sliderImage = [[ScrollImageView alloc]init];
        sliderImage.contentMode = UIViewContentModeScaleAspectFit;
        [sliderImage sd_setImageWithURL:[NSURL URLWithString:_slideImagesArray[i]] placeholderImage:[UIImage imageNamed:@"back.png"]];
        sliderImage.tag = i+100;
        sliderImage.frame = CGRectMake(_scrollView.frame.size.width*i + _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        [sliderImage addTarget:self action:@selector(ImageClick:)];//添加点击事件。这是自定义ImageVIew的时候设置的自带事件
        [_scrollView addSubview:sliderImage];
    }
    //取数组最后一张图放在第0页面
    ScrollImageView *firstSlideImage = [[ScrollImageView alloc]init];
    firstSlideImage.contentMode = UIViewContentModeScaleAspectFit;
    [firstSlideImage sd_setImageWithURL:[NSURL URLWithString:_slideImagesArray[_slideImagesArray.count-1]]  placeholderImage:[UIImage imageNamed:@"back.png"]];
    firstSlideImage.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView addSubview:firstSlideImage];
    //取数组第一张图放在最后1页
    ScrollImageView *endSlideImage = [[ScrollImageView alloc]init];
    endSlideImage.contentMode = UIViewContentModeScaleAspectFit;
    [endSlideImage sd_setImageWithURL:[NSURL URLWithString:_slideImagesArray[0]] placeholderImage:[UIImage imageNamed:@"back.png"]];
    endSlideImage.frame = CGRectMake((_slideImagesArray.count +1)*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView addSubview:endSlideImage];
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width *(_slideImagesArray.count+2), _scrollView.frame.size.height)];
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
    
    //如果设置了定时滑动
    if(!self.withoutAutoScroll){
        if(!self.autoTime){
            self.autoTime = [NSNumber numberWithFloat:2.0f];
        }
        NSTimer *myTimer = [NSTimer timerWithTimeInterval:[self.autoTime floatValue] target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
    }
}

#pragma mark 定时器
-(void)runTimePage{
    NSInteger page = self.pageControl.currentPage;
    page++;
    [self turnPage:page];
}

#pragma mark 换页操作
-(void)turnPage:(NSInteger)page{
    _temPage = page;
    [self.scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width*(page+1), 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
}
#pragma mark 点击事件
-(void)ImageClick:(UIImageView *)sender{
    if(self.pictureSelectBlock){
        //点击方法将tag传出去。从而区分做不同的响应。
        self.pictureSelectBlock(sender.tag);
    }
}



#pragma mark -ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWith = self.scrollView.frame.size.width;
    NSInteger page = floor((self.scrollView.contentOffset.x - pageWith/([_slideImagesArray count]+2))/pageWith)+1;
    page--;//默认从第二页开始
    self.pageControl.currentPage = page;
}
#pragma mark 减速开始后执行
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWith = self.scrollView.frame.size.width;
    NSInteger currentPage = floor((self.scrollView.contentOffset.x - pageWith/([_slideImagesArray count]+2)) / pageWith)+1;
    if(currentPage == 0){
        if(self.pictureCurrentIndex){
            self.pictureCurrentIndex(_slideImagesArray.count-1);
        }
        [self.scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width*_slideImagesArray.count, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
    }else if(currentPage == _slideImagesArray.count +1){
        if(self.pictureCurrentIndex){
            self.pictureCurrentIndex(0);
        }
        [self.scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
    }else{
        if(self.pictureCurrentIndex){
            self.pictureCurrentIndex(currentPage-1);
        }
    }
}
#pragma mark 滑动结束后的动作
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if(!self.withoutAutoScroll){
        if(_temPage == 0){
            [self.scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width*_slideImagesArray.count,0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
        }else if(_temPage == _slideImagesArray.count){
            [self.scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
        }
    }
}

@end
