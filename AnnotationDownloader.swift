//
//  AnnotationDownloader.swift
//  ThePhenomizer
//
//  Created by Robert Wicks on 12/2/15.
//  Copyright © 2015 SE15 UniB. All rights reserved.
//
// Downloads features and diseases

import UIKit

class AnnotationDownloader: NSObject, NSURLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    var downloadTask: NSURLSessionDownloadTask!
    var backgroundSession: NSURLSession!
    var spinnerCallback:(()->Void)!
    
    override init() {
        super.init()
        let backgroundSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("diseasesSession")
        backgroundSession = NSURLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        //        progressView.setProgress(0.0, animated: false)
    }
 
    func download(callback: () -> Void) {
        spinnerCallback = callback
        let url = NSURL(string: "http://compbio.charite.de/jenkins/job/hpo.annotations/lastSuccessfulBuild/artifact/misc/phenotype_annotation.tab")!
        downloadTask = backgroundSession.downloadTaskWithURL(url)
        downloadTask.resume()
    }
    
/* ********** Download delegate methods ************************************************************ */
    // Handler for download finished
    func URLSession(session: NSURLSession,
        downloadTask: NSURLSessionDownloadTask,
        didFinishDownloadingToURL location: NSURL){
            writeToPlistFromFile(location.path!)
    }
    
    // Handler for errors during download
    func URLSession(session: NSURLSession,
        task: NSURLSessionTask,
        didCompleteWithError error: NSError?){
            downloadTask = nil
            if (error != nil) {
                print(error?.description)
            }else{
                print("The task finished transferring data successfully")
            }
        backgroundSession.invalidateAndCancel()
    }
    
/* ********************************************************************************************* */
    // Write to the diseases plist using the data from the file with the given path
    func writeToPlistFromFile(path: String){
        let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
        let url = NSURL(string: rootPath)
        let plistPathInDocument = (url?.URLByAppendingPathComponent("diseasesPFile.plist").absoluteString)!
        let diseaseFeaturesPlistPathInDocument = (url?.URLByAppendingPathComponent("diseaseFeaturesPFile.plist").absoluteString)!
        // Loop over annotations file to add to plist
        var diseaseDict: NSMutableDictionary = NSMutableDictionary()
        var diseaseFeaturesDict: NSMutableDictionary = NSMutableDictionary()
        let isFileFound:Bool? = NSFileManager.defaultManager().fileExistsAtPath(path)
        if isFileFound == true {
            if let fileStream = StreamReader(path: path) {
                defer {
                    fileStream.close()
                }
                
                while let line = fileStream.nextLine() {
                    let lineElems = line.componentsSeparatedByString("\t")
                    let diseaseId:String = lineElems[0] + lineElems[1]
                    let diseaseName:String = lineElems[2]
                    let featureId:String = lineElems[4]
                    diseaseDict.setObject(diseaseName, forKey: diseaseId)
                    
                    var diseaseFeaturesArr = diseaseFeaturesDict.valueForKey(diseaseId)
                    if (diseaseFeaturesArr == nil) {
                        diseaseFeaturesArr = NSMutableArray()
                        diseaseFeaturesDict.setObject(diseaseFeaturesArr!, forKey: diseaseId)
                    }
                    diseaseFeaturesArr?.addObject(featureId)
                }
                let http = HTTPRequest()
                http.sendVersionQueryAndSave()
                diseaseDict.writeToFile(plistPathInDocument, atomically: false)
                diseaseFeaturesDict.writeToFile(diseaseFeaturesPlistPathInDocument, atomically: false)
            }
        }
        spinnerCallback()
    }
}
