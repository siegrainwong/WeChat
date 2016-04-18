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
