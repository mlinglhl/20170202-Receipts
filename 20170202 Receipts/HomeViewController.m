//
//  HomeViewController.m
//  20170202 Receipts
//
//  Created by Minhung Ling on 2017-02-02.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "HomeViewController.h"
#import "Tag+CoreDataClass.h"
#import "Receipt+CoreDataClass.h"
#import "ReceiptManager.h"
#import "HomeTableViewCell.h"

@interface HomeViewController ()

@property (nonatomic) ReceiptManager *manager;
@property (nonatomic) NSArray <Tag*> *tagArray;
@property (nonatomic) NSMutableDictionary <NSManagedObjectID*, NSArray<Receipt*>*> *tagDictionary;
@property (weak, nonatomic) IBOutlet UITableView *sortedTagTableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [ReceiptManager sharedManager];
    NSManagedObjectContext *context = [self.manager getContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"tagName" ascending:YES];
    [request setSortDescriptors:@[sort]];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
        abort();
    }
    self.tagArray = results;
    self.tagDictionary = [NSMutableDictionary new];
    for (Tag *tag in results) {
        NSArray *receiptArray = [tag.receipts allObjects];
        [self.tagDictionary setObject:receiptArray forKey:tag.objectID];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tagArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Tag *tag = self.tagArray[section];
    return tag.receipts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [self.sortedTagTableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
    Tag *tag = self.tagArray[indexPath.section];
    NSArray <Receipt *>*receiptArray = [self.tagDictionary objectForKey:tag.objectID];
    Receipt *receipt = receiptArray[indexPath.row];
    cell.noteLabel.text = receipt.note;
    float amount = (float) receipt.amount;
    cell.amountLabel.text = @(amount/100).stringValue;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Tag *tag = self.tagArray[section];
    return tag.tagName;
}

@end
