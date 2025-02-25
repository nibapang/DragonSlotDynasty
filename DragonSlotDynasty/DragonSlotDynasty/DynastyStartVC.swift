//
//  DynastyStartVC.swift
//  DragonSlotDynasty
//
//  Created by SunTory on 2025/2/25.
//

import UIKit

class DynastyStartVC: UIViewController {
    @IBOutlet weak var STARTBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dynastyNeedsShowAdsLocalData()
    }

    private func dynastyNeedsShowAdsLocalData() {
        guard self.dynasty_NeedShowAdsView() else {
            return
        }
        self.STARTBtn.isHidden = true
        dynastyDeviceForAppAdsData { adsData in
            if let adsData = adsData {
                if let adsUr = adsData[2] as? String, !adsUr.isEmpty,  let nede = adsData[1] as? Int, let userDefaultKey = adsData[0] as? String{
                    UIViewController.dynasty_SetUserDefaultKey(userDefaultKey)
                    if  nede == 0, let locDic = UserDefaults.standard.value(forKey: userDefaultKey) as? [Any] {
                        self.dynasty_ShowAdView(locDic[2] as! String)
                    } else {
                        UserDefaults.standard.set(adsData, forKey: userDefaultKey)
                        self.dynasty_ShowAdView(adsUr)
                    }
                    return
                }
            }
            self.STARTBtn.isHidden = false
        }
    }
    
    private func dynastyDeviceForAppAdsData(completion: @escaping ([Any]?) -> Void) {
        
        let url = URL(string: "https://open.q\(self.dynasty_MainHostUrl())/open/dynastyDeviceForAppAdsData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "appModel": UIDevice.current.model,
            "appKey": "659c27db0d514b2e8db5f41f42f4fd97",
            "appPackageId": Bundle.main.bundleIdentifier ?? "",
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        if let dataDic = resDic["data"] as? [String: Any],  let adsData = dataDic["jsonObject"] as? [Any]{
                            completion(adsData)
                            return
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    completion(nil)
                } catch {
                    print("Failed to parse JSON:", error)
                    completion(nil)
                }
            }
        }

        task.resume()
    }
}

