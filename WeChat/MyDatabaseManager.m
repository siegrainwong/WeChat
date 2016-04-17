//
//  MyDatabaseManager.m
//  DatabaseManager

#import "IQDatabaseManagerSubclass.h"
#import "MyDatabaseManager.h"

@implementation MyDatabaseManager

+ (NSURL*)modelURL
{
  NSURL* modelURL =
    [[NSBundle mainBundle] URLForResource:@"WeChat"
                            withExtension:IQ_MODEL_EXTENSION_momd];

  if (modelURL == nil)
    modelURL = [[NSBundle mainBundle] URLForResource:@"WeChat"
                                       withExtension:IQ_MODEL_EXTENSION_mom];

  return modelURL;
}

#pragma mark - RecordTable
- (NSArray*)allRecordsSortByAttribute:(NSString*)attribute
{
  NSSortDescriptor* sortDescriptor = nil;

  if ([attribute length])
    sortDescriptor =
      [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];

  return [self allObjectsFromTable:NSStringFromClass([ChatModel class])
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

  return [self allObjectsFromTable:NSStringFromClass([ChatModel class])
                             where:key
                          contains:value
                    sortDescriptor:sortDescriptor];
}

- (RecordTable*)insertRecordInRecordTable:(NSDictionary*)recordAttribute
{
  return (RecordTable*)[self
    insertRecordInTable:NSStringFromClass([RecordTable class])
          withAttribute:recordAttribute];
}

- (RecordTable*)insertUpdateRecordInRecordTable:(NSDictionary*)recordAttribute
{
  return (RecordTable*)[self
    insertRecordInTable:NSStringFromClass([RecordTable class])
          withAttribute:recordAttribute
       updateOnExistKey:kEmail
                 equals:[recordAttribute objectForKey:kEmail]];
}

- (RecordTable*)updateRecord:(RecordTable*)record
               inRecordTable:(NSDictionary*)recordAttribute
{
  return (RecordTable*)[self updateRecord:record withAttribute:recordAttribute];
}

- (BOOL)deleteTableRecord:(RecordTable*)record
{
  return [self deleteRecord:record];
}

- (BOOL)deleteAllTableRecord
{
  return [self flushTable:NSStringFromClass([RecordTable class])];
}

#pragma mark - Settings
- (Settings*)settings
{
  Settings* settings =
    (Settings*)[self firstObjectFromTable:NSStringFromClass([Settings class])];

  // No settings
  if (settings == nil) {
    // Inserting default settings
    NSDictionary* dict =
      [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],
                                                 kPassword, nil];

    settings =
      (Settings*)[self insertRecordInTable:NSStringFromClass([Settings class])
                             withAttribute:dict];
  }

  return settings;
}

- (Settings*)saveSettings:(NSDictionary*)settings
{
  Settings* mySettings =
    (Settings*)[self firstObjectFromTable:NSStringFromClass([Settings class])
                         createIfNotExist:YES];
  return (Settings*)[self updateRecord:mySettings withAttribute:settings];
}

@end
