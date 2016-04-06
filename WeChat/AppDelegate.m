//
//  AppDelegate.m
//  WeChat
//
//  Created by Siegrain on 16/3/28.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"

@interface
AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application
  didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
  self.window.bounds = [UIScreen mainScreen].bounds;

  self.window.backgroundColor = [UIColor whiteColor];

  [self.window makeKeyAndVisible];

  MainTabBarController* mainTabVC = [[MainTabBarController alloc] init];
  self.window.rootViewController = mainTabVC;

  [self changeNav];

  return YES;
}
/**
 *  全局改变Nav
 */
- (void)changeNav
{
  //设置NavigationBar背景颜色
  [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:54 / 255.0
                                                                green:53 / 255.0
                                                                 blue:58 / 255.0
                                                                alpha:1]];
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  [[UINavigationBar appearance] setTitleTextAttributes:@{
    NSForegroundColorAttributeName : [UIColor whiteColor]
  }];
  //不设置这个无法修改状态栏字体颜色
  [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
}

- (void)applicationWillTerminate:(UIApplication*)application
{
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
  // Saves changes in the application's managed object context before the
  // application terminates.
  [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL*)applicationDocumentsDirectory
{
  // The directory the application uses to store the Core Data store file. This
  // code uses a directory named "Siegrain.WeChat" in the application's
  // documents directory.
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                 inDomains:NSUserDomainMask]
    lastObject];
}

- (NSManagedObjectModel*)managedObjectModel
{
  // The managed object model for the application. It is a fatal error for the
  // application not to be able to find and load its model.
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL* modelURL =
    [[NSBundle mainBundle] URLForResource:@"WeChat" withExtension:@"momd"];
  _managedObjectModel =
    [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
  // The persistent store coordinator for the application. This implementation
  // creates and returns a coordinator, having added the store for the
  // application to it.
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }

  // Create the coordinator and store

  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
    initWithManagedObjectModel:[self managedObjectModel]];
  NSURL* storeURL = [[self applicationDocumentsDirectory]
    URLByAppendingPathComponent:@"WeChat.sqlite"];
  NSError* error = nil;
  NSString* failureReason =
    @"There was an error creating or loading the application's saved data.";
  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:storeURL
                                                       options:nil
                                                         error:&error]) {
    // Report any error we got.
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[NSLocalizedDescriptionKey] =
      @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    error =
      [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    // Replace this with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You
    // should not use this function in a shipping application, although it may
    // be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }

  return _persistentStoreCoordinator;
}

- (NSManagedObjectContext*)managedObjectContext
{
  // Returns the managed object context for the application (which is already
  // bound to the persistent store coordinator for the application.)
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }

  NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
  if (!coordinator) {
    return nil;
  }
  _managedObjectContext = [[NSManagedObjectContext alloc]
    initWithConcurrencyType:NSMainQueueConcurrencyType];
  [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext
{
  NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    NSError* error = nil;
    if ([managedObjectContext hasChanges] &&
        ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error
      // appropriately.
      // abort() causes the application to generate a crash log and terminate.
      // You should not use this function in a shipping application, although it
      // may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

@end
