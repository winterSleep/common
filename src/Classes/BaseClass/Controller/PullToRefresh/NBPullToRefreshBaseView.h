//
//  NBPullToRefreshBaseView.h
//  Fish
//
//  Created by Li Zhiping on 30/01/2018.
//  Copyright © 2018 Li Zhiping. All rights reserved.
//

#import "UIScrollView+SVPullToRefresh.h"

@interface NBPullToRefreshBaseView : SVPullCustomRefreshView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
