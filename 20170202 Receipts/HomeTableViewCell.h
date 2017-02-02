//
//  HomeTableViewCell.h
//  20170202 Receipts
//
//  Created by Minhung Ling on 2017-02-02.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end
