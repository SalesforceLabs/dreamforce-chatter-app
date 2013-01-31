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
 * String-related utilities.
 */
public with sharing class StringUtil {

    private static final String DATE_FORMAT = 'MM/dd/yyyy';

    /**
     *  Generate a random string. Maximum length is 32.
     */
    public static String generateRandomString(Integer len) {
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);

        return key.substring(0,len);
    }

    public static Boolean isEmpty(String str) {
        return !isNotEmpty(str);
    }

    public static Boolean isNotEmpty(String str) {
        return (str != null && str.trim().length() > 0);
    }

    /**
     * Returns an empty String if the given String is null.
     * @return The same string or an empty one if the given is null;
     */
    public static String toEmptyStringIfNull(final String value) {
        return (value != null ? value : '' );
    }

    public static String formatDate(Date daDate, String format) {
        return DateTime.newInstance(daDate, Time.newInstance(0, 0, 0, 0)).format(format);
    }

    @IsTest static void shouldReturnAnEmptyString() {
        String foo = null;
        String result = toEmptyStringIfNull(foo);
        System.assertEquals('', result, 'Failed to return an empty String.');
    }

    @IsTest static void shouldReturnTheSameString() {
        String foo = 'Some String';
        String result = toEmptyStringIfNull(foo);
        System.assertEquals(foo, result, 'Failed to return same String.');
    }

    @IsTest static void shouldGenerateRandomString() {
        System.assert(generateRandomString(10).length() == 10);
        System.assert(generateRandomString(32).length() == 32);
        try {
            String foo = generateRandomString(33);
            System.assert(false, 'Failed to throw exception.');
        } catch (System.StringException se) {
            //Yay!
        }
    }

    @IsTest static void shouldFormatDate() {
        System.assertEquals('2012-04-01', formatDate(Date.newInstance(2012, 4, 1), 'yyyy-MM-dd'));
    }
    
    @IsTest static void testIsEmpty() {
    	System.assert(isEmpty(''));
    	System.assert(isEmpty(null));
    	System.assert(!isEmpty('Hi'));
    }
}