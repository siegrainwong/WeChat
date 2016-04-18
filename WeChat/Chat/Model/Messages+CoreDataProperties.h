//
//  Messages+CoreDataProperties.h
//  
//
//  Created by Siegrain on 16/4/18.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Messages.h"

NS_ASSUME_NONNULL_BEGIN

@interface Messages (CoreDataProperties)

@property (nonatomic) float height;
@property (nullable, nonatomic, retain) NSString *message;
@property (nonatomic) int16_t messageType;
@property (nonatomic) int64_t sender;
@property (nonatomic) NSTimeInterval sendTime;
@property (nonatomic) BOOL showSendTime;

@end

NS_ASSUME_NONNULL_END
