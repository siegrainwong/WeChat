//
//  NSArray+SortContact.m
//  YSMChineseSortDemo
//
//  Created by ysmeng on 15/5/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "NSArray+SortContact.h"
#import "PinYin4Objc.h"

@implementation NSArray (SortContact)

/**
 *  @author         yangshengmeng, 15-05-19 00:05:58
 *
 *  @brief          字符串数组中英文混排(中文简体和繁体)，升序，中文在前，英文在后
 *
 *  @param callBack 排序完成后的回调
 *
 *  @since          1.0.0
 */
- (void)sortContactTOTitleAndSectionRow_A_CE:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack
{
    
    ///判断当前数组的个数
    if (0 >= [self count]) {
        
        NSLog(@"====================中英文混排日志====================");
        NSLog(@"::::::::::当前数据源无元素，无需排序");
        NSLog(@"====================中英文混排日志====================");
        
        ///回调
        if (callBack) {
            
            callBack(NO,nil,nil);
            
        }
        
    }

    ///建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *titleDataSource = [NSMutableArray arrayWithArray:[indexCollation sectionTitles]];
    
    ///返回27，是a－z和＃
    NSInteger highSection = [titleDataSource count];
    
    ///初始添加27个section对应的数组
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
        
    }
    
    ///名字分section
    for (NSObject *obj in self) {
        
        ///判断类型
        if (![obj isKindOfClass:[NSString class]]) {
            
            NSLog(@"====================中英文混排日志====================");
            NSLog(@"::::::::::当前数据源中存在非字符串对象，无法成功排序");
            NSLog(@"====================中英文混排日志====================");
            
            ///回调
            if (callBack) {
                
                callBack(NO,nil,nil);
                
            }
            return;
            
        }
        
        ///转为字符串
        NSString *contactName = (NSString *)obj;
        
        ///获取首字母
         NSString *firstLetter = [PinyinHelper toHanyuPinyinStringWithNSString:contactName withHanyuPinyinOutputFormat:nil withNSString:@""];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:contactName];
        
    }
    
    ///每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            
            ///第一个元素纯英文
            if (![self isIncludeChineseInString:obj1] &&
                [self isIncludeChineseInString:obj2]) {
                
                return YES;
                
            }
            
            ///第二个元素纯英文，第一个元素有中文
            if ([self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return NO;
                
            }
            
            ///两个元素都是英文
            if (![self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return [obj1 caseInsensitiveCompare:obj2];
                
            }
            
            ///两个元素都有中文
            HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
            [outputFormat setToneType:ToneTypeWithoutTone];
            [outputFormat setVCharType:VCharTypeWithV];
            [outputFormat setCaseType:CaseTypeLowercase];
            
            ///获取第一个元素的全中文
            NSString *firstString1 = [PinyinHelper toHanyuPinyinStringWithNSString:obj1 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter1 = [firstString1 characterAtIndex:0];
            
            ///获取第二个元素的全中文
            NSString *firstString2 = [PinyinHelper toHanyuPinyinStringWithNSString:obj2 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter2 = [firstString2 characterAtIndex:0];
            
            ///先按首字母排序
            if (firstLetter1 != firstLetter2) {
                
                return firstLetter1 > firstLetter2;
                
            }
            
            ///全中文首字母
            NSArray *tempArray1 = [firstString1 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr1 = [NSMutableString string];
            for (int i = 0; i < [tempArray1 count]; i++) {
                
                NSString *singleWord = tempArray1[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr1 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            NSArray *tempArray2 = [firstString2 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr2 = [NSMutableString string];
            for (int i = 0; i < [tempArray2 count]; i++) {
                
                NSString *singleWord = tempArray2[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr2 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            ///首字母不相同，则返回对比结果
            if (!(NSOrderedSame == [tempPinYinHeadStr1 caseInsensitiveCompare:tempPinYinHeadStr2])) {
                
                return [tempPinYinHeadStr1 caseInsensitiveCompare:tempPinYinHeadStr2];
                
            }
            
            ///进行全字母排序
            NSString *firstMString1 = [firstString1 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            NSString *firstMString2 = [firstString2 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            
            return [firstMString1 caseInsensitiveCompare:firstMString2];
            
        }];
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
        
    }
    
    ///重置原始数据
    NSMutableIndexSet *emtyIndexSet = [NSMutableIndexSet indexSet];
    for (int i = 0; i < [titleDataSource count]; i++) {
        
        if ([[sortedArray objectAtIndex:i] count] <= 0) {
            
            [emtyIndexSet addIndex:i];
            
        }
        
    }
    
    ///清空无效标题
    [titleDataSource removeObjectsAtIndexes:emtyIndexSet];
    [sortedArray removeObjectsAtIndexes:emtyIndexSet];
    for (int i = (int)[sortedArray count]; i > 0 ; i--) {
        
        NSArray *tempArray = sortedArray[i - 1];
        if ([tempArray count] <= 0) {
            
            [sortedArray removeObjectAtIndex:i - 1];
            
        }
        
    }
    
    ///回调成功
    if (callBack) {
        
        callBack(YES,[NSArray arrayWithArray:titleDataSource],[NSArray arrayWithArray:sortedArray]);
        
    }

}

/**
 *  @author         yangshengmeng, 15-05-19 00:05:58
 *
 *  @brief          字符串数组中英文混排(中文简体和繁体)：升序，英文在前，中文在后
 *
 *  @param callBack 排序完成后的回调
 *
 *  @since          1.0.0
 */
- (void)sortContactTOTitleAndSectionRow_A_EC:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack
{

    ///判断当前数组的个数
    if (0 >= [self count]) {
        
        NSLog(@"====================中英文混排日志====================");
        NSLog(@"::::::::::当前数据源无元素，无需排序");
        NSLog(@"====================中英文混排日志====================");
        
        ///回调
        if (callBack) {
            
            callBack(NO,nil,nil);
            
        }
        
    }
    
    ///建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *titleDataSource = [NSMutableArray arrayWithArray:[indexCollation sectionTitles]];
    
    ///返回27，是a－z和＃
    NSInteger highSection = [titleDataSource count];
    
    ///初始添加27个section对应的数组
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
        
    }
    
    ///名字分section
    for (NSObject *obj in self) {
        
        ///判断类型
        if (![obj isKindOfClass:[NSString class]]) {
            
            NSLog(@"====================中英文混排日志====================");
            NSLog(@"::::::::::当前数据源中存在非字符串对象，无法成功排序");
            NSLog(@"====================中英文混排日志====================");
            
            ///回调
            if (callBack) {
                
                callBack(NO,nil,nil);
                
            }
            return;
            
        }
        
        ///转为字符串
        NSString *contactName = (NSString *)obj;
        
        ///获取首字母
        NSString *firstLetter = [PinyinHelper toHanyuPinyinStringWithNSString:contactName withHanyuPinyinOutputFormat:nil withNSString:@""];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:contactName];
        
    }
    
    ///每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            
            ///第一个元素纯英文
            if (![self isIncludeChineseInString:obj1] &&
                [self isIncludeChineseInString:obj2]) {
                
                return NO;
                
            }
            
            ///第二个元素纯英文，第一个元素有中文
            if ([self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return YES;
                
            }
            
            ///两个元素都是英文
            if (![self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return [obj1 caseInsensitiveCompare:obj2];
                
            }
            
            ///两个元素都有中文
            HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
            [outputFormat setToneType:ToneTypeWithoutTone];
            [outputFormat setVCharType:VCharTypeWithV];
            [outputFormat setCaseType:CaseTypeLowercase];
            
            ///获取第一个元素的全中文
            NSString *firstString1 = [PinyinHelper toHanyuPinyinStringWithNSString:obj1 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter1 = [firstString1 characterAtIndex:0];
            
            ///获取第二个元素的全中文
            NSString *firstString2 = [PinyinHelper toHanyuPinyinStringWithNSString:obj2 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter2 = [firstString2 characterAtIndex:0];
            
            ///先按首字母排序
            if (firstLetter1 != firstLetter2) {
                
                return firstLetter1 > firstLetter2;
                
            }
            
            ///全中文首字母
            NSArray *tempArray1 = [firstString1 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr1 = [NSMutableString string];
            for (int i = 0; i < [tempArray1 count]; i++) {
                
                NSString *singleWord = tempArray1[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr1 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            NSArray *tempArray2 = [firstString2 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr2 = [NSMutableString string];
            for (int i = 0; i < [tempArray2 count]; i++) {
                
                NSString *singleWord = tempArray2[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr2 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            ///首字母不相同，则返回对比结果
            if (!(NSOrderedSame == [tempPinYinHeadStr1 caseInsensitiveCompare:tempPinYinHeadStr2])) {
                
                return [tempPinYinHeadStr1 caseInsensitiveCompare:tempPinYinHeadStr2];
                
            }
            
            ///进行全字母排序
            NSString *firstMString1 = [firstString1 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            NSString *firstMString2 = [firstString2 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            
            return [firstMString1 caseInsensitiveCompare:firstMString2];
            
        }];
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
        
    }
    
    ///重置原始数据
    NSMutableIndexSet *emtyIndexSet = [NSMutableIndexSet indexSet];
    for (int i = 0; i < [titleDataSource count]; i++) {
        
        if ([[sortedArray objectAtIndex:i] count] <= 0) {
            
            [emtyIndexSet addIndex:i];
            
        }
        
    }
    
    ///清空无效标题
    [titleDataSource removeObjectsAtIndexes:emtyIndexSet];
    [sortedArray removeObjectsAtIndexes:emtyIndexSet];
    for (int i = (int)[sortedArray count]; i > 0 ; i--) {
        
        NSArray *tempArray = sortedArray[i - 1];
        if ([tempArray count] <= 0) {
            
            [sortedArray removeObjectAtIndex:i - 1];
            
        }
        
    }
    
    ///回调成功
    if (callBack) {
        
        callBack(YES,[NSArray arrayWithArray:titleDataSource],[NSArray arrayWithArray:sortedArray]);
        
    }

}

/**
 *  @author         yangshengmeng, 15-05-19 00:05:58
 *
 *  @brief          字符串数组中英文混排(中文简体和繁体)：降序，中文在前，英文在后
 *
 *  @param callBack 排序完成后的回调
 *
 *  @since          1.0.0
 */
- (void)sortContactTOTitleAndSectionRow_DA_CE:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack
{

    ///判断当前数组的个数
    if (0 >= [self count]) {
        
        NSLog(@"====================中英文混排日志====================");
        NSLog(@"::::::::::当前数据源无元素，无需排序");
        NSLog(@"====================中英文混排日志====================");
        
        ///回调
        if (callBack) {
            
            callBack(NO,nil,nil);
            
        }
        
    }
    
    ///建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *titleDataSource = [NSMutableArray arrayWithArray:[indexCollation sectionTitles]];
    
    ///返回27，是a－z和＃
    NSInteger highSection = [titleDataSource count];
    
    ///初始添加27个section对应的数组
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
        
    }
    
    ///名字分section
    for (NSObject *obj in self) {
        
        ///判断类型
        if (![obj isKindOfClass:[NSString class]]) {
            
            NSLog(@"====================中英文混排日志====================");
            NSLog(@"::::::::::当前数据源中存在非字符串对象，无法成功排序");
            NSLog(@"====================中英文混排日志====================");
            
            ///回调
            if (callBack) {
                
                callBack(NO,nil,nil);
                
            }
            return;
            
        }
        
        ///转为字符串
        NSString *contactName = (NSString *)obj;
        
        ///获取首字母
        NSString *firstLetter = [PinyinHelper toHanyuPinyinStringWithNSString:contactName withHanyuPinyinOutputFormat:nil withNSString:@""];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:contactName];
        
    }
    
    ///每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            
            ///第一个元素纯英文
            if (![self isIncludeChineseInString:obj1] &&
                [self isIncludeChineseInString:obj2]) {
                
                return YES;
                
            }
            
            ///第二个元素纯英文，第一个元素有中文
            if ([self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return NO;
                
            }
            
            ///两个元素都是英文
            if (![self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return [obj2 caseInsensitiveCompare:obj1];
                
            }
            
            ///两个元素都有中文
            HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
            [outputFormat setToneType:ToneTypeWithoutTone];
            [outputFormat setVCharType:VCharTypeWithV];
            [outputFormat setCaseType:CaseTypeLowercase];
            
            ///获取第一个元素的全中文
            NSString *firstString1 = [PinyinHelper toHanyuPinyinStringWithNSString:obj1 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter1 = [firstString1 characterAtIndex:0];
            
            ///获取第二个元素的全中文
            NSString *firstString2 = [PinyinHelper toHanyuPinyinStringWithNSString:obj2 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter2 = [firstString2 characterAtIndex:0];
            
            ///先按首字母排序
            if (firstLetter1 != firstLetter2) {
                
                return firstLetter1 < firstLetter2;
                
            }
            
            ///全中文首字母
            NSArray *tempArray1 = [firstString1 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr1 = [NSMutableString string];
            for (int i = 0; i < [tempArray1 count]; i++) {
                
                NSString *singleWord = tempArray1[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr1 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            NSArray *tempArray2 = [firstString2 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr2 = [NSMutableString string];
            for (int i = 0; i < [tempArray2 count]; i++) {
                
                NSString *singleWord = tempArray2[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr2 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            ///首字母不相同，则返回对比结果
            if (!(NSOrderedSame == [tempPinYinHeadStr1 caseInsensitiveCompare:tempPinYinHeadStr2])) {
                
                return [tempPinYinHeadStr2 caseInsensitiveCompare:tempPinYinHeadStr1];
                
            }
            
            ///进行全字母排序
            NSString *firstMString1 = [firstString1 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            NSString *firstMString2 = [firstString2 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            
            return [firstMString2 caseInsensitiveCompare:firstMString1];
            
        }];
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
        
    }
    
    ///重置原始数据
    NSMutableIndexSet *emtyIndexSet = [NSMutableIndexSet indexSet];
    for (int i = 0; i < [titleDataSource count]; i++) {
        
        if ([[sortedArray objectAtIndex:i] count] <= 0) {
            
            [emtyIndexSet addIndex:i];
            
        }
        
    }
    
    ///清空无效标题
    [titleDataSource removeObjectsAtIndexes:emtyIndexSet];
    [sortedArray removeObjectsAtIndexes:emtyIndexSet];
    for (int i = (int)[sortedArray count]; i > 0 ; i--) {
        
        NSArray *tempArray = sortedArray[i - 1];
        if ([tempArray count] <= 0) {
            
            [sortedArray removeObjectAtIndex:i - 1];
            
        }
        
    }
    
    ///回调成功
    if (callBack) {
        
        callBack(YES,[NSArray arrayWithArray:titleDataSource],[NSArray arrayWithArray:sortedArray]);
        
    }

}

/**
 *  @author         yangshengmeng, 15-05-19 00:05:58
 *
 *  @brief          字符串数组中英文混排(中文简体和繁体)：降序,英文在前，中文在后
 *
 *  @param callBack 排序完成后的回调
 *
 *  @since          1.0.0
 */
- (void)sortContactTOTitleAndSectionRow_DA_EC:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack
{

    ///判断当前数组的个数
    if (0 >= [self count]) {
        
        NSLog(@"====================中英文混排日志====================");
        NSLog(@"::::::::::当前数据源无元素，无需排序");
        NSLog(@"====================中英文混排日志====================");
        
        ///回调
        if (callBack) {
            
            callBack(NO,nil,nil);
            
        }
        
    }
    
    ///建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *titleDataSource = [NSMutableArray arrayWithArray:[indexCollation sectionTitles]];
    
    ///返回27，是a－z和＃
    NSInteger highSection = [titleDataSource count];
    
    ///初始添加27个section对应的数组
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
        
    }
    
    ///名字分section
    for (NSObject *obj in self) {
        
        ///判断类型
        if (![obj isKindOfClass:[NSString class]]) {
            
            NSLog(@"====================中英文混排日志====================");
            NSLog(@"::::::::::当前数据源中存在非字符串对象，无法成功排序");
            NSLog(@"====================中英文混排日志====================");
            
            ///回调
            if (callBack) {
                
                callBack(NO,nil,nil);
                
            }
            return;
            
        }
        
        ///转为字符串
        NSString *contactName = (NSString *)obj;
        
        ///获取首字母
        NSString *firstLetter = [PinyinHelper toHanyuPinyinStringWithNSString:contactName withHanyuPinyinOutputFormat:nil withNSString:@""];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:contactName];
        
    }
    
    ///每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            
            ///第一个元素纯英文
            if (![self isIncludeChineseInString:obj1] &&
                [self isIncludeChineseInString:obj2]) {
                
                return NO;
                
            }
            
            ///第二个元素纯英文，第一个元素有中文
            if ([self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return YES;
                
            }
            
            ///两个元素都是英文
            if (![self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return [obj2 caseInsensitiveCompare:obj1];
                
            }
            
            ///两个元素都有中文
            HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
            [outputFormat setToneType:ToneTypeWithoutTone];
            [outputFormat setVCharType:VCharTypeWithV];
            [outputFormat setCaseType:CaseTypeLowercase];
            
            ///获取第一个元素的全中文
            NSString *firstString1 = [PinyinHelper toHanyuPinyinStringWithNSString:obj1 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter1 = [firstString1 characterAtIndex:0];
            
            ///获取第二个元素的全中文
            NSString *firstString2 = [PinyinHelper toHanyuPinyinStringWithNSString:obj2 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter2 = [firstString2 characterAtIndex:0];
            
            ///先按首字母排序
            if (firstLetter1 != firstLetter2) {
                
                return firstLetter1 < firstLetter2;
                
            }
            
            ///全中文首字母
            NSArray *tempArray1 = [firstString1 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr1 = [NSMutableString string];
            for (int i = 0; i < [tempArray1 count]; i++) {
                
                NSString *singleWord = tempArray1[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr1 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            NSArray *tempArray2 = [firstString2 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr2 = [NSMutableString string];
            for (int i = 0; i < [tempArray2 count]; i++) {
                
                NSString *singleWord = tempArray2[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr2 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            ///首字母不相同，则返回对比结果
            if (!(NSOrderedSame == [tempPinYinHeadStr1 caseInsensitiveCompare:tempPinYinHeadStr2])) {
                
                return [tempPinYinHeadStr2 caseInsensitiveCompare:tempPinYinHeadStr1];
                
            }
            
            ///进行全字母排序
            NSString *firstMString1 = [firstString1 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            NSString *firstMString2 = [firstString2 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            
            return [firstMString2 caseInsensitiveCompare:firstMString1];
            
        }];
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
        
    }
    
    ///重置原始数据
    NSMutableIndexSet *emtyIndexSet = [NSMutableIndexSet indexSet];
    for (int i = 0; i < [titleDataSource count]; i++) {
        
        if ([[sortedArray objectAtIndex:i] count] <= 0) {
            
            [emtyIndexSet addIndex:i];
            
        }
        
    }
    
    ///清空无效标题
    [titleDataSource removeObjectsAtIndexes:emtyIndexSet];
    [sortedArray removeObjectsAtIndexes:emtyIndexSet];
    for (int i = (int)[sortedArray count]; i > 0 ; i--) {
        
        NSArray *tempArray = sortedArray[i - 1];
        if ([tempArray count] <= 0) {
            
            [sortedArray removeObjectAtIndex:i - 1];
            
        }
        
    }
    
    ///回调成功
    if (callBack) {
        
        callBack(YES,[NSArray arrayWithArray:titleDataSource],[NSArray arrayWithArray:sortedArray]);
        
    }

}

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
- (void)sortContactTOTitleAndSectionRowWithKey_A_CE:(NSString *)sortKey callBack:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack
{

    ///判断当前数组的个数
    if (0 >= [self count]) {
        
        NSLog(@"====================中英文混排日志====================");
        NSLog(@"::::::::::当前数据源无元素，无需排序");
        NSLog(@"====================中英文混排日志====================");
        
        ///回调
        if (callBack) {
            
            callBack(NO,nil,nil);
            
        }
        
    }
    
    ///判断获取的key
    if ([sortKey length] <= 0) {
        
        NSLog(@"====================中英文混排日志====================");
        NSLog(@"::::::::::给定的排序sortKey无效");
        NSLog(@"====================中英文混排日志====================");
        
        ///回调
        if (callBack) {
            
            callBack(NO,nil,nil);
            
        }
        
        return;
        
    }
    
    ///建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *titleDataSource = [NSMutableArray arrayWithArray:[indexCollation sectionTitles]];
    
    ///返回27，是a－z和＃
    NSInteger highSection = [titleDataSource count];
    
    ///初始添加27个section对应的数组
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
        
    }
    
    ///名字分section
    for (NSObject *obj in self) {
        
        ///获取临时类型
        NSObject *tempObject = [obj valueForKey:sortKey];
        
        ///判断类型
        if (![tempObject isKindOfClass:[NSString class]]) {
            
            NSLog(@"====================中英文混排日志====================");
            NSLog(@"::::::::::当前数据源中的对象，根据sortKey获取的对象非字符串对象，无法成功排序");
            NSLog(@"====================中英文混排日志====================");
            
            ///回调
            if (callBack) {
                
                callBack(NO,nil,nil);
                
            }
            return;
            
        }
        
        ///转为字符串
        NSString *contactName = (NSString *)tempObject;
        
        ///获取首字母
        NSString *firstLetter = [PinyinHelper toHanyuPinyinStringWithNSString:contactName withHanyuPinyinOutputFormat:nil withNSString:@""];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:obj];
        
    }
    
    ///每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSObject *firstObject, NSObject *secondObject) {
            
            ///获取对象
            NSString *obj1 = [firstObject valueForKey:sortKey];
            NSString *obj2 = [secondObject valueForKey:sortKey];
            
            ///第一个元素纯英文
            if (![self isIncludeChineseInString:obj1] &&
                [self isIncludeChineseInString:obj2]) {
                
                return YES;
                
            }
            
            ///第二个元素纯英文，第一个元素有中文
            if ([self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return NO;
                
            }
            
            ///两个元素都是英文
            if (![self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return [obj1 caseInsensitiveCompare:obj2];
                
            }
            
            ///两个元素都有中文
            HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
            [outputFormat setToneType:ToneTypeWithoutTone];
            [outputFormat setVCharType:VCharTypeWithV];
            [outputFormat setCaseType:CaseTypeLowercase];
            
            ///获取第一个元素的全拼音
            NSString *firstString1 = [PinyinHelper toHanyuPinyinStringWithNSString:obj1 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter1 = [firstString1 characterAtIndex:0];
            
            ///获取第二个元素的全拼音
            NSString *firstString2 = [PinyinHelper toHanyuPinyinStringWithNSString:obj2 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter2 = [firstString2 characterAtIndex:0];
            
            ///先按首字母排序
            if (firstLetter1 != firstLetter2) {
                
                return firstLetter1 > firstLetter2;
                
            }
            
            ///全中文首字母
            NSArray *tempArray1 = [firstString1 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr1 = [NSMutableString string];
            for (int i = 0; i < [tempArray1 count]; i++) {
                
                NSString *singleWord = tempArray1[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr1 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            NSArray *tempArray2 = [firstString2 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr2 = [NSMutableString string];
            for (int i = 0; i < [tempArray2 count]; i++) {
                
                NSString *singleWord = tempArray2[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr2 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            ///首字母不相同，则返回对比结果
            if (!(NSOrderedSame == [tempPinYinHeadStr1 caseInsensitiveCompare:tempPinYinHeadStr2])) {
                
                return [tempPinYinHeadStr1 caseInsensitiveCompare:tempPinYinHeadStr2];
                
            }
            
            ///进行全字母排序
            NSString *firstMString1 = [firstString1 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            NSString *firstMString2 = [firstString2 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            
            return [firstMString1 caseInsensitiveCompare:firstMString2];
            
        }];
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
        
    }
    
    ///重置原始数据
    NSMutableIndexSet *emtyIndexSet = [NSMutableIndexSet indexSet];
    for (int i = 0; i < [titleDataSource count]; i++) {
        
        if ([[sortedArray objectAtIndex:i] count] <= 0) {
            
            [emtyIndexSet addIndex:i];
            
        }
        
    }
    
    ///清空无效标题
    [titleDataSource removeObjectsAtIndexes:emtyIndexSet];
    [sortedArray removeObjectsAtIndexes:emtyIndexSet];
    for (int i = (int)[sortedArray count]; i > 0 ; i--) {
        
        NSArray *tempArray = sortedArray[i - 1];
        if ([tempArray count] <= 0) {
            
            [sortedArray removeObjectAtIndex:i - 1];
            
        }
        
    }
    
    ///回调成功
    if (callBack) {
        
        callBack(YES,[NSArray arrayWithArray:titleDataSource],[NSArray arrayWithArray:sortedArray]);
        
    }

}

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
- (void)sortContactTOTitleAndSectionRowWithKey_A_EC:(NSString *)sortKey callBack:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack
{

    ///判断当前数组的个数
    if (0 >= [self count]) {
        
        NSLog(@"====================中英文混排日志====================");
        NSLog(@"::::::::::当前数据源无元素，无需排序");
        NSLog(@"====================中英文混排日志====================");
        
        ///回调
        if (callBack) {
            
            callBack(NO,nil,nil);
            
        }
        
    }
    
    ///判断获取的key
    if ([sortKey length] <= 0) {
        
        NSLog(@"====================中英文混排日志====================");
        NSLog(@"::::::::::给定的排序sortKey无效");
        NSLog(@"====================中英文混排日志====================");
        
        ///回调
        if (callBack) {
            
            callBack(NO,nil,nil);
            
        }
        
        return;
        
    }
    
    ///建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *titleDataSource = [NSMutableArray arrayWithArray:[indexCollation sectionTitles]];
    
    ///返回27，是a－z和＃
    NSInteger highSection = [titleDataSource count];
    
    ///初始添加27个section对应的数组
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
        
    }
    
    ///名字分section
    for (NSObject *obj in self) {
        
        ///获取临时类型
        NSObject *tempObject = [obj valueForKey:sortKey];
        
        ///判断类型
        if (![tempObject isKindOfClass:[NSString class]]) {
            
            NSLog(@"====================中英文混排日志====================");
            NSLog(@"::::::::::当前数据源中的对象，根据sortKey获取的对象非字符串对象，无法成功排序");
            NSLog(@"====================中英文混排日志====================");
            
            ///回调
            if (callBack) {
                
                callBack(NO,nil,nil);
                
            }
            return;
            
        }
        
        ///转为字符串
        NSString *contactName = (NSString *)tempObject;
        
        ///获取首字母
        NSString *firstLetter = [PinyinHelper toHanyuPinyinStringWithNSString:contactName withHanyuPinyinOutputFormat:nil withNSString:@""];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:obj];
        
    }
    
    ///每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSObject *firstObject, NSObject *secondObject) {
            
            ///获取对象
            NSString *obj1 = [firstObject valueForKey:sortKey];
            NSString *obj2 = [secondObject valueForKey:sortKey];
            
            ///第一个元素纯英文
            if (![self isIncludeChineseInString:obj1] &&
                [self isIncludeChineseInString:obj2]) {
                
                return NO;
                
            }
            
            ///第二个元素纯英文，第一个元素有中文
            if ([self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return YES;
                
            }
            
            ///两个元素都是英文
            if (![self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return [obj1 caseInsensitiveCompare:obj2];
                
            }
            
            ///两个元素都有中文
            HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
            [outputFormat setToneType:ToneTypeWithoutTone];
            [outputFormat setVCharType:VCharTypeWithV];
            [outputFormat setCaseType:CaseTypeLowercase];
            
            ///获取第一个元素的全拼音
            NSString *firstString1 = [PinyinHelper toHanyuPinyinStringWithNSString:obj1 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter1 = [firstString1 characterAtIndex:0];
            
            ///获取第二个元素的全拼音
            NSString *firstString2 = [PinyinHelper toHanyuPinyinStringWithNSString:obj2 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter2 = [firstString2 characterAtIndex:0];
            
            ///先按首字母排序
            if (firstLetter1 != firstLetter2) {
                
                return firstLetter1 > firstLetter2;
                
            }
            
            ///全中文首字母
            NSArray *tempArray1 = [firstString1 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr1 = [NSMutableString string];
            for (int i = 0; i < [tempArray1 count]; i++) {
                
                NSString *singleWord = tempArray1[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr1 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            NSArray *tempArray2 = [firstString2 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr2 = [NSMutableString string];
            for (int i = 0; i < [tempArray2 count]; i++) {
                
                NSString *singleWord = tempArray2[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr2 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            ///首字母不相同，则返回对比结果
            if (!(NSOrderedSame == [tempPinYinHeadStr1 caseInsensitiveCompare:tempPinYinHeadStr2])) {
                
                return [tempPinYinHeadStr1 caseInsensitiveCompare:tempPinYinHeadStr2];
                
            }
            
            ///进行全字母排序
            NSString *firstMString1 = [firstString1 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            NSString *firstMString2 = [firstString2 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            
            return [firstMString1 caseInsensitiveCompare:firstMString2];
            
        }];
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
        
    }
    
    ///重置原始数据
    NSMutableIndexSet *emtyIndexSet = [NSMutableIndexSet indexSet];
    for (int i = 0; i < [titleDataSource count]; i++) {
        
        if ([[sortedArray objectAtIndex:i] count] <= 0) {
            
            [emtyIndexSet addIndex:i];
            
        }
        
    }
    
    ///清空无效标题
    [titleDataSource removeObjectsAtIndexes:emtyIndexSet];
    [sortedArray removeObjectsAtIndexes:emtyIndexSet];
    for (int i = (int)[sortedArray count]; i > 0 ; i--) {
        
        NSArray *tempArray = sortedArray[i - 1];
        if ([tempArray count] <= 0) {
            
            [sortedArray removeObjectAtIndex:i - 1];
            
        }
        
    }
    
    ///回调成功
    if (callBack) {
        
        callBack(YES,[NSArray arrayWithArray:titleDataSource],[NSArray arrayWithArray:sortedArray]);
        
    }

}

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
- (void)sortContactTOTitleAndSectionRowWithKey_DA_CE:(NSString *)sortKey callBack:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack
{

    ///判断当前数组的个数
    if (0 >= [self count]) {
        
        NSLog(@"====================中英文混排日志====================");
        NSLog(@"::::::::::当前数据源无元素，无需排序");
        NSLog(@"====================中英文混排日志====================");
        
        ///回调
        if (callBack) {
            
            callBack(NO,nil,nil);
            
        }
        
    }
    
    ///判断获取的key
    if ([sortKey length] <= 0) {
        
        NSLog(@"====================中英文混排日志====================");
        NSLog(@"::::::::::给定的排序sortKey无效");
        NSLog(@"====================中英文混排日志====================");
        
        ///回调
        if (callBack) {
            
            callBack(NO,nil,nil);
            
        }
        
        return;
        
    }
    
    ///建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *titleDataSource = [NSMutableArray arrayWithArray:[indexCollation sectionTitles]];
    
    ///返回27，是a－z和＃
    NSInteger highSection = [titleDataSource count];
    
    ///初始添加27个section对应的数组
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
        
    }
    
    ///名字分section
    for (NSObject *obj in self) {
        
        ///获取临时类型
        NSObject *tempObject = [obj valueForKey:sortKey];
        
        ///判断类型
        if (![tempObject isKindOfClass:[NSString class]]) {
            
            NSLog(@"====================中英文混排日志====================");
            NSLog(@"::::::::::当前数据源中的对象，根据sortKey获取的对象非字符串对象，无法成功排序");
            NSLog(@"====================中英文混排日志====================");
            
            ///回调
            if (callBack) {
                
                callBack(NO,nil,nil);
                
            }
            return;
            
        }
        
        ///转为字符串
        NSString *contactName = (NSString *)tempObject;
        
        ///获取首字母
        NSString *firstLetter = [PinyinHelper toHanyuPinyinStringWithNSString:contactName withHanyuPinyinOutputFormat:nil withNSString:@""];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:obj];
        
    }
    
    ///每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSObject *firstObject, NSObject *secondObject) {
            
            ///获取对象
            NSString *obj1 = [firstObject valueForKey:sortKey];
            NSString *obj2 = [secondObject valueForKey:sortKey];
            
            ///第一个元素纯英文
            if (![self isIncludeChineseInString:obj1] &&
                [self isIncludeChineseInString:obj2]) {
                
                return YES;
                
            }
            
            ///第二个元素纯英文，第一个元素有中文
            if ([self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return NO;
                
            }
            
            ///两个元素都是英文
            if (![self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return [obj2 caseInsensitiveCompare:obj1];
                
            }
            
            ///两个元素都有中文
            HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
            [outputFormat setToneType:ToneTypeWithoutTone];
            [outputFormat setVCharType:VCharTypeWithV];
            [outputFormat setCaseType:CaseTypeLowercase];
            
            ///获取第一个元素的全拼音
            NSString *firstString1 = [PinyinHelper toHanyuPinyinStringWithNSString:obj1 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter1 = [firstString1 characterAtIndex:0];
            
            ///获取第二个元素的全拼音
            NSString *firstString2 = [PinyinHelper toHanyuPinyinStringWithNSString:obj2 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter2 = [firstString2 characterAtIndex:0];
            
            ///先按首字母排序
            if (firstLetter1 != firstLetter2) {
                
                return firstLetter1 < firstLetter2;
                
            }
            
            ///全中文首字母
            NSArray *tempArray1 = [firstString1 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr1 = [NSMutableString string];
            for (int i = 0; i < [tempArray1 count]; i++) {
                
                NSString *singleWord = tempArray1[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr1 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            NSArray *tempArray2 = [firstString2 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr2 = [NSMutableString string];
            for (int i = 0; i < [tempArray2 count]; i++) {
                
                NSString *singleWord = tempArray2[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr2 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            ///首字母不相同，则返回对比结果
            if (!(NSOrderedSame == [tempPinYinHeadStr1 caseInsensitiveCompare:tempPinYinHeadStr2])) {
                
                return [tempPinYinHeadStr2 caseInsensitiveCompare:tempPinYinHeadStr1];
                
            }
            
            ///进行全字母排序
            NSString *firstMString1 = [firstString1 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            NSString *firstMString2 = [firstString2 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            
            return [firstMString2 caseInsensitiveCompare:firstMString1];
            
        }];
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
        
    }
    
    ///重置原始数据
    NSMutableIndexSet *emtyIndexSet = [NSMutableIndexSet indexSet];
    for (int i = 0; i < [titleDataSource count]; i++) {
        
        if ([[sortedArray objectAtIndex:i] count] <= 0) {
            
            [emtyIndexSet addIndex:i];
            
        }
        
    }
    
    ///清空无效标题
    [titleDataSource removeObjectsAtIndexes:emtyIndexSet];
    [sortedArray removeObjectsAtIndexes:emtyIndexSet];
    for (int i = (int)[sortedArray count]; i > 0 ; i--) {
        
        NSArray *tempArray = sortedArray[i - 1];
        if ([tempArray count] <= 0) {
            
            [sortedArray removeObjectAtIndex:i - 1];
            
        }
        
    }
    
    ///回调成功
    if (callBack) {
        
        callBack(YES,[NSArray arrayWithArray:titleDataSource],[NSArray arrayWithArray:sortedArray]);
        
    }

}

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
- (void)sortContactTOTitleAndSectionRowWithKey_DA_EC:(NSString *)sortKey callBack:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack
{

    ///判断当前数组的个数
    if (0 >= [self count]) {
        
        NSLog(@"====================中英文混排日志====================");
        NSLog(@"::::::::::当前数据源无元素，无需排序");
        NSLog(@"====================中英文混排日志====================");
        
        ///回调
        if (callBack) {
            
            callBack(NO,nil,nil);
            
        }
        
    }
    
    ///判断获取的key
    if ([sortKey length] <= 0) {
        
        NSLog(@"====================中英文混排日志====================");
        NSLog(@"::::::::::给定的排序sortKey无效");
        NSLog(@"====================中英文混排日志====================");
        
        ///回调
        if (callBack) {
            
            callBack(NO,nil,nil);
            
        }
        
        return;
        
    }
    
    ///建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *titleDataSource = [NSMutableArray arrayWithArray:[indexCollation sectionTitles]];
    
    ///返回27，是a－z和＃
    NSInteger highSection = [titleDataSource count];
    
    ///初始添加27个section对应的数组
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
        
    }
    
    ///名字分section
    for (NSObject *obj in self) {
        
        ///获取临时类型
        NSObject *tempObject = [obj valueForKey:sortKey];
        
        ///判断类型
        if (![tempObject isKindOfClass:[NSString class]]) {
            
            NSLog(@"====================中英文混排日志====================");
            NSLog(@"::::::::::当前数据源中的对象，根据sortKey获取的对象非字符串对象，无法成功排序");
            NSLog(@"====================中英文混排日志====================");
            
            ///回调
            if (callBack) {
                
                callBack(NO,nil,nil);
                
            }
            return;
            
        }
        
        ///转为字符串
        NSString *contactName = (NSString *)tempObject;
        
        ///获取首字母
        NSString *firstLetter = [PinyinHelper toHanyuPinyinStringWithNSString:contactName withHanyuPinyinOutputFormat:nil withNSString:@""];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:obj];
        
    }
    
    ///每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSObject *firstObject, NSObject *secondObject) {
            
            ///获取对象
            NSString *obj1 = [firstObject valueForKey:sortKey];
            NSString *obj2 = [secondObject valueForKey:sortKey];
            
            ///第一个元素纯英文
            if (![self isIncludeChineseInString:obj1] &&
                [self isIncludeChineseInString:obj2]) {
                
                return NO;
                
            }
            
            ///第二个元素纯英文，第一个元素有中文
            if ([self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return YES;
                
            }
            
            ///两个元素都是英文
            if (![self isIncludeChineseInString:obj1] &&
                ![self isIncludeChineseInString:obj2]) {
                
                return [obj2 caseInsensitiveCompare:obj1];
                
            }
            
            ///两个元素都有中文
            HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
            [outputFormat setToneType:ToneTypeWithoutTone];
            [outputFormat setVCharType:VCharTypeWithV];
            [outputFormat setCaseType:CaseTypeLowercase];
            
            ///获取第一个元素的全拼音
            NSString *firstString1 = [PinyinHelper toHanyuPinyinStringWithNSString:obj1 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter1 = [firstString1 characterAtIndex:0];
            
            ///获取第二个元素的全拼音
            NSString *firstString2 = [PinyinHelper toHanyuPinyinStringWithNSString:obj2 withHanyuPinyinOutputFormat:outputFormat withNSString:@"<>"];
            char firstLetter2 = [firstString2 characterAtIndex:0];
            
            ///先按首字母排序
            if (firstLetter1 != firstLetter2) {
                
                return firstLetter1 < firstLetter2;
                
            }
            
            ///全中文首字母
            NSArray *tempArray1 = [firstString1 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr1 = [NSMutableString string];
            for (int i = 0; i < [tempArray1 count]; i++) {
                
                NSString *singleWord = tempArray1[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr1 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            NSArray *tempArray2 = [firstString2 componentsSeparatedByString:@"<>"];
            NSMutableString *tempPinYinHeadStr2 = [NSMutableString string];
            for (int i = 0; i < [tempArray2 count]; i++) {
                
                NSString *singleWord = tempArray2[i];
                if ([singleWord length] > 0) {
                    
                    char firstChar = [singleWord characterAtIndex:0];
                    if ((firstChar >= 97 && firstChar <= 122) ||
                        (firstChar >= 65 && firstChar <= 90) ||
                        (firstChar >= 80 && firstChar <= 89)) {
                        
                        [tempPinYinHeadStr2 appendString:[singleWord substringToIndex:1]];
                        
                    }
                    
                }
                
            }
            
            ///首字母不相同，则返回对比结果
            if (!(NSOrderedSame == [tempPinYinHeadStr1 caseInsensitiveCompare:tempPinYinHeadStr2])) {
                
                return [tempPinYinHeadStr2 caseInsensitiveCompare:tempPinYinHeadStr1];
                
            }
            
            ///进行全字母排序
            NSString *firstMString1 = [firstString1 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            NSString *firstMString2 = [firstString2 stringByReplacingOccurrencesOfString:@"<>" withString:@""];
            
            return [firstMString2 caseInsensitiveCompare:firstMString1];
            
        }];
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
        
    }
    
    ///重置原始数据
    NSMutableIndexSet *emtyIndexSet = [NSMutableIndexSet indexSet];
    for (int i = 0; i < [titleDataSource count]; i++) {
        
        if ([[sortedArray objectAtIndex:i] count] <= 0) {
            
            [emtyIndexSet addIndex:i];
            
        }
        
    }
    
    ///清空无效标题
    [titleDataSource removeObjectsAtIndexes:emtyIndexSet];
    [sortedArray removeObjectsAtIndexes:emtyIndexSet];
    for (int i = (int)[sortedArray count]; i > 0 ; i--) {
        
        NSArray *tempArray = sortedArray[i - 1];
        if ([tempArray count] <= 0) {
            
            [sortedArray removeObjectAtIndex:i - 1];
            
        }
        
    }
    
    ///回调成功
    if (callBack) {
        
        callBack(YES,[NSArray arrayWithArray:titleDataSource],[NSArray arrayWithArray:sortedArray]);
        
    }

}

#pragma mark - 判断给定字符串中是否包涵有中文字符
- (BOOL)isIncludeChineseInString:(NSString*)str
{
    
    for (int i = 0; i < str.length; i++) {
        
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            
            return true;
            
        }
        
    }
    
    return false;
    
}

@end
