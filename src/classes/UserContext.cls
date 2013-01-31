/*
Copyright (c) 2011, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

*/
/**
 * Encapsulates details about the current user.  Loads sets of user details on demand and caches them for future use in the
 * same request lifecycle. Could potentially return a test instance while running unit tests.
 * Callers - you should use this if you need some basic info about the current user.
 *
 */
public with sharing class UserContext {
    private static UserContext INSTANCE = new UserContext();

    // User id for current context, needs to be set if this is different from the logged-in user.
    private Id contextUserId;

    private Boolean basicUserInfoFetched = false;

    private User userRecord;

    private UserContext() {
    }

    private UserContext(Id userId) {
        this.contextUserId = userId;
    }

    public static UserContext getInstance() {
        return INSTANCE;
    }

    /**
     * This method allows you to establish the context of a particular app user.
     * This can be done only by non-app (admin) users.
     */
    public static void establish(Id userId) {
        INSTANCE = new UserContext(userId);
    }

    private void loadBasicUserInfoIfNeeded() {
        if (!basicUserInfoFetched) {
            this.userRecord = [Select FirstName, LastName, Profile.Name,
                ContactId, LanguageLocaleKey, FullPhotoUrl from User where Id = :getUserId()];
            this.basicUserInfoFetched = true;
        }
    }

    public Id getUserId() {
        return this.contextUserId == null ? UserInfo.getUserId() : this.contextUserId;
    }

    public String getFirstName() {
        loadBasicUserInfoIfNeeded();
        return this.userRecord.FirstName;
    }

    public String getLastName() {
        loadBasicUserInfoIfNeeded();
        return this.userRecord.LastName;
    }

    public String getFullName() {
        loadBasicUserInfoIfNeeded();
        Boolean isCJKUser =
            this.userRecord.LanguageLocaleKey.startsWith('zh_') ||
            this.userRecord.LanguageLocaleKey.startsWith('ja_') ||
            this.userRecord.LanguageLocaleKey.startsWith('ko_')
        ;
        if (isCJKUser) {
            return (this.userRecord.LastName + ' ' + this.userRecord.FirstName);
        } else {
            return (this.userRecord.FirstName + ' ' + this.userRecord.LastName);
        }
    }

    public String getProfilePhotoURL() {
        loadBasicUserInfoIfNeeded();
        return this.userRecord.FullPhotoUrl;
    }

    @isTest
    public static void testEstablish() {
        User sysAdminUser = UserTestUtil.getTestSystemAdminUser();
        User stdUser;
        stdUser = UserTestUtil.getTestStandardUser();

        System.runAs(sysAdminUser) {
            UserContext.establish(stdUser.Id);
            System.assertEquals(stdUser.Id, UserContext.getInstance().getUserId(), 'Should have standard user context set.');
        }

    }
    
    @isTest
    public static void testGetFirstName() {
    	String firstName = UserContext.getInstance().getFirstName();
    	System.assertEquals(UserInfo.getFirstName(), firstName);
    }
    
    @isTest
    public static void testGetLastName() {
        String lastName = UserContext.getInstance().getLastName();
        System.assertEquals(UserInfo.getLastName(), lastName);
    }

}