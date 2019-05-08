//
//  DiseaseFeaturesViewController.m
//  ThePhenomizer
//
//  Created by SE15 UniB on 20/01/16.
//  Copyright © 2016 SE15 UniB. All rights reserved.
//

#import "DiseaseFeaturesViewController.h"
#import "DiseasesViewController.h"
#import "FeaturesSelectedViewController.h"

@interface DiseaseFeaturesViewController ()

@end

@implementation DiseaseFeaturesViewController
@synthesize selectedFeatures, selectedFeatureKeys, diseaseFeaturesTableView, selectedDiseaseId, diseaseFeaturesValues, features, featureValues, numOfSelectedFeatures, numOfSelectedFeaturesLabel;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"features selected: %d", [selectedFeatureKeys count]);
    return [diseaseFeaturesValues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    // disable highlighting cell on selection
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *currentData = [featureValues objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:currentData];
    
    NSString *detailData = [[features allKeysForObject:currentData] objectAtIndex:0];
    [[cell detailTextLabel] setText:detailData];
    
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.diseaseFeaturesTableView.dataSource = self;
    self.diseaseFeaturesTableView.delegate = self;
    
    NSLog(@"in diseaseFeatures");
    NSLog(@"selected disease id: %@", selectedDiseaseId);
    
    // load plist file to fill dictionary
    NSString *fileName = @"diseaseFeaturesPFile.plist";
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    // READ DISEASE FEATURE MAPPING, AND STORE FEATURES JUST FOR THE SELECTED DISEASE
    NSMutableDictionary *plistDict; // needs to be mutable
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];  // <disease name, <feature name, feature value>>
    } else {
        // Doesn't exist, start with an empty dictionary
        plistDict = [[NSMutableDictionary alloc] init];
    }
    
    // contains hpo ids of all the features that are associated with this disease
    diseaseFeaturesValues = [plistDict objectForKey:selectedDiseaseId];
    NSLog(@"features hpo ids array formed");
    
    
    fileName = @"featuresPFile.plist";
    filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSMutableDictionary *plistFDict; // needs to be mutable
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        plistFDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    } else {
        // Doesn't exist, start with an empty dictionary
        plistFDict = [[NSMutableDictionary alloc] init];
    }

    features = [plistFDict dictionaryWithValuesForKeys:diseaseFeaturesValues];
    featureValues = [[features allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]; // to get sorted keys
    
    if (selectedFeatureKeys == nil) {
        numOfSelectedFeatures = 0;
    } else {
        numOfSelectedFeatures = [selectedFeatureKeys count];
    }
    
    numOfSelectedFeaturesLabel.text = [@"Features: " stringByAppendingString:[NSString stringWithFormat:@"%d", numOfSelectedFeatures]];
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedFeatureName = [featureValues objectAtIndex:[indexPath row]];
    //    NSString *selectedFeatureHpoId = [features objectForKey:selectedFeatureName];
    NSString *selectedFeatureHpoId = [[features allKeysForObject:selectedFeatureName] objectAtIndex:0];
    
    if (selectedFeatures == nil || selectedFeatureKeys == nil) {
        selectedFeatures = [[NSMutableDictionary alloc] init];
        selectedFeatureKeys = [[NSMutableArray alloc] init];
        numOfSelectedFeatures = 0;
    }
    
    // feature was not already selected
    if ([selectedFeatures objectForKey:selectedFeatureName] == nil) {
        NSLog(@"adding feature to dictionary and array");
        [selectedFeatures setObject:selectedFeatureHpoId  forKey:selectedFeatureName];
        [selectedFeatureKeys addObject:selectedFeatureName];
    } else {
        // if feature was already selected, unselect it and remove from the selectedFeatures
        NSLog(@"removing feature from dictionary and array");
        [selectedFeatures removeObjectForKey:selectedFeatureName];
        [selectedFeatureKeys removeObject:selectedFeatureName];
    }
    
    numOfSelectedFeatures = [selectedFeatureKeys count];
    numOfSelectedFeaturesLabel.text = [@"Features: " stringByAppendingString:[NSString stringWithFormat:@"%d", numOfSelectedFeatures]];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *selectedFeatureName = [featureValues objectAtIndex:[indexPath row]];
    
    // if feature was not selected before, add it to the selectedFeatures
    if ([selectedFeatures objectForKey:selectedFeatureName] == nil) {
        NSLog(@"adding feature to dictionary and array");
        NSString *selectedFeatureName = [featureValues objectAtIndex:[indexPath row]];
        NSString *selectedFeatureHpoId = [[features allKeysForObject:selectedFeatureName] objectAtIndex:0];
        [selectedFeatures setObject:selectedFeatureHpoId  forKey:selectedFeatureName];
        [selectedFeatureKeys addObject:selectedFeatureName];
    } else {
        // feature was already selected, deleting it now
        // feature is deselected now. Need to remove from array and dictionary
        NSLog(@"removing feature from dictionary and array");
        [selectedFeatures removeObjectForKey:selectedFeatureName];
        [selectedFeatureKeys removeObject:selectedFeatureName];
    }
    
    numOfSelectedFeatures = [selectedFeatureKeys count];
    numOfSelectedFeaturesLabel.text = [@"Features: " stringByAppendingString:[NSString stringWithFormat:@"%d", numOfSelectedFeatures]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.

    if ([[segue identifier] isEqualToString:@"showSelectionSegue"]) {
        FeaturesSelectedViewController *selectedFeaturesVC;
        selectedFeaturesVC = [segue destinationViewController];
        selectedFeaturesVC.selectedFeatures = selectedFeatures;
        selectedFeaturesVC.selectedFeatureKeys = selectedFeatureKeys;
    } else {
        DiseasesViewController *dvc;
        dvc = [segue destinationViewController];
        dvc.selectedFeatures = selectedFeatures;
        dvc.selectedFeatureKeys = selectedFeatureKeys;
        dvc.numOfSelectedFeatures = numOfSelectedFeatures;
    }
}


@end
