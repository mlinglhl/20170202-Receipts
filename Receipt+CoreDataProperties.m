//
//  Receipt+CoreDataProperties.m
//  20170202 Receipts
//
//  Created by Minhung Ling on 2017-02-02.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Receipt+CoreDataProperties.h"

@implementation Receipt (CoreDataProperties)

+ (NSFetchRequest<Receipt *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Receipt"];
}

@dynamic amount;
@dynamic note;
@dynamic timeStamp;
@dynamic tags;

@end
