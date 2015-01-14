//
//  VPageScrollView.h
//  VPageScrollView
//
//  Created by Vic Zhou on 1/14/15.
//  Copyright (c) 2015 everycode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPageScrollViewProtocol.h"

@interface VPageScrollView : UIScrollView

@property (nonatomic, weak) id <VPageScrollViewDataSource>dataSource;
@property (nonatomic, weak) id <VPageScrollViewDelegate> pageDelegate;
@property (nonatomic, assign) BOOL loop;//循环滚动

- (void)reload;

- (void)reloadPageAtIndex:(NSUInteger)index;

- (void)scrollToPageAtIndex:(NSUInteger)index;//loop=NO,有效

@end
