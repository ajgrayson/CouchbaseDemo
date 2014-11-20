//
//  SyncManager.swift
//  CouchbaseDemo
//
//  Created by Johnathan Grayson on 20/11/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import Foundation

class CBLSyncManager {
    
    private var push: CBLReplication!
    private var pull: CBLReplication!
    
    private var syncError: NSError?
    
    private var serverUrl: String
    private var database: CBLDatabase!
    
    private var authenticator : CBLAuthenticatorProtocol!
    
    init(database: CBLDatabase, serverUrl: String) {
        self.database = database
        self.serverUrl = serverUrl
    }
    
    func userIsAuthenticated() -> Bool {
        return FBSession.activeSession().isOpen
    }
    
    func setupReplicationWithFacebookAuthentication() {
        var token: String = FBSession.activeSession().accessTokenData.accessToken
        
        // use it to authenticate
        
        push = database.createPushReplication(NSURL(string: serverUrl))
        pull = database.createPullReplication(NSURL(string: serverUrl))
        
        push.continuous = true
        pull.continuous = true
        
        var auth : CBLAuthenticatorProtocol = CBLAuthenticator.facebookAuthenticatorWithToken(token)
        
        push.authenticator = auth
        pull.authenticator = auth
        
        push.start()
        pull.start()
    }
    
    func handleOpenUrl(url: NSURL) -> Bool {
        return FBSession.activeSession().handleOpenURL(url);
    }
    
    func start() {
        if (userIsAuthenticated()) {
            setupReplicationWithFacebookAuthentication()
        }
    }
//
//    func beginSync() {
//        
//    }
    

    
    
}