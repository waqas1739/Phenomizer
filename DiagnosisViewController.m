//
//  DiagnosisViewController.m
//  ThePhenomizer
//
//  Created by SE15 UniB on 06/01/16.
//  Copyright © 2016 SE15 UniB. All rights reserved.
//

#import "DiagnosisViewController.h"
#import "ThePhenomizer-Swift.h"

@interface DiagnosisViewController ()

@end

@implementation DiagnosisViewController

@synthesize selectedFeatures, selectedFeatureKeys, diagnosisResults;


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [selectedFeatureIds count];
    return [diagnosisResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"diagnosedCell"];
        
        // allowing multi line diagnosis text
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
    }
    
    // disable highlighting cell on selection
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *currentDiagnosedDisease = [diagnosisResults objectAtIndex:[indexPath row]];
    // format of currentDiagnosedDisease:
    // index 0: omim id
    // index 1: p-value
    // index 2: score - not to be used
    // index 3: disease name
    // index 4: gene-symbol - not to be used
    // index 5: gene-id - not to be used
    
    
    NSString *currentData = [currentDiagnosedDisease objectAtIndex:3];  // disease name
    [[cell textLabel] setText:currentData];
    
    NSString *diseaseId = [currentDiagnosedDisease objectAtIndex:0];   // disease id
    NSString *pValue = @"p-value: ";
    pValue = [currentDiagnosedDisease objectAtIndex:1];   // p-value
    
    NSString *detailData = [NSString stringWithFormat:@"%@\r%@", diseaseId, pValue];
    [[cell detailTextLabel] setText:detailData];
    
    return cell;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.0;
    
//    HTTPRequest *http = [[HTTPRequest alloc] init];
//    [http sendDiagnosisQuery: selectedFeatures];
    
    // TODO: get results in diagnosisResults
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//+ (void)diagnosisCompleted : (NSArray *) diagResults {
//    NSLog(@"diagnosis completed");
//}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
