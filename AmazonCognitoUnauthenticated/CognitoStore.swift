import Foundation

let CognitoStoreReceivedIdentityIdNotification: String = "CognitoStoreReceivedIdentityIdNotification"

class CognitoStore {
    let infoKey = "userInfo"
    let region: AWSRegionType = AWSRegionType.USEast1
    let poolId: String = "POOL_ID"
    let unauthArn: String = "UNAUTH_ARN"
    let authArn: String = "AUTH_ARN"
    let accountId: String = "ACCOUNT_ID"
    
    let credentialsProvider: AWSCognitoCredentialsProvider
    let client: AWSCognito
    
    init() {
        AWSLogger.defaultLogger().logLevel = AWSLogLevel.Verbose
        
        credentialsProvider = AWSCognitoCredentialsProvider.credentialsWithRegionType(region, accountId: accountId, identityPoolId: poolId, unauthRoleArn: unauthArn, authRoleArn: authArn)
    
        let configuration: AWSServiceConfiguration = AWSServiceConfiguration(region: region, credentialsProvider: credentialsProvider)
        client = AWSCognito(configuration: configuration)
    }
    
    func requestIdentity() {
        credentialsProvider.getIdentityId().continueWithBlock() { (task) -> AnyObject! in
            if var error = task.error {
                println("Could not request identity: \(error.userInfo)")
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(CognitoStoreReceivedIdentityIdNotification, object: self, userInfo: ["identityId":self.credentialsProvider.identityId])
            }
            
            return nil
        }
    }

    func saveItem(key: String, value: String) {
        var dataSet: AWSCognitoDataset = client.openOrCreateDataset(infoKey)
        dataSet.synchronize()
        dataSet.setString(value, forKey: key)
        
        dataSet.synchronize()
    }
    
    func loadInfo(callback: (tasks: Dictionary<NSObject, AnyObject>) -> Void) {
        var dataSet: AWSCognitoDataset = client.openOrCreateDataset(infoKey)
        dataSet.subscribe()
        dataSet.synchronize().continueWithBlock { (task) -> AnyObject! in
            if var error = task.error {
                println("Could not sync data \(error.userInfo)")
            } else {
                callback(tasks: dataSet.getAll())
            }
            
            return nil
        }
    }
}