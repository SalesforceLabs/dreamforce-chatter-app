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
 * General utilities for controller layer.  Example - page ref comparison, build page ref, url redirect utility etc.
 *
 */
public with sharing class ControllerUtil {
    private static final String APEX_URL_PREFIX = '/apex/';

	public static String getAppLogoutUrl() {
       return '/secur/logout.jsp';
    }

   public static String extractPageName(String input) {
       String str = input;
       if (str.startsWith(APEX_URL_PREFIX)) {
           str = str.substring(APEX_URL_PREFIX.length());
       }

       Integer paramStartIndex = str.indexOf('?');
       if (paramStartIndex != -1) {
           str = str.substring(0, paramStartIndex);
       }

       Integer hashStartIndex = str.indexOf('#');
       if (hashStartIndex != -1) {
           str = str.substring(0, hashStartIndex);
       }
       return str;
   }

    /**
     * Returns a Page URL without /apex/ added to it
     */
    public static String removeApexFromUrl(PageReference pr) {
        return (pr.getUrl().replace(APEX_URL_PREFIX, ''));
    }

    /**
     * Returns a URL without the parameters in it.
     * It removes everything after the '?' character.
     * @return a string representing a URL without the query string.
     */
    public static String removeParamsFromUrl(String page) {
        Integer indexOfParams = page.indexOf('?');
        if (indexOfParams == -1) {
            indexOfParams = page.length();
        }
        return page.substring(0, indexOfParams);
    }

    /**
     * Returns true if the user is using the Salesforce Mobile SDK with an iOS device
     * @return true if the user is using the Salesforce Mobile SDK with an iOS device
     */
    public static Boolean isUsingIosPhonegap() {
        String userAgent = ApexPages.currentPage().getHeaders().get('User-Agent');
        if (userAgent.contains('SalesforceMobileSDK') && (userAgent.contains('iPad') || userAgent.contains('iPod') || userAgent.contains('iPhone'))) {
            return true;
        }
        else {
            return false;
        }
    }

    /**
     * Returns true if the user is using the Salesforce Mobile SDK with an Android device
     * @return true if the user is using the Salesforce Mobile SDK with an Android device
     */
    public static Boolean isUsingAndroidPhonegap() {
        String userAgent = ApexPages.currentPage().getHeaders().get('User-Agent');
        if (userAgent.contains('SalesforceMobileSDK') && userAgent.contains('android')) {
            return true;
        }
        else {
            return false;
        }
    }

    @IsTest
    public static void testRemoveApexFromUrl() {
        PageReference pr = new PageReference('/apex/pageName');
        String expectedResult1 = 'pageName';
        String expectedResult2 = '/apex/pageName';

        System.assertEquals(removeApexFromUrl(pr), expectedResult1);
        System.assertNotEquals(removeApexFromUrl(pr), expectedResult2);
    }

    @IsTest
    public static void testRemoveParamsFromUrl() {
        System.assertEquals('/apex/Landing', removeParamsFromUrl('/apex/Landing'));
        System.assertEquals('/apex/Landing', removeParamsFromUrl('/apex/Landing?test=1'));
        System.assertEquals('/apex/Landing#new', removeParamsFromUrl('/apex/Landing#new'));
        System.assertEquals('/apex/Landing', removeParamsFromUrl('/apex/Landing?test=1#new'));
    }
    
    @isTest
    public static void testGetAppLogoutUrl() {
        String logoutUrl = getAppLogoutUrl();
        System.assert(logoutUrl.contains('logout.jsp'));
    }

   @IsTest
   public static void testextractPageName() {
       System.assertEquals('Landing', extractPageName('/apex/Landing'));
       System.assertEquals('Landing', extractPageName('/apex/Landing?test=1'));
       System.assertEquals('Landing', extractPageName('/apex/Landing#new'));
       System.assertEquals('Landing', extractPageName('/apex/Landing?test=1#new'));
   }
   
   @isTest
   public static void testIsUsingIosPhonegap() {
   	   PageReference testPage = new PageReference('/apex/test');
   	   testPage.getHeaders().put('User-Agent', 'SalesforceMobileSDK - My iPhone');
       Test.setCurrentPage(testPage);
   	   System.assertEquals(true, isUsingIosPhonegap());
   }

   @isTest
   public static void testIsUsingAndroidPhonegap() {
   	   PageReference testPage = new PageReference('/apex/test');
   	   testPage.getHeaders().put('User-Agent', 'SalesforceMobileSDK - My android phone');
       Test.setCurrentPage(testPage);
   	   System.assertEquals(true, isUsingAndroidPhonegap());
   }

   @isTest
   public static void testPhonegapDetectionNegative() {
   	   PageReference testPage = new PageReference('/apex/test');
   	   testPage.getHeaders().put('User-Agent', 'My windows phone');
       Test.setCurrentPage(testPage);
   	   System.assertEquals(false, isUsingIosPhonegap());
   	   System.assertEquals(false, isUsingAndroidPhonegap());
   }

}