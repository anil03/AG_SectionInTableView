//
//  ViewController.m
//  SectionsTableView
//
//  Created by Anil Gupta on 29/10/17.
//  Copyright © 2017 Anil Gupta. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray                       *arrayContact;
    NSMutableDictionary           *dictSections;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self getContactDataList];
}


/**
 //Read the plist from the resource folder

 @return non
 */

#pragma mark - Read Plist
-(void) getContactDataList{
    
    arrayContact = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"contactsdata" ofType:@"plist"]];
    
    //Initialize the Section Dict
    dictSections = [[NSMutableDictionary alloc] init];
    [self sectionedContactData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) sectionedContactData{
    
    BOOL found;
    
    // Loop through the contact and create our keys
    for (NSDictionary *contact in arrayContact)
    {
        NSLog(@"contact --- %@",contact);
        NSString *c;
        
        NSString *obj = [contact objectForKey:@"name"];
        
        if (obj != NULL && obj.length > 0) {
            c = [[contact objectForKey:@"name"] substringToIndex:1];
        }
        else
        {
            c = @"#";//[[contact objectForKey:@"mobile"] substringToIndex:1];
        }
        
        
        found = NO;
        
        for (NSString *str in [dictSections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [dictSections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    
    
    // Loop again and sort the contact into their respective keys
    for (NSDictionary *contact in arrayContact)
    {
        NSString *obj = [contact objectForKey:@"name"];
        
        if (obj != NULL && obj.length > 0) {
            
            [[dictSections objectForKey:[[contact objectForKey:@"name"] substringToIndex:1]] addObject:contact];
            
        }
        else
        {
            [[dictSections objectForKey:@"#"] addObject:contact];
        }
        
        
    }
    
    // Sort each section array
    for (NSString *key in [dictSections allKeys])
    {
        [[dictSections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[dictSections allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[dictSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dictSections valueForKey:[[[dictSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[dictSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *contact = [[dictSections valueForKey:[[[dictSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [contact objectForKey:@"name"];
    cell.detailTextLabel.text = [contact objectForKey:@"mobile"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *contact = [[dictSections valueForKey:[[[dictSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    NSLog(@"User selected the contact --- %@",contact);

}



@end
