//
//  HTTPRequest.swift
//  SuryaTest
//
//  Created by Siva on 04/12/18.
//  Copyright © 2018 Siva. All rights reserved.

import Alamofire
import SwiftyJSON

class HTTPRequests: NSObject {
    
    class func request(_ requestUrl:String, params:[String:Any]?, httpMethod:HTTPMethod, parameterEncoding:ParameterEncoding, completionHandler: @escaping (_ jsonResponse:JSON?, _ error:String?, _ responseData:Any?) -> ()) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.request(requestUrl, method: httpMethod, parameters: params, encoding: parameterEncoding, headers: nil).validate()
            .responseJSON { (response) in
                var statusCode = Int()
                if let statusCodes = response.response?.statusCode {
                    statusCode = statusCodes
                }
                print("Http Status Code: ", statusCode)
                if statusCode == 200{
                    if let jsonValue = response.result.value {
                        let jsonData = JSON(jsonValue)
                        completionHandler(jsonData, nil, jsonValue)
                    }
                }else {
                    var errorMsg = String()
                    if let data = response.data {
                        let jsonDict = Helper.convertToDictionary(message: data)
                        if let dict = jsonDict?.first {
                            errorMsg = "Error Occurred.\n\(dict.value)"
                        }
                    }
                    if errorMsg == "" {
                        errorMsg = HTTPRequests.errorMessage(statusCode)
                        
                    }
                    completionHandler(nil, errorMsg, nil)
                }
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
        }
    }
    
   
    class func errorMessage(_ statusCode:Int) -> String {
        switch statusCode {
        case 0:
            return Helper.statusCode_0
        case 404 :
            return Helper.statusCode_404
        default:
            return "Error Occured"
        }
    }
    
    class func ApiCall(params: [String:Any] ,completionHandler: @escaping (_ isSuccessFul: Bool) -> ()){
        HTTPRequests.request("http://surya-interview.appspot.com/list", params: params, httpMethod: HTTPMethod.post, parameterEncoding: JSONEncoding.default) { (json, error, responseva) in
            if error != nil {
                completionHandler(false)
                return
            }
            if let userArray = json?.dictionaryObject{
                let userObject = userArray["items"]
                
                let jsonData = try? JSONSerialization.data(withJSONObject: userObject!, options: [])
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                let helper = CoreDataHelper(persistentContainer: appDelegate.persistentContainer)
                _=helper.parse(jsonData!)
                completionHandler(true)
            }
        }

    }
    
    
}



