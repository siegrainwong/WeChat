//
//  MyDatabaseManager.h
//  DatabaseManager

#import "IQDatabaseManager.h"
#import "MyDatabaseConstants.h"

@interface MyDatabaseManager : IQDatabaseManager

- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute;
- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute where:(NSString*)key contains:(id)value;

- (RecordTable*) insertRecordInRecordTable:(NSDictionary*)recordAttributes;
- (RecordTable*) insertUpdateRecordInRecordTable:(NSDictionary*)recordAttributes;
- (RecordTable*) updateRecord:(RecordTable*)record inRecordTable:(NSDictionary*)recordAttributes;
- (BOOL) deleteTableRecord:(RecordTable*)record;


- (BOOL) deleteAllTableRecord;

- (Settings*) settings;
- (Settings*) saveSettings:(NSDictionary*)settings;

@end
