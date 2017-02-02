//
//  ReceiptManager.h
//  20170202 Receipts
//
//  Created by Minhung Ling on 2017-02-02.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ReceiptManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;
+ (id)sharedManager;
- (NSManagedObjectContext *) getContext;
- (void)saveContext;

@end
