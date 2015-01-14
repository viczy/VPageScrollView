//
//  VPageScrollViewProtocol.h
//  VPageScrollView
//
//  Created by Vic Zhou on 1/14/15.
//  Copyright (c) 2015 everycode. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VPageScrollView;

@protocol VPageScrollViewDataSource <NSObject>

- (NSUInteger)numberOfPagesFromVPageScrollView;

- (UIView*)vPageScrollView:(VPageScrollView*)vPageScrollView viewForPageAtIndex:(NSUInteger)index;

@end


@protocol VPageScrollViewDelegate <NSObject>

- (void)vPageScrollView:(VPageScrollView*)vPageScrollView viewOfPageDidLoadAtIndex:(NSUInteger)index;

@end
