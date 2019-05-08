//
//  StaticValues.h
//  ThePhenomizer
//
//  Created by SE15 UniB on 20/01/16.
//  Copyright © 2016 SE15 UniB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticValues : NSObject
+ (NSArray *) allFeatureNames;
+ (NSDictionary *) allFeatures;
+ (NSDictionary *) allDiseaseFeatures;
+ (NSArray *) allDiseaseNames;
+ (NSDictionary *) allDiseases;

+ (void) setAllFeatureNames : (NSArray *) allFeatureNames;
+ (void) setAllFeatures : (NSDictionary *) allFeatures;
+ (void) setAllDiseaseFeatures : (NSDictionary *) allDiseaseFeatures;
+ (void) setAllDiseaseNames : (NSArray *) allDiseaseNames;
+ (void) setAllDiseases : (NSDictionary *) allDiseases;

@end
