//
//  MyDatabaseManager.m
//  DatabaseManager

#import "IQDatabaseManagerSubclass.h"
#import "WeChat.h"

@implementation WeChat

+ (NSURL*)modelURL
{
  NSURL* modelURL =
    [[NSBundle mainBundle] URLForResource:@"WeChat"
                            withExtension:IQ_MODEL_EXTENSION_momd];

  return modelURL;
}

#pragma mark - RecordTable
- (NSArray*)allRecordsSortByAttribute:(NSString*)attribute
{
  NSSortDescriptor* sortDescriptor = nil;

  if ([attribute length])
    sortDescriptor =
      [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];

  return [self allObjectsFromTable:NSStringFromClass([Messages class])
                    sortDescriptor:sortDescriptor];
}

- (NSArray*)allRecordsSortByAttribute:(NSString*)attribute
                                where:(NSString*)key
                             contains:(id)value
{
  NSSortDescriptor* sortDescriptor = nil;

  if ([attribute length])
    sortDescriptor =
      [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];

  return [self allObjectsFromTable:NSStringFromClass([Messages class])
                             where:key
                          contains:value
                    sortDescriptor:sortDescriptor];
}
- (NSArray*)allRecordsSortByAttribute:(NSString*)attribute
                       wherePredicate:(NSPredicate*)predicate
                            ascending:(BOOL)ascending
{
  NSSortDescriptor* sortDescriptor = nil;

  if ([attribute length])
    sortDescriptor =
      [[NSSortDescriptor alloc] initWithKey:attribute ascending:ascending];

  return [self allObjectsFromTable:NSStringFromClass([Messages class])
                    wherePredicate:predicate
                    sortDescriptor:sortDescriptor];
}
- (Messages*)insertRecordInRecordTable:(NSDictionary*)recordAttribute
{
  return (Messages*)[self
    insertRecordInTable:NSStringFromClass([Messages class])
          withAttribute:recordAttribute];
}

- (Messages*)insertUpdateRecordInRecordTable:(NSDictionary*)recordAttribute
{
  return (Messages*)[self
    insertRecordInTable:NSStringFromClass([Messages class])
          withAttribute:recordAttribute
       updateOnExistKey:@"_PK"
                 equals:[recordAttribute objectForKey:@"_PK"]];
}

- (Messages*)updateRecord:(Messages*)record
            inRecordTable:(NSDictionary*)recordAttribute
{
  return (Messages*)[self updateRecord:record withAttribute:recordAttribute];
}

- (BOOL)deleteTableRecord:(Messages*)record
{
  return [self deleteRecord:record];
}

- (BOOL)deleteAllTableRecord
{
  return [self flushTable:NSStringFromClass([Messages class])];
}
@end
