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
 * Service class for handling Chatter People
 */
public with sharing class ChatterUIPeopleService {
	
	public static Set<String> EDITABLE_USER_FIELDS = new Set<String> { 'Phone', 'Title', 'AboutMe', 'CompanyName', 'MobilePhone'};	
	public static final Integer PEOPLE_QUERY_SIZE = 15;
	
    /**
     * @param userId - ID of the User to update
     * @param updatedFields - Stringified JSON with key value pairs representing the fields and values to update.
     *      Valid fields for update are Title, Phone, AboutMe, CompanyName, and MobilePhone
     * @return String representing a JSON status object, where the status property will be "success" or "error"
     */
    public static String updateUserInfo(Id userId, String updatedFields) {
    	Map<String, String> updatedFieldsMap = (Map<String, String>)JSON.deserialize(updatedFields, Map<String, String>.class);

    	// sanitize the fields for update
    	Map<String, String> validFieldsMap = new Map<String, String>();

    	for (String fieldName : EDITABLE_USER_FIELDS) {
    		if (updatedFieldsMap.containsKey(fieldName)) {
    			validFieldsMap.put(fieldName, updatedFieldsMap.get(fieldName));
    		}
    	}

        if (validFieldsMap.size() == 0) {
            // return success status when there's nothing to update
            return ChatterUIController.getStringifiedStatus('success', '');
        }

		// get the User object
		User thisUser = getUserWithEditableFields(userId);
		if (thisUser == null) {
			return ChatterUIController.getStringifiedStatus('error', 'Invalid user.');
		}
		
		// only update the valid user fields
		for (String fieldName : validFieldsMap.keySet()) {
		    thisUser.put(fieldName, validFieldsMap.get(fieldName));
		}

        UserContext usrContext = UserContext.getInstance();
		final String userUpdateResponse = updateSObject(thisUser);
		final Map<String, String> responseDict = (Map<String, String>)JSON.deserialize(userUpdateResponse, Map<String,String>.class);
		
		return userUpdateResponse;
    }

    /**
     * @param userId - ID of the User to select
     * @return User object with fields that can be updated through the Chatter UI, namely Phone, Title, and AboutMe
     */
    public static User getUserWithEditableFields(Id userId) {
        if (userId != null) {
            return [select Phone, MobilePhone, CompanyName, Title, AboutMe from User where Id = :userId Limit 1];
        }
        return null;
    }

    /**
     * @param theSObject - the SObject to update
     * @return String representing a JSON status with the result of the update
     */
    public static String updateSObject(SObject theSObject) {
        if (theSObject != null) {
            try {
                Database.SaveResult result = Database.update(theSObject);

                if (result.isSuccess()) {
                     return ChatterUIController.getStringifiedStatus('success', '');

                } else {
                     // there should be an error, get the first one
                     String errorMessage = result.getErrors().get(0).getMessage();
                     return ChatterUIController.getStringifiedStatus('error', errorMessage);
                }
            } catch (Exception e) {
                return ChatterUIController.getStringifiedError(e);
            }
        }
        return ChatterUIController.getStringifiedStatus('error', 'SObject for update is null.');
    }
    
    /**
     * Searches for users whose name contains searchText. Search Text must
     * contain at least 2 characters for results to be returned.
     *
     * @param searchText - The users name to search for.
     * @param pageNumber - The page number to return.
     * @return List<User> - a List of user results
     */
    public static List<User> searchUsersByName(String searchText) {
        //ignore searches with less than 2 characters
        if(searchText == null || searchText.length() < 2 ) {
            return new List<User>();
        }

        String likeClause = EncodingUtil.urlDecode(searchText, 'UTF-8') +'%';
        
        return [SELECT Id, Name, SmallPhotoUrl, FullPhotoUrl, FirstName, LastName, Profile.UserType
					FROM User
					WHERE (Name LIKE :likeClause
					OR LastName LIKE :likeClause)
					AND IsActive = true
					AND Profile.UserType = 'Standard'
					ORDER BY Name
					LIMIT :PEOPLE_QUERY_SIZE];
    }
}