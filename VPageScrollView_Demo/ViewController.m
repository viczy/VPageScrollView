//
//  ViewController.m
//  VPageScrollView
//
//  Created by Vic Zhou on 1/14/15.
//  Copyright (c) 2015 everycode. All rights reserved.
//

#import "ViewController.h"
#import "VPageScrollView.h"

@interface ViewController () <
    VPageScrollViewDataSource,
    VPageScrollViewDelegate>


@property (nonatomic, strong) NSArray *pageArray;

@property (nonatomic, strong) VPageScrollView *pageScrollView;

@end

@implementation ViewController

#pragma mark - Getter

- (NSArray*)pageArray {
    if (!_pageArray) {
        _pageArray  = @[@"page1", @"page2", @"page3", @"page4"];
    }
    return _pageArray;
}

- (VPageScrollView*)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[VPageScrollView alloc] initWithFrame:CGRectMake(0.f, 100.f, self.view.bounds.size.width, 200.f)];
        _pageScrollView.dataSource = self;
        _pageScrollView.pageDelegate = self;
        _pageScrollView.loop = YES;
    }
    return _pageScrollView;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.pageScrollView];
}

#pragma mark - VPageScrollViewDataSource

- (NSUInteger)numberOfPagesFromVPageScrollView {
    return self.pageArray.count;
}


- (UIView*)vPageScrollView:(VPageScrollView *)vPageScrollView viewForPageAtIndex:(NSUInteger)index {
    NSString *indexStr = self.pageArray[index];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.pageScrollView.frame.size.width, self.pageScrollView.frame.size.height)];
    view.image = [UIImage imageNamed:indexStr];
    return view;
}

#pragma mark - VPageScrollViewDelegate

- (void)vPageScrollView:(VPageScrollView *)vPageScrollView viewOfPageDidLoadAtIndex:(NSUInteger)index {
    //
}

@end
