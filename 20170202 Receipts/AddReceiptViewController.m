//
//  AddReceiptViewController.m
//  20170202 Receipts
//
//  Created by Minhung Ling on 2017-02-02.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "AddReceiptViewController.h"
#import "ReceiptManager.h"
#import "Tag+CoreDataClass.h"
#import "Receipt+CoreDataClass.h"

@interface AddReceiptViewController ()
@property (weak, nonatomic) IBOutlet UITextField *receiptAmountTextField;
@property (weak, nonatomic) IBOutlet UITableView *tagTableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *receiptDatePicker;
@property (weak, nonatomic) IBOutlet UITextView *receiptNoteTextView;
@property (nonatomic) ReceiptManager *manager;
@property (nonatomic) NSArray *tagArray;

@end

@implementation AddReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [ReceiptManager sharedManager];
    self.tagArray = [self getArrayWithKey:@"Tag" sort:@"tagName"];
    self.tagTableView.allowsMultipleSelection = YES;
    if (self.editReceipt) {
        float amount = (float) self.editReceipt.amount;
        self.receiptAmountTextField.text = @(amount/100).stringValue;
        self.receiptNoteTextView.text = self.editReceipt.note;
        self.receiptDatePicker.date = self.editReceipt.timeStamp;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.tagArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Tags";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tagTableView dequeueReusableCellWithIdentifier:@"TagCell"];
    Tag *tag = self.tagArray[indexPath.row];
    if ([self.editReceipt.tags containsObject:tag]) {
        [self.tagTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    cell.textLabel.text = tag.tagName;
    return cell;
}

- (IBAction)saveButtonPress:(UIButton *)sender {
    NSManagedObjectContext *context = [self.manager getContext];
    Receipt *newReceipt = [NSEntityDescription insertNewObjectForEntityForName:@"Receipt" inManagedObjectContext:context];
    if (self.editReceipt) {
        newReceipt = self.editReceipt;
    }
    double amount = [self.receiptAmountTextField.text doubleValue];
    NSInteger intAmount = amount*100;
    newReceipt.amount = intAmount;
    newReceipt.note = self.receiptNoteTextView.text;
    newReceipt.timeStamp = self.receiptDatePicker.date;
    NSArray <NSIndexPath*> *tagIndexPaths = [self.tagTableView indexPathsForSelectedRows];
    NSMutableSet *tagset = [NSMutableSet new];
    for (NSIndexPath *indexPath in tagIndexPaths) {
        [tagset addObject:self.tagArray[indexPath.row]];
    }
    newReceipt.tags = [NSSet setWithSet:tagset];
    [self.manager saveContext];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *) getArrayWithKey: (NSString *) key sort: (NSString*) sortKey {
    NSFetchRequest *request = [NSClassFromString(key)
 fetchRequest];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES];
    [request setSortDescriptors:@[sort]];
    NSManagedObjectContext *context = [self.manager getContext];
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog (@"Error: %@", error.localizedDescription);
        return nil;
    }
    return results;
}
@end
