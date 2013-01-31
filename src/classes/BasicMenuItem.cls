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
 * Holder class for menu item.
 */
public with sharing class BasicMenuItem {

    transient public String url { get; private set; }
    transient public String label { get; private set; }
    transient public String cssClass { get; private set; }
    transient public Boolean isActionable { get; private set; }

    public BasicMenuItem(String url, String label, String cssClass, Boolean isActionable) {
        this.url = url;
        this.label = label;
        this.cssClass = cssClass;
        this.isActionable = isActionable;
    }

    @isTest
    private static void testValidConstructor() {
        BasicMenuItem bmi = new BasicMenuItem('a', 'a', 'a', true);
        System.assert(bmi.url != null, 'url field should not be null');
        System.assert(bmi.label != null, 'label field should not be null');
        System.assert(bmi.cssClass != null, 'cssClass field should not be null');
        System.assert(bmi.isActionable != null, 'isActionable field should not be null');
    }

}