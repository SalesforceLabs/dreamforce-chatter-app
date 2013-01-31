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
 * Controller for configuring chatter app. Used right after installing the app.
 */
public with sharing class ChatterConfigController {
	
    public String feedObjectApiName {get; set;}
    public Boolean configComplete {get; private set;}
	
	public PageReference configureApp() {
		Schema.SObjectType feedObjType = null;
		if (StringUtil.isNotEmpty(feedObjectApiName)) {
            feedObjType = Schema.getGlobalDescribe().get(this.feedObjectApiName);
            if (feedObjType == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Invalid API name for the object, please re-enter.'));
                return null;
            }
		}
        
        List<NavigationElement__c> elements = new List<NavigationElement__c>();

        /**  Config for default top navigation elements. **/
        elements.add(new NavigationElement__c(
            Name = 'Home',
            PageName__c = 'Home',
            Type__c = NavigationManager.TOP_NAV_TYPE,
            Url__c = '/home/home.jsp',
            DisplayOrder__c = 1,
            Sprite_XY_Hover__c = '-31px -39px',
            Sprite_XY_Pressed__c = '-31px -39px',
            Sprite_XY_Resting__c = '1px -39px'
        ));
        
        elements.add(new NavigationElement__c(
            Name = 'Chatter',
            PageName__c = 'Chatter',
            Type__c = NavigationManager.TOP_NAV_TYPE,
            Url__c = 'Chatter#page=feeds',
            DisplayOrder__c = 2,
            Sprite_XY_Hover__c = '-32px -76px',
            Sprite_XY_Pressed__c = '-32px -76px',
            Sprite_XY_Resting__c = 'left -76px'
        ));

        /**  Config for default side navigation elements under chatter. **/
        elements.add(new NavigationElement__c(
            Name = 'my_chatter',
            PageName__c = 'My Chatter',
            Type__c = NavigationManager.SIDE_NAV_TYPE,
            Url__c = 'Chatter#page=feeds',
            DisplayOrder__c = 1,
            PageFilterUrl__c = 'Chatter'
        ));

        elements.add(new NavigationElement__c(
            Name = 'at_me',
            PageName__c = '@Me',
            Type__c = NavigationManager.SIDE_NAV_TYPE,
            Url__c = 'Chatter#page=feeds&feed=getFeedsAtMe',
            DisplayOrder__c = 2,
            PageFilterUrl__c = 'Chatter'
        ));

        elements.add(new NavigationElement__c(
            Name = 'all_chatter',
            PageName__c = 'All Chatter',
            Type__c = NavigationManager.SIDE_NAV_TYPE,
            Url__c = 'Chatter#page=feeds&feed=getAllChatterFeed',
            DisplayOrder__c = 3,
            PageFilterUrl__c = 'Chatter'
        ));

        elements.add(new NavigationElement__c(
            Name = 'groups',
            PageName__c = 'Groups',
            Type__c = NavigationManager.SIDE_NAV_TYPE,
            Url__c = 'Chatter#page=groups',
            DisplayOrder__c = 4,
            PageFilterUrl__c = 'Chatter'
        ));

        elements.add(new NavigationElement__c(
            Name = 'people',
            PageName__c = 'People',
            Type__c = NavigationManager.SIDE_NAV_TYPE,
            Url__c = 'Chatter#page=people',
            DisplayOrder__c = 5,
            PageFilterUrl__c = 'Chatter'
        ));

        elements.add(new NavigationElement__c(
            Name = 'objfeed',
            PageName__c = 'Object Feed',
            Type__c = NavigationManager.SIDE_NAV_TYPE,
            Url__c = 'Chatter#page=objfeed&feed=getMyObjectFeed',
            DisplayOrder__c = 6,
            PageFilterUrl__c = 'Chatter'
        ));

        elements.add(new NavigationElement__c(
            Name = 'files',
            PageName__c = 'Files Feed',
            Type__c = NavigationManager.SIDE_NAV_TYPE,
            Url__c = 'Chatter#page=files',
            DisplayOrder__c = 7,
            PageFilterUrl__c = 'Chatter'
        ));
        insert elements;

        if (feedObjType != null) {
        	insert new CustomChatterConfig__c(Name = 'feedObjectApiName', Value__c = this.feedObjectApiName);
        }
        this.configComplete = true;
        return null;
	}
	
    private static testMethod void testConfigureApp_validApiName() {
        ChatterConfigController controller = new ChatterConfigController();
        controller.feedObjectApiName = 'Account';
        
        controller.configureApp();
        System.assert(!ApexPages.hasMessages());
        Integer navElementCount = [Select count() from NavigationElement__c];
        System.assert(navElementCount > 0);
    }

	private static testMethod void testConfigureApp_invalidApiName() {
		ChatterConfigController controller = new ChatterConfigController();
		controller.feedObjectApiName = 'invalidObjName';
		
		controller.configureApp();
		System.assert(ApexPages.hasMessages());
	}

}