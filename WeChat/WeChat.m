//
//  MyDatabaseManager.m
//  DatabaseManager

#import "DateUtil.h"
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

#pragma mark - select
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
                           fetchLimit:(NSUInteger)limit
{
  NSFetchRequest* request = [[NSFetchRequest alloc] init];
  request.entity =
    [NSEntityDescription entityForName:NSStringFromClass([Messages class])
                inManagedObjectContext:self.managedObjectContext];

  if ([attribute length])
    request.sortDescriptors =
      @[ [[NSSortDescriptor alloc] initWithKey:attribute ascending:false] ];

  if (predicate)
    request.predicate = predicate;

  if (limit > 0)
    request.fetchLimit = limit;

  __block NSArray* objects = nil;
  [self.managedObjectContext performBlockAndWait:^{
    objects = [self.managedObjectContext executeFetchRequest:request error:nil];
  }];

  return objects;
}
- (NSArray*)messagesBeforeTimeInterval:(NSTimeInterval)interval
                            fetchLimit:(NSUInteger)fetchLimit
{
  NSDate* date = [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
  /*
   Mark:
   这里的字段类型本来就是Date，所以直接传个NSDate进去就行了
   还有就是开了SQLite调试之后控制台输出的参数值本来就是个问号，要看参数值得把
   -com.apple.CoreData.SQLDebug 1 调成 3
   */
  NSPredicate* predicate =
    [NSPredicate predicateWithFormat:@"(sendTime < %@)", date];
  //取出最后的n条数据
  NSArray* result = [self allRecordsSortByAttribute:kdb_Messages_sendTime
                                     wherePredicate:predicate
                                          ascending:false
                                         fetchLimit:fetchLimit];

  //取出来的数据是倒序的，需要再排成顺序
  result = [result sortedArrayUsingComparator:^NSComparisonResult(
                     Messages* obj1, Messages* obj2) {
    if (obj1.sendTime < obj2.sendTime)
      return (NSComparisonResult)
        NSOrderedAscending; // left obj should bigger than right obj
    else if (obj1.sendTime > obj2.sendTime)
      return (NSComparisonResult)
        NSOrderedDescending; // left obj should smaller than right obj

    return (NSComparisonResult)NSOrderedSame;
  }];

  return result;
}
#pragma mark - insert&update
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
#pragma mark - delete
- (BOOL)deleteTableRecord:(Messages*)record
{
  return [self deleteRecord:record];
}

#pragma mark -
- (BOOL)deleteAllTableRecord
{
  return [self flushTable:NSStringFromClass([Messages class])];
}
@end
