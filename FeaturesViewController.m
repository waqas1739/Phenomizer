//
//  FeaturesViewController.m
//  ThePhenomizer
//
//  Created by SE15 UniB on 01/12/15.
//  Copyright © 2015 SE15 UniB. All rights reserved.
//

#import "FeaturesViewController.h"
#import "FeaturesSelectedViewController.h"
#import "ThePhenomizer-Swift.h"
#import "StaticValues.h"

@interface FeaturesViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) bool isFiltered;
@end

@implementation FeaturesViewController

@synthesize features, featureValues, selectedFeatures, selectedFeatureKeys, numOfSelectedFeaturesLabel, numOfSelectedFeatures;
@synthesize filteredTableData;
@synthesize searchBar;
@synthesize isFiltered;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isFiltered) {
        return [filteredTableData count];
    } else {
        return [featureValues count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"featureCell"];
    }
    
    // disable highlighting cell on selection
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *currentData;
    if(isFiltered) {
        currentData = [filteredTableData objectAtIndex:indexPath.row];
    } else {
        currentData = [featureValues objectAtIndex:indexPath.row];
    }

    [[cell textLabel] setText:currentData];
    
    NSString *detailData = [[features allKeysForObject:currentData] objectAtIndex:0];
    [[cell detailTextLabel] setText:detailData];
    
    return cell;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // load all features
    // load plist file to fill dictionary
    NSString *fileName = @"featuresPFile.plist";
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSLog(@"File Path: %@", filePath);
    NSMutableDictionary *plistDict; // needs to be mutable
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    } else {
        // Doesn't exist, start with an empty dictionary
        plistDict = [[NSMutableDictionary alloc] init];
    }
    
    // loading dictionary from file
    features = plistDict;
    // storing sorted keys in dictKeys
    featureValues = [[features allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]; // to get sorted keys
    
    if (selectedFeatureKeys == nil) {
        selectedFeatures = [[NSMutableDictionary alloc] init];
        selectedFeatureKeys = [[NSMutableArray alloc] init];
        numOfSelectedFeatures = 0;
    } else {
        numOfSelectedFeatures = [selectedFeatureKeys count];
    }
    
    numOfSelectedFeaturesLabel.text = [@"Features: " stringByAppendingString:[NSString stringWithFormat:@"%d", numOfSelectedFeatures]];
    
    searchBar.delegate = (id)self;
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        filteredTableData = [[NSMutableArray alloc] init];

        for(id hpoKey in features) {
            NSString* featureName = [features objectForKey:hpoKey];
            NSRange hpoRange = [hpoKey rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange nameRange = [featureName rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || hpoRange.location != NSNotFound) {
                [filteredTableData addObject:featureName];
            }
        }
    }
    
    [self.tableView reloadData];
}

// set titles for tabs - FEATURES | DISEASES
- (void)viewWillAppear:(BOOL)animated {
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"FEATURES", @"Features List")];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"DISEASES", @"Diseases List")];
        
    if (selectedFeatureKeys == nil) {
        self.numOfSelectedFeatures = 0;
    } else {
        self.numOfSelectedFeatures = [selectedFeatureKeys count];
    }
        
    self.numOfSelectedFeaturesLabel.text = [@"Features: " stringByAppendingString:[NSString stringWithFormat:@"%d", numOfSelectedFeatures]];
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedFeatureName;
    if(isFiltered) {
        selectedFeatureName = [filteredTableData objectAtIndex:[indexPath row]];
    } else {
        selectedFeatureName = [featureValues objectAtIndex:[indexPath row]];
    }
    
    NSString *selectedFeatureHpoId = [[features allKeysForObject:selectedFeatureName] objectAtIndex:0];

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
    NSString *selectedFeatureName;
    if(isFiltered) {
        selectedFeatureName = [filteredTableData objectAtIndex:[indexPath row]];
    } else {
        selectedFeatureName = [featureValues objectAtIndex:[indexPath row]];
    }

    NSString *selectedFeatureHpoId = [[features allKeysForObject:selectedFeatureName] objectAtIndex:0];
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [searchBar resignFirstResponder];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// pass data to diagnosis view controller
// selected feature ids are passed - NSArray
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if (selectedFeatures == nil || selectedFeatureKeys == nil) {
        selectedFeatures = [[NSMutableDictionary alloc] init];
        selectedFeatureKeys = [[NSMutableArray alloc] init];
    }

    FeaturesSelectedViewController *selectedFeaturesVC;
    selectedFeaturesVC = [segue destinationViewController];
    selectedFeaturesVC.selectedFeatures = selectedFeatures;
    selectedFeaturesVC.selectedFeatureKeys = selectedFeatureKeys;
}

@end
