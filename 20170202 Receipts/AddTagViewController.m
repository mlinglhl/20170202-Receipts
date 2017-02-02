//
//  AddTagViewController.m
//  20170202 Receipts
//
//  Created by Minhung Ling on 2017-02-02.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "AddTagViewController.h"
#import "ReceiptManager.h"
#import "Tag+CoreDataClass.h"

@interface AddTagViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tagTableView;
@property (weak, nonatomic) IBOutlet UITextField *addTagTextField;
@property ReceiptManager *manager;
@property NSArray <Tag*> *tagArray;

@end

@implementation AddTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tagTableView.allowsMultipleSelection = YES;
    self.manager = [ReceiptManager sharedManager];
    self.tagArray = [self getTagArray];
    // Do any additional setup after loading the view.
}

#pragma mark Add Tag Object
- (IBAction)addTagButton:(UIButton *)sender {
    NSManagedObjectContext *context = [self.manager getContext];
    Tag *newTag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
    for (Tag *tag in self.tagArray) {
        if ([tag.tagName isEqualToString: self.addTagTextField.text]) {
            return;
        }
    }
    newTag.tagName = self.addTagTextField.text;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
        return;
    }
    self.tagArray = [self getTagArray];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.tagArray indexOfObject:newTag] inSection:0];
    [self.tagTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    self.addTagTextField.text = @"";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table View Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tagArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tagTableView dequeueReusableCellWithIdentifier:@"TagCell"];
    Tag *tag = self.tagArray[indexPath.row];
    cell.textLabel.text = tag.tagName;
    return cell;
}

#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.manager getContext];
        [context deleteObject:self.tagArray[indexPath.row]];
        NSError *error = nil;
        if ([context hasChanges] && ![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
            return;
        }
        self.tagArray = [self getTagArray];
        [self.tagTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark Helper Methods

- (NSArray *) getTagArray {
    NSFetchRequest *request = [Tag fetchRequest];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"tagName" ascending:YES];
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
