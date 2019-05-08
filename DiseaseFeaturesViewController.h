//
//  DiseaseFeaturesViewController.h
//  ThePhenomizer
//
//  Created by SE15 UniB on 20/01/16.
//  Copyright © 2016 SE15 UniB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiseaseFeaturesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

// selected disease, for which the data is being displayed
@property (nonatomic, strong) NSString *selectedDiseaseId;  // format: OMIM12345

// selected features for diagnosis
@property (nonatomic, strong) NSMutableDictionary *selectedFeatures; // selected feature name, selected feature hpo id
@property (nonatomic, strong) NSMutableArray *selectedFeatureKeys;  // selected feature names

// feature hpo ids related to selected disease
@property (nonatomic, strong) NSArray *diseaseFeaturesValues;

// features data that belong to this disease
@property (nonatomic, strong) NSDictionary *features;    // feature hpo id, feature name
@property (nonatomic, strong) NSArray *featureValues;    // feature names

// table present on current screen
@property (weak, nonatomic) IBOutlet UITableView *diseaseFeaturesTableView;

//@property (weak, nonatomic) IBOutlet UIButton *addFeaturesButton;

@property (weak, nonatomic) IBOutlet UILabel *numOfSelectedFeaturesLabel;
@property int numOfSelectedFeatures; // count of features selected
@end
