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
/*
 *   Simple Service for Flow Management. Centralizes the logic for navigation.
 */
public with sharing class NavigationManager {

    private Map<String, List<NavigationElement__c>> flow;
    private Map<String, List<NavigationElement__c>> topNav;

    private static final String SIDEBAR_DEFAULT_FLOW = 'all';
    private static final String TOPNAV_DEFAULT_FLOW = 'all';
    public static final String TOP_NAV_TYPE = 'topnav';
    public static final String SIDE_NAV_TYPE = 'sidebar';
    
    private static NavigationManager INSTANCE; 
    
    private NavigationManager() {
    	initialize();
    }
    
    public static NavigationManager getInstance() {
    	if (INSTANCE == null) {
    		INSTANCE = new NavigationManager();
    	}
    	return INSTANCE;
    }

    /**
     * Creates an instance of Navigation Manager and initializes it.
     */
    private void initialize() {
        flow = new Map<String, List<NavigationElement__c>>();
        topNav = new Map<String, List<NavigationElement__c>>();
        List<NavigationElement__c> elements;

        List<NavigationElement__c> pages = [SELECT PageName__c, Url__c, Disabled__c, PageFilterUrl__c 
                                            from NavigationElement__c
                                            where Type__c = :SIDE_NAV_TYPE
                                            order by DisplayOrder__c];
        if (pages != null) {
            for(Integer index = 0; index < pages.size(); index++) {
                NavigationElement__c navElement = pages.get(index);
                String key = StringUtil.toEmptyStringIfNull(navElement.PageFilterUrl__c).toLowerCase();
                if (StringUtil.isEmpty(key)) {
                    key = SIDEBAR_DEFAULT_FLOW;
                }
                elements = flow.get(key);
                if (elements == null) {
                    elements = new List<NavigationElement__c>();
                }
                elements.add(navElement);
                flow.put(key, elements);
            }
        }

        pages = [
            SELECT 
                PageName__c, 
                Url__c, 
                Disabled__c, 
                DisplayOrder__c, 
                PageFilterUrl__c, 
                Sprite_XY_Resting__c, 
                Sprite_XY_Hover__c, 
                Sprite_XY_Pressed__c 
            FROM NavigationElement__c
            WHERE Type__c = :TOP_NAV_TYPE
            ORDER BY DisplayOrder__c
        ];

        if (pages != null) {
            for(Integer index = 0; index < pages.size(); index++) {
                NavigationElement__c navElement = pages.get(index);
                String key = StringUtil.toEmptyStringIfNull(navElement.PageFilterUrl__c).toLowerCase();
                if (StringUtil.isEmpty(key)) {
                    key = TOPNAV_DEFAULT_FLOW;
                }
                elements = topNav.get(key);
                if (elements == null) {
                    elements = new List<NavigationElement__c>();
                }
                elements.add(navElement);
                topNav.put(key, elements);
            }
        }
    }

    private List<NavigationElement__c> getFlow(Map<String, List<NavigationElement__c>> flowMap) {
        List<NavigationElement__c> elements;
        String page;

        PageReference pageRef = ApexPages.currentPage();
        if (pageRef != null && pageRef.getUrl() != null) {
            page = ControllerUtil.removeApexFromUrl(pageRef);
            page = ControllerUtil.removeParamsFromUrl(page);
            page = page.toLowerCase();
        }
        if (elements == null) {
            elements = flowMap.get(page);
        }

        if (elements == null) {
            elements = flowMap.get(SIDEBAR_DEFAULT_FLOW);
        }
        if (elements == null) {
            elements = new List<NavigationElement__c>();
        }
        return elements;
    }

    /**
     * Returns the entire flow for the currently logged in attendee type.
     * @return a list of NavigationElement__c objects representing the entire flow.
     * it is never null or empty.
     */
    public List<NavigationElement__c> getFlow() {
        return getFlow(flow);
    }

    /**
     * Returns the top navigation elements.
     * @return a list of NavigationElement__c objects representing the top navigation elements.
     */
    public List<NavigationElement__c> getTopNav() {
        return getFlow(topNav);
    }

    /**
     * Returns the index of the given page on the flow.
     * Index starts at 1.
     * @param Page. The name of the page to get the index for.
     * @return The index of the page in the flow starting from 1.
     */
    public Integer getPageIndex(final string page) {
        List<NavigationElement__c> elements = getFlow();
        List<String> urls = new List<String>();
        String decodedPage = EncodingUtil.urlDecode(page, 'UTF-8');
        for(Integer index = 0; index < elements.size(); index++) {
            String url = elements.get(index).Url__c;
            if (decodedPage.indexOf('?') > 0 && url.indexOf('?') == -1) {
                decodedPage = decodedPage.subString(0, decodedPage.indexOf('?'));
            }
            if(url.equalsIgnoreCase(decodedPage)) {
                return ++index;
            }
        }
        return -1;
    }
    
    @isTest
    private static void testGetPageIndex() {
    	NavigationElement__c sideNavElement1 = new NavigationElement__c(
    	        Name = 'all_chatter',
                PageName__c = 'All Chatter', 
                Url__c = '/apex/AllChatter', 
                Disabled__c = false, 
                DisplayOrder__c = 1, 
                PageFilterUrl__c ='Chatter',
                Type__c  = SIDE_NAV_TYPE
    	);
    	
        NavigationElement__c sideNavElement2 = new NavigationElement__c(
                Name = 'my_chatter',
                PageName__c = 'My Chatter', 
                Url__c = '/apex/MyChatter', 
                Disabled__c = false, 
                DisplayOrder__c = 2, 
                PageFilterUrl__c ='Chatter',
                Type__c  = SIDE_NAV_TYPE
        );
        
        insert new NavigationElement__c[] {sideNavElement1, sideNavElement2};

    	NavigationManager manager = NavigationManager.getInstance();
    	Test.setCurrentPage(Page.Chatter);
    	Integer pageIndex = manager.getPageIndex('/apex/AllChatter');
    	System.assertEquals(1, pageIndex);
    }
}