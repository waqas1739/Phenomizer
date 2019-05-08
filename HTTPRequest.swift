//
//  HTTPRequest.swift
//  ThePhenomizer
//
//  Created by Robert Wicks on 1/7/16.
//  Copyright © 2016 SE15 UniB. All rights reserved.
//

import Foundation

let serviceUrl:String = "http://compbio.charite.de/phenomizer/phenomizer/PhenomizerServiceURI"
var localDbIsCurrent:Bool = false



class HTTPRequest: NSObject {
    var dbOldVersionHandler: () -> Void = {}
    var dbUpToDateVersionHandler: () -> Void = {}
    
    func setOldVersionHandler(oldVersionHandler: () -> Void) {
        dbOldVersionHandler = oldVersionHandler
    }
    
    func setUpToDateVersionHandler(upToDateVersionHandler: () -> Void) {
        dbUpToDateVersionHandler = upToDateVersionHandler;
    }
    
    // Send to the phenomizer's service URI
    func sendServiceRequest(params: [String: AnyObject], handler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionTask {
        return sendRequest(serviceUrl, params: params, handler: handler)
    }
    
    // Send to arbitrary url
    private func sendRequest(url: String, params: [String: AnyObject], handler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionTask {
        // Build parameter part of query with escaped characters
        let parameterString = params.stringFromHttpParameters()
        let requestURL = NSURL(string:"\(url)?\(parameterString)")!
        print("requesting from url: " + String(requestURL))
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "GET"
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler:handler)
        task.resume() //actually start the http request
        return task
    }
    
/* ****************** Diagnosis Query ****************** */
    
    func download(features: [String: String], callback: () -> Void) -> NSURLSessionTask {
        let selectedHpoIds = features.values.joinWithSeparator(",")
        let parameters = ["mobilequery": "true", "terms": selectedHpoIds]
        return sendServiceRequest(parameters, handler: loadedDiagnosisData)
    }
    
    // Send diagnosis query with the given selected features
    // On success, save diagnosis results to DiagnosisVC
    func sendDiagnosisQuery(features: [String: String]) -> NSURLSessionTask {
        let selectedHpoIds = features.values.joinWithSeparator(",")
        let parameters = ["mobilequery": "true", "terms": selectedHpoIds]
        return sendServiceRequest(parameters, handler: loadedDiagnosisData)
    }
    
    // Completion handler once diagnosis data has been retreived
    func loadedDiagnosisData(data:NSData?,response:NSURLResponse?,err:NSError?){
        if (err != nil) {
            print(err?.description)
        } else if((response as! NSHTTPURLResponse).statusCode != 200) {
            print("Error with status code: " + String((response as! NSHTTPURLResponse).statusCode))
        } else {
            let decoded = String(data: data!, encoding: NSUTF8StringEncoding)!
            print(decoded)
            var diagnosisResults = Array<Array<String>>()
            var lines = decoded.componentsSeparatedByString("\n")
            for var i=0; i<lines.count; i++ {
                let disease = lines[i]
                //not an empty line or a comment
                if (!disease.isEmpty && !disease.hasPrefix("#")) {
                    let diseaseData = disease.componentsSeparatedByString("\t")
                    diagnosisResults.append(diseaseData)
                }
            }
            //For each result:Array<String> in diagnosisResults, the format is:
            // index 0: p-value,
            // index 1: score (always set to -1 here), 
            // index 2: disease-id, 
            // index 3: disease-name, 
            // index 4: gene-symbol(s), 
            // index 5: gene-id(s)
            
            //Example data as it would be stored in diagnosisResults
//            let exampleResults = [
//                ["1.0000", "-1", "ORPHANET:93402", "SYNDACTYLY TYPE 1", "", ""],
//                ["1.0000", "-1", "OMIM:225300", "SPLIT-HAND/FOOT MALFORMATION 6", "WNT10B", "7480"],
//                ["1.0000", "-1", "OMIM:263450", "%263450 POLYDACTYLY, POSTAXIAL, TYPE A5; PAPA5", "", ""],
//            ];
            
            let fsvc = FeaturesSelectedViewController()
            fsvc.diagnosisCompleted(diagnosisResults)
        }
    }
    
/* ****************** DB Version query ****************** */
    // Send DB version query with given handler
    func sendVersionQuery(handler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionTask {
        return sendServiceRequest(["getdataversion":"true"], handler: handler)
    }
    
    // Send DB version query
    // On success, save the version to the version plist to keep track of the version we have currently
    func sendVersionQueryAndSave() -> NSURLSessionTask {
        return sendVersionQuery(saveDbVersionToPlist)
    }
    
    // Send DB version query
    // On success, compare the retrieved version to the version stored in the plist 
    // to see if the current version is up to date or not
    func sendVersionQueryAndCompare() -> NSURLSessionTask {
        return sendVersionQuery(compareDbVersionToPlist)
    }
    
    func saveDbVersionToPlist(data:NSData?,response:NSURLResponse?,err:NSError?){
        if (err != nil) {
            print(err?.description)
        } else if((response as! NSHTTPURLResponse).statusCode != 200) {
            print("Error with status code: " + String((response as! NSHTTPURLResponse).statusCode))
        } else {
            let phenomizerDbVersion = String(data: data!, encoding: NSUTF8StringEncoding)!
            let dbVersionDict: NSMutableDictionary = ["version": phenomizerDbVersion]
            dbVersionDict.writeToFile("dbVersion.plist".pathToPlist(), atomically: false)
            print("Updated device to db version: " + phenomizerDbVersion)
            localDbIsCurrent = true
        }
    }
    
    func compareDbVersionToPlist(data:NSData?,response:NSURLResponse?,err:NSError?){
        if (err != nil) {
            print(err?.description)
        } else if((response as! NSHTTPURLResponse).statusCode != 200) {
            print("Error with status code: " + String((response as! NSHTTPURLResponse).statusCode))
        } else {
            let serviceDbVersion = String(data: data!, encoding: NSUTF8StringEncoding)!
            var val = "-1" //device's default version if no version number has been saved before
            let path = "dbVersion.plist".pathToPlist()
            let fileManager = NSFileManager.defaultManager()
            if (fileManager.fileExistsAtPath(path)) {
                let save = NSDictionary(contentsOfFile: path)
                val = save?.valueForKey("version") as! String
            }
            if val != serviceDbVersion {
                dbOldVersionHandler();
                print("This device's db version is " + val + " but the service has db version " + serviceDbVersion)
            } else {
                dbUpToDateVersionHandler();
                print("This device has the same db version as the service, which is: " + val)
            }
            localDbIsCurrent = val == serviceDbVersion
        }
    }
}