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
#import "AddReceiptViewController.h"

@interface HomeViewController ()

@property (nonatomic) ReceiptManager *manager;
@property (nonatomic) NSArray <Tag*> *tagArray;
@property (nonatomic) NSMutableDictionary <NSManagedObjectID*, NSArray<Receipt*>*> *tagDictionary;
@property (weak, nonatomic) IBOutlet UITableView *sortedTagTableView;
@property NSArray <UIColor*> *colourArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [ReceiptManager sharedManager];
    self.colourArray = @[ [UIColor redColor],
                          [UIColor blueColor],
                          [UIColor greenColor],
                          [UIColor yellowColor],
                          [UIColor cyanColor]
                          ];
}

-(void)viewDidAppear:(BOOL)animated {
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
    [self.sortedTagTableView reloadData];
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
    NSInteger colorIndex = indexPath.section;
    do {
        if (colorIndex > 4) {
            colorIndex -= 5;
        }
    } while (colorIndex > 4);
    cell.backgroundColor = self.colourArray[colorIndex];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Tag *tag = self.tagArray[section];
    if (tag.receipts.count > 0) {
        return tag.tagName;
    }
    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditReceiptViewController"]) {
        AddReceiptViewController *arvc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.sortedTagTableView indexPathForSelectedRow];
        Tag *tag = self.tagArray[indexPath.section];
        NSArray *receiptArray = [self.tagDictionary objectForKey:tag.objectID];
        arvc.editReceipt = receiptArray[indexPath.row];
    }
}

@end
