

#import <UIKit/UIKit.h>

@interface DiagnosisViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *selectedFeatures; // selected feature hpo id, selected features name
@property (nonatomic, strong) NSMutableArray *selectedFeatureKeys;  // selected feature hpo id
@property (nonatomic, strong) NSArray *diagnosisResults; // array of arrays

+ (void)diagnosisCompleted : (NSArray *) diagResults;

@end
