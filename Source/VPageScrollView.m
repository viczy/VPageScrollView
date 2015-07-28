//
//  VPageScrollView.m
//  VPageScrollView
//
//  Created by Vic Zhou on 1/14/15.
//  Copyright (c) 2015 everycode. All rights reserved.
//

#import "VPageScrollView.h"

static NSInteger const tagOffset = 100;

@interface VPageScrollView () <
    UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger pages;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL scroolLoop;

@end

@implementation VPageScrollView

#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = 0;
        _loop = NO;
    }
    return self;
}

#pragma mark - Getter

- (BOOL)scroolLoop {
    if (_loop && self.pages > 2) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - Setter

-  (void)setPages:(NSUInteger)pages {
    _pages = pages;
    self.contentSize = CGSizeMake(self.bounds.size.width * self.pages, self.bounds.size.height);
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex < currentIndex) { // 向后翻页的事件处理
        [self addSubviewAtIndex:currentIndex+1];
        [self removeSubviewAtIndex:currentIndex-2];
    }else if (_currentIndex > currentIndex) { // 向前翻页的事件处理
        [self addSubviewAtIndex:currentIndex-1];
        [self removeSubviewAtIndex:currentIndex+2];
    }

    if (self.scroolLoop) {
        _currentIndex = [self getValidPageWithCurrent:currentIndex];
    }else {
        _currentIndex = currentIndex;
    }

    [self loadOverSubviewAtIndex:_currentIndex];

    if (self.scroolLoop) {
        [self loopRectReset];
    }
}

- (void)setLoop:(BOOL)loop {
    _loop = loop;

    self.showsHorizontalScrollIndicator = !loop;
    self.showsVerticalScrollIndicator = !loop;
}

#pragma mark - UIView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    self.delegate = self;
    self.pagingEnabled = YES;

    self.pages = [self.dataSource numberOfPagesFromVPageScrollView];
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    if (self.scroolLoop) {
        [self addSubviewAtIndex:-1];
        [self addSubviewAtIndex:0];
        [self addSubviewAtIndex:1];
        [self loopRectReset];
    }else {
        [self addSubviewAtIndex:0];
        [self addSubviewAtIndex:1];
    }
    [self loadOverSubviewAtIndex:0];
}

#pragma mark - Actions Public

- (void)reload {
    self.pages = [self.dataSource numberOfPagesFromVPageScrollView];
    [self reloadPageAtIndex:self.currentIndex];
}

- (void)scrollToPageAtIndex:(NSUInteger)index {
    if (self.scroolLoop) {
        return;
    }

    [self setContentOffset:CGPointMake(self.bounds.size.width*index, 0) animated:YES];
}

- (void)reloadPageAtIndex:(NSUInteger)index {
    _currentIndex = index;
    //clear all old view
    [self removeSubviewAtIndex:index-1];
    [self removeSubviewAtIndex:index];
    [self removeSubviewAtIndex:index+1];
    //add sub view
    [self addSubviewAtIndex:index-1];
    [self addSubviewAtIndex:index];
    [self addSubviewAtIndex:index+1];

    if (self.scroolLoop) {
        [self loopRectReset];
    }else {
        //scroll to page
        [self setContentOffset:CGPointMake(self.bounds.size.width*index, 0) animated:YES];
    }
}

#pragma mark - Actions Private

//add sub view
- (void)addSubviewAtIndex:(NSUInteger)index {
    if (self.scroolLoop) {
        index = [self getValidPageWithCurrent:index];
    }
    if (index < self.pages ) {
        if ([self.dataSource respondsToSelector:@selector(vPageScrollView:viewOfPageDidLoadAtIndex:)]) {
            UIView *view = [self.dataSource vPageScrollView:self viewForPageAtIndex:index];
            view.tag = index+tagOffset;
            CGRect rect = view.frame;
            rect.origin.x += self.bounds.size.width *index;
            view.frame = rect;
            [self addSubview:view];
        }
    }
}

//remove sub view
- (void)removeSubviewAtIndex:(NSUInteger)index {
    if (self.scroolLoop) {
        index = [self getValidPageWithCurrent:index];
    }
    UIView *view = [self viewWithTag:index+tagOffset];
    if (view) {
        [view removeFromSuperview];
    }
}

//load over
- (void)loadOverSubviewAtIndex:(NSUInteger)index {
    if ([self.pageDelegate respondsToSelector:@selector(vPageScrollView:viewOfPageDidLoadAtIndex:)]) {
        [self.pageDelegate vPageScrollView:self viewOfPageDidLoadAtIndex:index];
    }
}

// scroll over
- (void)scrollingEnd
{
    NSInteger newIndex = floor(self.contentOffset.x / self.frame.size.width);

    newIndex = newIndex < 0 ? 0 : newIndex;

    if (newIndex != _currentIndex) {
        self.currentIndex = newIndex;
    }
}


#pragma mark - Actions Private
#pragma mark Loop

- (NSInteger)getValidPageWithCurrent:(NSInteger)page;
{
    if(page < 0) {
        return self.pages + page;
    } else if (page >= self.pages) {
        return page-self.pages;
    } else {
        return page;
    }
}

- (void)loopRectReset {
    if (self.pages < 3) {
        return;
    }
    NSInteger pre = [self getValidPageWithCurrent:self.currentIndex-1];
    NSInteger current = [self getValidPageWithCurrent:self.currentIndex];
    NSInteger next = [self getValidPageWithCurrent:self.currentIndex+1];

    UIView *preView = [self viewWithTag:pre+tagOffset];
    UIView *currentView = [self viewWithTag:current+tagOffset];
    UIView *nextView = [self viewWithTag:next+tagOffset];

    if (preView) {
        CGRect rect = preView.frame;
        rect.origin.x = self.bounds.size.width*0;
        preView.frame = rect;
    }

    if (currentView) {
        CGRect rect = currentView.frame;
        rect.origin.x = self.bounds.size.width*1;
        currentView.frame = rect;
    }

    if (nextView) {
        CGRect rect = nextView.frame;
        rect.origin.x = self.bounds.size.width*2;
        nextView.frame = rect;
    }

     [self setContentOffset:CGPointMake(self.bounds.size.width, 0)];
}

- (void)loopScrollEnd {
    if (self.pages < 3) {
        return;
    }
    int contentOffsetX = self.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(self.bounds))) {
        self.currentIndex = self.currentIndex+1;
    }
    if(contentOffsetX <= 0) {
        self.currentIndex = self.currentIndex -1;
    }
}

#pragma mark -
#pragma mark scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scroolLoop) {
        [self loopScrollEnd];
    }else {
        [self scrollingEnd];
    }
}

@end
