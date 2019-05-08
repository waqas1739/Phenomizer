//
//  DiseasesViewController.h
//  ThePhenomizer
//
//  Created by SE15 UniB on 01/12/15.
//  Copyright © 2015 SE15 UniB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiseasesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary *diseases;   // disease detail, disease name
@property (nonatomic, strong) NSArray *diseaseValues; // disease names
@property (nonatomic, strong) NSMutableDictionary *selectedFeatures; // selected features hpo id, selected feature names
@property (nonatomic, strong) NSMutableArray *selectedFeatureKeys;  // selected feature hpo id
@property (nonatomic, strong) NSString *selectedDiseaseId;  // format: OMIM12345

@property (weak, nonatomic) IBOutlet UILabel *numOfSelectedFeaturesLabel;
@property int numOfSelectedFeatures; // count of features selected

@end
