//
//  FeaturesSelectedViewController.m
//  ThePhenomizer
//
//  Created by SE15 UniB on 07/01/16.
//  Copyright © 2016 SE15 UniB. All rights reserved.
//

#import "FeaturesSelectedViewController.h"
#import "DiagnosisViewController.h"
#import "ThePhenomizer-Swift.h"

@interface FeaturesSelectedViewController ()

@end

@implementation FeaturesSelectedViewController
@synthesize selectedFeatures, selectedFeatureKeys, table, diagnosisResults, fakeButton, currentNVC, getDiagnosisButton;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"features selected: %d", [selectedFeatureKeys count]);
    return [selectedFeatureKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"featureCell"];
    }
    
    // disable highlighting cell on selection
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *currentData = [selectedFeatureKeys objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:currentData];
    
    NSString *detailData = [selectedFeatures objectForKey:[selectedFeatureKeys objectAtIndex:[indexPath row]]];
    [[cell detailTextLabel] setText:detailData];
    
    NSLog(@"in cell for row at index path function");
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //code here for when you hit delete
        NSString *selectedFeatureName = [selectedFeatureKeys objectAtIndex:[indexPath row]];
        [selectedFeatures removeObjectForKey:selectedFeatureName];
        [selectedFeatureKeys removeObject:selectedFeatureName];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (IBAction)addFeaturesButtonPressed:(id)sender {
    NSLog(@"button pressed");
//    [self dismissViewControllerAnimated:YES completion:nil];    // this line will work if segue is modal
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.table.dataSource = self;
    self.table.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated {
//    currentNVC = [[self navigationController] visibleViewController];
//    NSLog(@"currentNVC set");
//    
//    if (currentNVC == nil) {
//        NSLog(@"viewDidAppear: currentNVC is null");
//    } else {
//        NSLog(@"viewDidAppear: currentNVC is not null");
//    }
    
    [getDiagnosisButton setEnabled:YES];    // enable the getDiagnosis button
    
    currentNVC = [[self navigationController] visibleViewController];
    NSLog(@"currentNVC set");
    
    if (currentNVC == nil) {
        NSLog(@"viewDidAppear: currentNVC is null");
    } else {
        NSLog(@"viewDidAppear: currentNVC is not null");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getDiagnosisButtonPressed:(id)sender {
    
    // could not make it work. does not wait for response!
//    dispatch_group_t d_group = dispatch_group_create();
//    dispatch_queue_t bg_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_group_async(d_group, bg_queue, ^{
//        [self sendDiagnosisQuery];
//    });
//    
//    dispatch_group_notify(d_group, dispatch_get_main_queue(), ^{
//        NSLog(@"All background tasks are done!!");
//    });
    
    if (selectedFeatures == nil || [selectedFeatures count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Features Selected"
                                                        message:@"Please select at least one feature, and try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [getDiagnosisButton setEnabled:NO]; //disable the get diagnosis button
        [self sendDiagnosisQuery];
    }
}

- (void) sendDiagnosisQuery {
    NSLog(@"calling http");
    HTTPRequest *downloader = [[HTTPRequest alloc] init];
    
    // callback never gets called :/
    [downloader download: selectedFeatures callback: ^{
        NSLog(@"http called");
        NSLog(@"diagnosis results size: %lu", [diagnosisResults count]);
    }];
   
    
//    NSLog(@"calling http");
//    HTTPRequest *http = [[HTTPRequest alloc] init];
//    [http sendDiagnosisQuery: selectedFeatures];
//    NSLog(@"http called");
}

- (IBAction)fakeButtonPressed:(id)sender {
    NSLog(@"fake button pressed");
    [self performSegueWithIdentifier: @"getDiagnosisSegue" sender: self];
}

- (void)diagnosisCompleted : (NSArray *) diagResults {
    diagnosisResults = diagResults;
    NSLog(@"diagnosis results set");
    
    DiagnosisViewController *dvc = [[DiagnosisViewController alloc] init];
    dvc.selectedFeatures = selectedFeatures;
    dvc.selectedFeatureKeys = selectedFeatureKeys;
    dvc.diagnosisResults = diagnosisResults;
    
    if (currentNVC == nil) {
        NSLog(@"currentNVC is null");
    } else {
        NSLog(@"currentNVC is not null");
    }
    
    UIViewController *rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        NSLog(@"root vc is uiNavigationViewController");
        UINavigationController* navigationController = (UINavigationController*) rootVC;
//        [[navigationController visibleViewController] performSegueWithIdentifier:@"getDiagnosisSegue" sender:self];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"pushing diagnosis view controller");
            [navigationController pushViewController:dvc animated:YES];
            NSLog(@"diagnosis view controller pushed");
        });
        
    } else {
        NSLog(@"root vc is not uiNavigationViewController");
    }
    
//    [rootVC presentViewController:dvc animated:YES completion:nil];
    
    
//    [self presentModalViewController:myNewVC animated:YES];
    
//    NSLog(@"self: %@", self);
//    
//    if (fakeButton == nil) {
//        NSLog(@"fakeButton is null");
//    } else {
//        NSLog(@"fakeButton is not null");
//    }
//    
//    [fakeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
//    [self performSegueWithIdentifier: @"getDiagnosisSegue" sender: self];

// //    if ([UIStoryboard storyboardWithName:@"Main" bundle:nil] == nil) {
// //       NSLog(@"story board is null");
// //   } else {
// //       NSLog(@"story board is not null");
// //   }
//    
// //    DiagnosisViewController *dvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DiagnosisViewController"];

//    DiagnosisViewController *dvc = [[DiagnosisViewController alloc] init];
//    if (dvc == nil) {
//        NSLog(@"dvc is null");
//    } else {
//        NSLog(@"dvc is not null");
//    }
//    
//    dvc.selectedFeatures = selectedFeatures;
//    dvc.selectedFeatureKeys = selectedFeatureKeys;
//    dvc.diagnosisResults = diagnosisResults;
//    
//    if (self.navigationController == nil) {
//        NSLog(@"navigation controller is null");
//    } else {
//        NSLog(@"navigation controller is not null");
//    }
//    
//    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //     Get the new view controller using [segue destinationViewController].
    //     Pass the selected object to the new view controller.
    
    NSLog(@"preparing for segue");
    
//    DiagnosisViewController *dvc;
//    dvc = [segue destinationViewController];
//    dvc.selectedFeatures = selectedFeatures;
//    dvc.selectedFeatureKeys = selectedFeatureKeys;
//    dvc.diagnosisResults = diagnosisResults;
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSLog(@"identifier: %@", identifier);
//    if ([identifier isEqualToString:@"getDiagnosisSegue"]) {
//        NSLog(@"preventing segue");
//        NSLog(@"self: %@", self);
//        return NO;
//    }
    
    // if get diagnosis button pressed!
    if ([identifier isEqualToString:@"getDiagnosisSegue"]) {
        // check internet connection!
        if (![self connected]) {
            NSLog(@"no internet connection!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network Connection"
                                                            message:@"Please check your internet connection, and try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            NSLog(@"internet connection available!");
        }
        
        return NO;
    }
    
    return YES;
}



- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}



@end
