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
 * Controller for page template elements.
 */
public with sharing class TemplateController {

    public class NavigationItem {
        public String text {get; set;}
        public String url {get; set;}
        public Boolean accessible {get; set;}
        public Boolean current{get; set;}
        transient public String xyResting { get; set; }
        transient public String xyHover { get; set; }
        transient public String xyPressed { get; set; }

        public NavigationItem(
            String text, 
            String url, 
            Boolean accessible, 
            Boolean current, 
            String xyResting, 
            String xyHover, 
            String xyPressed 
        ) {
            this.text = text;
            this.url = url;
            this.accessible = accessible;
            this.current = current;
            this.xyResting = xyResting;
            this.xyHover = xyHover;
            this.xyPressed = xyPressed;
        }
    }

    private static final String DEFAULT_TOP_NAV_NAME = 'My Info';
    private String currentPage;
    private String currentPageWithParams;
    transient public List<NavigationItem> sidebarItems { get; private set; }

    /** The index of the current page in the flow */
    public Integer itemIndex { get; set; }


    /**
     * Constructor for portal controller.
     */
    public TemplateController() {
        PageReference pageRef = ApexPages.currentPage();
        if (pageRef != null && pageRef.getUrl() != null) {
            this.currentPageWithParams = ControllerUtil.removeApexFromUrl(pageRef);
            this.currentPage = ControllerUtil.removeParamsFromUrl(currentPageWithParams);
            this.itemIndex = NavigationManager.getInstance().getPageIndex(currentPageWithParams);
            this.sidebarItems = retrieveSidebarItems();
        }
    }

    /**
     * Retrieves the list of pages for the sidebar.
     * @return List<NavigationItem> containing page names, urls, and other attributes.
     */
    private List<NavigationItem> retrieveSidebarItems() {

        List<NavigationItem> items = new List<NavigationItem>();

        String thisPage = ControllerUtil.extractPageName(this.currentPage.toLowerCase());

        List<NavigationElement__c> pages = NavigationManager.getInstance().getFlow();
        Integer currentItem = 1;
        for(NavigationElement__c page : pages) {

            items.add(
                new NavigationItem(
                    page.PageName__c,
                    page.Url__c,
                    true,
                    (itemIndex == currentItem),
                    null,
                    null,
                    null
                )
            );
            currentItem++;
        }
        return items;
    }

    private Boolean isChatterPage() {
        return currentPage == 'Chatter';
    }

    /**
     * Simple conversion method to turn List<NavigationItem> into List<BasicMenuItem>
     * @return a list of basic menu items
     */
    public List<BasicMenuItem> getSidebarItemsAsMenu() {
        List<BasicMenuItem> bmi = new List<BasicMenuItem>();
        String cssClass;

        Integer listSize = (this != null && this.sidebarItems != null) ? this.sidebarItems.size() : 0;
        for (Integer i=0; i<listSize; i++) {
            cssClass = this.sidebarItems[i].accessible ? '' : 'linkDisabled';
            cssClass = i == listSize-1 ? cssClass + ' last' : cssClass;
            bmi.add(
                new BasicMenuItem(
                    this.sidebarItems[i].url, 
                    this.sidebarItems[i].text, 
                    cssClass, 
                    this.sidebarItems[i].accessible
                )
            );
        }

        return bmi;

    }

    public String getCurrentSidebarItemName() {
        PageReference pageRef = ApexPages.currentPage();
        String page = '';
        if (pageRef != null && pageRef.getUrl() != null) {
            page = ControllerUtil.removeApexFromUrl(pageRef);
            page = EncodingUtil.urlDecode(page, 'UTF-8');
        }
        for(NavigationElement__c item : NavigationManager.getInstance().getFlow()) {
            if (item.Url__c.equalsIgnoreCase(page)) {
               return item.PageName__c;
            }
        }
        return '';
    }

    public List<NavigationItem> getTopNavItems() {
        List<NavigationElement__c> topNav = NavigationManager.getInstance().getTopNav();
        List<NavigationItem> items = new List<NavigationItem>();
        for(NavigationElement__c item : topNav) {
            String url = ControllerUtil.removeParamsFromUrl(item.Url__c);
            items.add(
                new NavigationItem(
                        item.PageName__c,
                        item.Url__c,
                        true,
                    isCurrentItem(this.currentPage, item.Url__c),
                    item.Sprite_XY_Resting__c,
                    item.Sprite_XY_Hover__c,
                    item.Sprite_XY_Pressed__c
                )
            );
        }
        return items;
    }

    public String getCurrentTopNavItemName() {
        for(NavigationElement__c item : NavigationManager.getInstance().getTopNav()) {
            if (isCurrentItem(this.currentPage, item.Url__c)) {
               return item.PageName__c;
            }
        }

        return DEFAULT_TOP_NAV_NAME;
    }

    /**
     * compares the current page's url to the url of a primary
     * nav item (defined in the "Navigation" (NavigationElement__c)
     * custom setting) to determine if the current page is a sub-page
     * of the nav item. this method compares only the base vf page
     * name. all other pieces of info (query strings, hashes, protocols,
     * domains, etc.) are automatically stripped. 
     * 
     * @param itemURL the url of the primary nav item in the header
     * @param currentURL the url of the current page in the browser
     * @return boolean
     */
    private boolean isCurrentItem(String currentURL, String itemURL) {
        currentURL = ControllerUtil.extractPageName(currentURL.toLowerCase());
        itemURL = ControllerUtil.extractPageName(itemURL.toLowerCase());
        return (currentURL.equals(itemURL));
    }

    /**
     * Returns the items that should appear in the user menu for the currently logged in user.
     * @return List<BasicMenuItem> items
     */
    public List<BasicMenuItem> getUserMenuItems() {
        List<BasicMenuItem> items = new List<BasicMenuItem>();
        
        items.add(new BasicMenuItem('/apex/Chatter#page=profile&user=' + UserInfo.getUserId(), 'Profile', 'userMenuLink', true));
        items.add(new BasicMenuItem(ControllerUtil.getAppLogoutUrl() , 'Logout', 'userMenuLink logout', true));
        return items;
    }

    public String getUserFullName() {
        return UserInfo.getName();
    }

    public String getAvatarUrl() {
        // '/F' is the full-size photo ... get the '/T' (tiny) one instead
        return UserContext.getInstance().getProfilePhotoURL().replace('/F', '/T');
    }

    public String getAvatarCssClass() {
        // no idea why, but the avatar icon on chatter pages displays differently than others,
        // even though the exact same css is applied to it as on other pages
        return isChatterPage() ? 'userAvatar chatterPage' : 'userAvatar';
    }

    /**
     * Returns true if the user is using the Salesforce Mobile SDK with an iOS device
     */
    public Boolean getIsUsingIosPhonegap() {
        return ControllerUtil.isUsingIosPhonegap();
    }

    /**
     * Returns true if the user is using the Salesforce Mobile SDK with an Android device
     */
    public Boolean getIsUsingAndroidPhonegap() {
        return ControllerUtil.isUsingAndroidPhonegap();
    }

	/**** TEST METHODS ****/
	
	static testMethod void testGetSidebarItemsAsMenu() {
        Test.setCurrentPage(Page.Chatter);
        TemplateController controller = new TemplateController();
        
        TemplateController.NavigationItem testNavItem = new TemplateController.NavigationItem(
            'Chatter', 
            '/Chatter', 
            true, 
            true, 
            '', 
            '', 
            '' 
        ); 
        controller.sidebarItems = new TemplateController.NavigationItem[] {testNavItem};
        
        List<BasicMenuItem> basicMenuItems = controller.getSidebarItemsAsMenu();
        System.assertEquals(controller.sidebarItems.size(), basicMenuItems.size());
		
	}

    static testMethod void testGetSidebar() {
        Test.setCurrentPage(Page.Chatter);
        TemplateController controller = new TemplateController();
        List<NavigationItem> items = controller.sidebarItems;
        List<NavigationElement__c> elements = NavigationManager.getInstance().getFlow();
        System.assertEquals(elements.size(), items.size());
    }

    static testMethod void testGetAvatarCssClass() {
        Test.setCurrentPage(Page.Chatter);
        TemplateController controller = new TemplateController();
        String avatarCssClass = controller.getAvatarCssClass();
        System.assert(avatarCssClass.contains('chatterPage'));
    }
    
    static testMethod void testGetCurrentSidebarItemName() {
        Test.setCurrentPage(Page.Wrapper);
        TemplateController controller = new TemplateController();
        System.assertEquals('', controller.getCurrentSidebarItemName());
    }
    
    static testMethod void testGetUserMenuItems() {
        TemplateController controller = new TemplateController();
        List<BasicMenuItem> basicMenuItems = controller.getUserMenuItems();
        System.assert(!basicMenuItems.isEmpty());    	
    }
    
    static testMethod void testGetTopNavItems() {
        TemplateController controller = new TemplateController();
        List<NavigationItem> topItems = controller.getTopNavItems();
        
        String currentTopNavItem = controller.getCurrentTopNavItemName();
        System.assertEquals(DEFAULT_TOP_NAV_NAME, currentTopNavItem);
    }
    
    static testmethod void testIsCurrentItem() {
        TemplateController controller = new TemplateController();
        System.assert(controller.isCurrentItem('/apex/Chatter', 'CHATTER'));
    }

    static testmethod void testGetUserFullName() {
        TemplateController controller = new TemplateController();
        String userFullName = controller.getUserFullName();
        System.assertEquals(UserInfo.getName(), userFullName);
    }

    static testmethod void testGetAvatarUrl() {
        TemplateController controller = new TemplateController();
        String avatarUrl = controller.getAvatarUrl();
    	System.assert(avatarUrl.contains('/T'));
    }

}