//
//  MyDatabaseManager.h
//  DatabaseManager

#import "IQDatabaseManager.h"
#import "WechatConstants.h"

@interface WeChat : IQDatabaseManager

- (NSArray*)allRecordsSortByAttribute:(NSString*)attribute;
- (NSArray*)allRecordsSortByAttribute:(NSString*)attribute
                                where:(NSString*)key
                             contains:(id)value;

- (Messages*)insertRecordInRecordTable:(NSDictionary*)recordAttributes;
- (Messages*)insertUpdateRecordInRecordTable:(NSDictionary*)recordAttributes;
- (Messages*)updateRecord:(Messages*)record
            inRecordTable:(NSDictionary*)recordAttributes;
- (BOOL)deleteTableRecord:(Messages*)record;

- (BOOL)deleteAllTableRecord;

@end
