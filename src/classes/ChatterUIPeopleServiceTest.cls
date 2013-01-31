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
@isTest
public with sharing class ChatterUIPeopleServiceTest {

    static testMethod void testUpdateUserInfo() {

        Id currentUserId = UserInfo.getUserId();
        String testPhone = '111-111-1111';
        String testTitle = 'new title';
        String testAboutMe = 'new about me';
        String testFirstName = 'test first name ' + System.currentTimeMillis();
        String testCompanyName = 'testCompanName';
        String testMobilePhone = '9875654322';

        Map<String, String> fieldsToUpdate = new Map<String, String> {
            'Phone' => testPhone,
            'Title' => testTitle,
            'AboutMe' => testAboutMe,
            'FirstName' => testFirstName,
            'CompanyName' => testCompanyName,
            'MobilePhone' => testMobilePhone
        };

        String updateStatus;
        Map<String, String> updateStatusMap;

        try {
            // test valid user and editable fields
            updateStatus = ChatterUIPeopleService.updateUserInfo(currentUserId, JSON.serialize(fieldsToUpdate));
            updateStatusMap = (Map<String, String>)JSON.deserialize(updateStatus, Map<String, String>.class);
            System.assert(updateStatusMap.get('status') == 'success');
            System.assert(updateStatusMap.get('statusDesc') == '');

            // verify editable fields were updated, and others were not
            User updatedUser =  [select FirstName, Phone, Title, AboutMe, CompanyName, MobilePhone from User where Id = :currentUserId LIMIT 1];
            System.assert(updatedUser.Phone == testPhone);
            System.assert(updatedUser.Title == testTitle);
            System.assert(updatedUser.AboutMe == testAboutMe);
            System.assert(updatedUser.CompanyName == testCompanyName);
            System.assert(updatedUser.MobilePhone == testMobilePhone);
            System.assert(updatedUser.FirstName != testFirstName);

        } catch (Exception e) {
            // catch errors in case the user running the test doesn't have Update permissions on User
            System.debug('error update user in testUpdateUserInfo: '+e.getMessage());
        }

        // test no valid values specified
        fieldsToUpdate = new Map<String, String> {};

        updateStatus = ChatterUIPeopleService.updateUserInfo(currentUserId, JSON.serialize(fieldsToUpdate));
        updateStatusMap = (Map<String, String>)JSON.deserialize(updateStatus, Map<String, String>.class);
        System.assert(updateStatusMap.get('status') == 'success');

        // test invalid user
        Id nullUserId = null;
        fieldsToUpdate = new Map<String, String> {
            'AboutMe' => 'about me'
        };
        updateStatus = ChatterUIPeopleService.updateUserInfo(nullUserId, JSON.serialize(fieldsToUpdate));
        updateStatusMap = (Map<String, String>)JSON.deserialize(updateStatus, Map<String, String>.class);
        System.assert(updateStatusMap.get('status') == 'error');
        System.assert(updateStatusMap.get('statusDesc') == 'Invalid user.');
    }

    static testMethod void testGetUserWithEditableFields() {
        Id currentUserId = UserInfo.getUserId();

        User currentUser = ChatterUIPeopleService.getUserWithEditableFields(currentUserId);
        System.assert(currentUser != null);

        currentUserId = null;
        currentUser = ChatterUIPeopleService.getUserWithEditableFields(currentUserId);
        System.assert(currentUser == null);
    }

    static testMethod void testUpdateSObject() {
        // test null sobject
        User nullUser = null;
        String result = ChatterUIPeopleService.updateSObject(nullUser);

        Map<String, String> resultMap = (Map<String, String>)JSON.deserialize(result, Map<String, String>.class);
        System.assert(resultMap.get('status') == 'error');
        System.assert(resultMap.get('statusDesc') == 'SObject for update is null.');

        // test invalid sobject, this will throw an error
        User newUser = new User();
        result = ChatterUIPeopleService.updateSObject(newUser);
        resultMap = (Map<String, String>)JSON.deserialize(result, Map<String, String>.class);
        System.assert(resultMap.get('status') == 'error');
        System.assert(resultMap.get('statusDesc').length() > 0);

        // test valid sobject
        try {
            User currentUser = ChatterUIPeopleService.getUserWithEditableFields(UserInfo.getUserId());
            currentUser.title = 'test title';
            result = ChatterUIPeopleService.updateSObject(currentUser);
            resultMap = (Map<String, String>)JSON.deserialize(result, Map<String, String>.class);
            System.assert(resultMap.get('status') == 'success');

        } catch (Exception e) {
            // catch errors in case the user running the test doesn't have Update permissions on User
            System.debug('error updating user in testUpdateSObject: '+e.getMessage());
        }
    }
}