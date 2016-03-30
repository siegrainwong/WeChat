//
//  SearchResultsController.h
//  WeChat
//
//  Created by Siegrain on 16/3/30.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsController
  : UITableViewController<UISearchResultsUpdating>

- (instancetype)initWithKeywords:(NSArray*)keywords
                       andImages:(NSArray<UIImage*>*)images;
@end
