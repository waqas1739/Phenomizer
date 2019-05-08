//
//  DiseasesViewController.m
//  ThePhenomizer
//
//  Created by SE15 UniB on 01/12/15.
//  Copyright © 2015 SE15 UniB. All rights reserved.
//

#import "DiseasesViewController.h"
#import "FeaturesSelectedViewController.h"
#import "FeaturesViewController.h"
#import "DiseaseFeaturesViewController.h"

@interface DiseasesViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (nonatomic, assign) bool isFiltered;
@end

@implementation DiseasesViewController

@synthesize diseases, diseaseValues, selectedFeatures, selectedFeatureKeys, selectedDiseaseId, numOfSelectedFeaturesLabel, numOfSelectedFeatures;
@synthesize filteredTableData;
@synthesize searchBar;
@synthesize isFiltered;


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isFiltered) {
        return [filteredTableData count];
    } else {
        return [diseaseValues count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"diseaseCell"];
    }
    
    // disable highlighting cell on selection
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *currentData;
    if(isFiltered) {
        currentData = [filteredTableData objectAtIndex:indexPath.row];
    } else {
        currentData = [diseaseValues objectAtIndex:indexPath.row];
    }
    
    [[cell textLabel] setText:currentData];
    
    NSString *detailData = [[diseases allKeysForObject:currentData] objectAtIndex:0];
    [[cell detailTextLabel] setText:detailData];
    
    return cell;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [searchBar resignFirstResponder];
    }
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
        
        for (NSString* featureName in diseaseValues)
        {
            NSRange nameRange = [featureName rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [filteredTableData addObject:featureName];
            }
        }
    }
    
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selection made");
    @try {
        NSString *selectedDisease;
        if(isFiltered) {
            selectedDisease = [filteredTableData objectAtIndex:[indexPath row]];
        } else {
            selectedDisease = [diseaseValues objectAtIndex:[indexPath row]];
        }
        selectedDiseaseId = [[diseases allKeysForObject:selectedDisease] objectAtIndex:0];
        
        [self performSegueWithIdentifier:@"diseaseFeaturesSegue" sender:self];
    } @catch (NSException *e) {
        NSLog(@"Exception caught");
        NSLog(@"Reason: %@", e.reason);
        NSLog(@"Description: %@", e.description);
        NSLog(@"Debug Description: %@", e.debugDescription);
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // load plist file to fill dictionary
    NSString *fileName = @"diseasesPFile.plist";
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
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
    diseases = plistDict;
    // storing sorted keys in dictKeys
    diseaseValues = [[diseases allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]; // to get sorted keys
    
    NSLog(@"disease screen numOfSelectedFeatures: %d", numOfSelectedFeatures);
    NSArray *viewControllers = [self.tabBarController viewControllers];
    FeaturesViewController *featuresVC = (FeaturesViewController *)viewControllers[0];
    self.selectedFeatureKeys = featuresVC.selectedFeatureKeys;
    self.selectedFeatures = featuresVC.selectedFeatures;
    
    self.numOfSelectedFeatures = [selectedFeatureKeys count];
    numOfSelectedFeaturesLabel.text = [@"Features: " stringByAppendingString:[NSString stringWithFormat:@"%d", numOfSelectedFeatures]];
    
    searchBar.delegate = (id)self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"diseaseFeaturesSegue"]) {
        NSLog(@"disease selected");
        DiseaseFeaturesViewController *selectedDiseaseFeaturesVC;
        selectedDiseaseFeaturesVC = [segue destinationViewController];
        NSLog(@"selected disease id: %@", selectedDiseaseId);
        selectedDiseaseFeaturesVC.selectedDiseaseId = selectedDiseaseId;
        selectedDiseaseFeaturesVC.selectedFeatures = selectedFeatures;
        selectedDiseaseFeaturesVC.selectedFeatureKeys = selectedFeatureKeys;
        selectedDiseaseFeaturesVC.numOfSelectedFeatures = numOfSelectedFeatures;
    } else {
        FeaturesSelectedViewController *selectedFeaturesVC;
        selectedFeaturesVC = [segue destinationViewController];
        selectedFeaturesVC.selectedFeatures = selectedFeatures;
        selectedFeaturesVC.selectedFeatureKeys = selectedFeatureKeys;
    }
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (selectedFeatureKeys == nil) {
        self.numOfSelectedFeatures = 0;
    } else {
        self.numOfSelectedFeatures = [selectedFeatureKeys count];
    }

    self.numOfSelectedFeaturesLabel.text = [@"Features: " stringByAppendingString:[NSString stringWithFormat:@"%d", numOfSelectedFeatures]];
}

@end
