//
//  AddReceiptViewController.h
//  20170202 Receipts
//
//  Created by Minhung Ling on 2017-02-02.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Receipt;

@interface AddReceiptViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) Receipt *editReceipt;

@end
