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
@IsTest
public with sharing class UserTestUtil {
	private static final String STD_USER_PROFILE_NAME = 'Standard User';
    public static User getTestStandardUser() {
        return  getTestStandardUsers(1)[0];
    }

    public static User[] getTestStandardUsers(Integer numUsers) {
        Profile p = [select id
                     from profile
                     where name = :STD_USER_PROFILE_NAME
                     limit 1];
        List<User> users = new List<User>();
        for (Integer i = 0; i < numUsers; i ++) {
            String usernamePrefix = StringUtil.generateRandomString(15) + i;
            String testemail = 'testy' + i + '@testy.salesforce.com';
            User usr = new User(ProfileId = p.id, username = usernamePrefix + testemail, email = testemail, 
                               emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                               languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                               alias='cspu', lastname='lastname');
            users.add(usr);
        }
        insert users;
        return users;
    }
    
    public static User getTestSystemAdminUser() {
        // It's fair to assume that there is at least one sys admin user in an org as this is enforced for all Salesforce org.
        return [Select Id, ProfileId, Username, Profile.Name from User where Profile.Name = 'System Administrator' and IsActive = true limit 1];
    }

}