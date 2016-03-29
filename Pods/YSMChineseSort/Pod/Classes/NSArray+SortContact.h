//
//  NSArray+SortContact.h
//  YSMChineseSortDemo
//
//  Created by ysmeng on 15/5/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SortContact)

/**
 *  @author         yangshengmeng, 15-05-19 00:05:58
 *
 *  @brief          字符串数组中英文混排(中文简体和繁体)，升序，中文在前，英文在后
 *
 *  @param callBack 排序完成后的回调
 *
 *  @since          1.0.0
 */
- (void)sortContactTOTitleAndSectionRow_A_CE:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack;

/**
 *  @author         yangshengmeng, 15-05-19 00:05:58
 *
 *  @brief          字符串数组中英文混排(中文简体和繁体)：升序，英文在前，中文在后
 *
 *  @param callBack 排序完成后的回调
 *
 *  @since          1.0.0
 */
- (void)sortContactTOTitleAndSectionRow_A_EC:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack;

/**
 *  @author         yangshengmeng, 15-05-19 00:05:58
 *
 *  @brief          字符串数组中英文混排(中文简体和繁体)：降序，中文在前，英文在后
 *
 *  @param callBack 排序完成后的回调
 *
 *  @since          1.0.0
 */
- (void)sortContactTOTitleAndSectionRow_DA_CE:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack;

/**
 *  @author         yangshengmeng, 15-05-19 00:05:58
 *
 *  @brief          字符串数组中英文混排(中文简体和繁体)：降序,英文在前，中文在后
 *
 *  @param callBack 排序完成后的回调
 *
 *  @since          1.0.0
 */
- (void)sortContactTOTitleAndSectionRow_DA_EC:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack;

/**
 *  @author         yangshengmeng, 15-05-19 00:05:57
 *
 *  @brief          对象数组指定字段的内容中英文混排(中文简体和繁体)：升序，中文在前，英文在后
 *
 *  @param sortKey  对象中需要排序的字段key，获取出来必须为NSString对象
 *  @param callBack 排序完成后的回调，回调标题数据和内容数组
 *
 *  @since          1.0.0
 */
- (void)sortContactTOTitleAndSectionRowWithKey_A_CE:(NSString *)sortKey callBack:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack;

/**
 *  @author         yangshengmeng, 15-05-19 00:05:57
 *
 *  @brief          对象数组指定字段的内容中英文混排(中文简体和繁体)：升序，英文在前，中文在后
 *
 *  @param sortKey  对象中需要排序的字段key，获取出来必须为NSString对象
 *  @param callBack 排序完成后的回调，回调标题数据和内容数组
 *
 *  @since          1.0.0
 */
- (void)sortContactTOTitleAndSectionRowWithKey_A_EC:(NSString *)sortKey callBack:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack;

/**
 *  @author         yangshengmeng, 15-05-19 00:05:57
 *
 *  @brief          对象数组指定字段的内容中英文混排(中文简体和繁体)：降序，中文在前，英文在后
 *
 *  @param sortKey  对象中需要排序的字段key，获取出来必须为NSString对象
 *  @param callBack 排序完成后的回调，回调标题数据和内容数组
 *
 *  @since          1.0.0
 */
- (void)sortContactTOTitleAndSectionRowWithKey_DA_CE:(NSString *)sortKey callBack:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack;

/**
 *  @author         yangshengmeng, 15-05-19 00:05:57
 *
 *  @brief          对象数组指定字段的内容中英文混排(中文简体和繁体)：降序，英文在前，中文在后
 *
 *  @param sortKey  对象中需要排序的字段key，获取出来必须为NSString对象
 *  @param callBack 排序完成后的回调，回调标题数据和内容数组
 *
 *  @since          1.0.0
 */
- (void)sortContactTOTitleAndSectionRowWithKey_DA_EC:(NSString *)sortKey callBack:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack;

@end
