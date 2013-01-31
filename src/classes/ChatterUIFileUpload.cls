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
 * Handles file uploads for the Chatter UI app, both for desktop and mobile
 */
public with sharing class ChatterUIFileUpload {

    public final static String PARAM_FILE_ID = 'fileId';
    public final static String PARAM_UPLOAD_STATUS = 'status';
    public final static String PARAM_ERROR_MESSAGE = 'message';
    public final static String PARAM_ON_SUCCESS_FUNCTION = 'successFn';
    public final static String PARAM_ON_ERROR_FUNCTION = 'errorFn';
    public final static String PARAM_APP_SECTION = 'section';    
    public final static String ATTACHMENT_ORIGIN_CHATTER = 'H'; 
    public final static String APP_SECTION_GROUP = 'group';
    public final static String APP_SECTION_USER_PROFILE = 'profile';
    public final static String STATUS_SUCCESS = 'success';
    public final static String STATUS_ERROR = 'error';

    public String fileId {get; private set;}
    public String status {get; private set;}
    public String message {get; private set;}
    public String successHandler {get; set;}
    public String errorHandler {get; set;}
    public Boolean imageOnly {get; private set;}
    private String appSection;
    
    private final ApexPages.StandardController controller;
    
    // use the ContentVersion standard controller, which proves to have better error handling than if it's not used
    public ChatterUIFileUpload(ApexPages.StandardController controller) {
        this.controller = controller; 
        setChatterAttachmentInfo((ContentVersion)controller.getRecord());
        
    	this.status = ApexPages.currentPage().getParameters().get(PARAM_UPLOAD_STATUS);
        this.fileId = ApexPages.currentPage().getParameters().get(PARAM_FILE_ID);
        this.message = ApexPages.currentPage().getParameters().get(PARAM_ERROR_MESSAGE);
        this.successHandler = ApexPages.currentPage().getParameters().get(PARAM_ON_SUCCESS_FUNCTION);
        this.errorHandler = ApexPages.currentPage().getParameters().get(PARAM_ON_ERROR_FUNCTION);

        String appSectionParamValue = ApexPages.currentPage().getParameters().get(PARAM_APP_SECTION);
        if (appSectionParamValue == null) {
            this.appSection = '';
        } else if (appSectionParamValue == APP_SECTION_GROUP) {
            this.appSection = APP_SECTION_GROUP;
        } else if (appSectionParamValue == APP_SECTION_USER_PROFILE) {
            this.appSection = APP_SECTION_USER_PROFILE;
        }
        else {
            this.appSection = '';
        }

        this.imageOnly = (this.appSection != null && (this.appSection == APP_SECTION_GROUP || this.appSection == APP_SECTION_USER_PROFILE));
    }
    
    /**
     * Gets a valid section value
     */
    public String getAppSection() {
    	if (this.appSection == null) {
    		return '';
    	} else {
    		return this.appSection;
    	}
    }
    
    /**
     * Upload file from VF for desktop Chatter
     * @return PageReference to the calling page with the upload results appended as url params
     */
    public PageReference uploadAttachment() {
        Map<String, String> uploadResult = new Map<String, String>();
        resetStateFromPreviousRequest();
        
        try {
        	// call the standard controller's save
        	this.controller.save();
        	
        	if (ApexPages.hasMessages(ApexPages.Severity.ERROR) || ApexPages.hasMessages(ApexPages.Severity.FATAL)) {
                // saved failed, get the error message
                for (ApexPages.Message message : ApexPages.getMessages()) {
                	if (message.getSeverity() == ApexPages.Severity.ERROR || message.getSeverity() == ApexPages.Severity.FATAL) {
                		uploadResult.put(PARAM_UPLOAD_STATUS, STATUS_ERROR);
                        uploadResult.put(PARAM_ERROR_MESSAGE, message.getSummary());
                		break;
                	}
                }
            } else {
            	// save succeeded
            	Id contentVersionId = this.controller.getId();
	        	uploadResult.put(PARAM_UPLOAD_STATUS, STATUS_SUCCESS);
	        	uploadResult.put(PARAM_FILE_ID, getContentDocumentId(contentVersionId));
            }
        } catch (Exception e) {
        	uploadResult.put(PARAM_UPLOAD_STATUS, STATUS_ERROR);
        	uploadResult.put(PARAM_ERROR_MESSAGE, e.getMessage());
        }
        
        this.fileId = uploadResult.get(PARAM_FILE_ID);
        this.status = uploadResult.get(PARAM_UPLOAD_STATUS);
        this.message = uploadResult.get(PARAM_ERROR_MESSAGE);
        
        // salesforce does not allow rerendering within forms for file upload
        // so redirect to a new page to process the result 
        PageReference destination = ApexPages.currentPage();
        
        // force a redirect to flush the viewstate
        // redirecting fixes the scenario where the user first uploads a file that's too large, and the selects a file that's an acceptable size
        // without the redirect the user gets an error that the Version Data was required and not specified
        destination.setRedirect(true);
        
        // reset the params
        destination.getParameters().clear();
        destination.getParameters().put(PARAM_UPLOAD_STATUS, this.status);
        destination.getParameters().put(PARAM_FILE_ID, this.fileId);
        destination.getParameters().put(PARAM_ERROR_MESSAGE, this.message);
        destination.getParameters().put(PARAM_ON_SUCCESS_FUNCTION, this.successHandler);
        destination.getParameters().put(PARAM_ON_ERROR_FUNCTION, this.errorHandler);
        destination.getParameters().put(PARAM_APP_SECTION, this.appSection);
        
        return destination;
    }
    
    /**
     * Clear out params before processing an upload, to support sequential uploads
     */
    private void resetStateFromPreviousRequest() {
        this.status = null;
        this.fileId = null;
        this.message = null;
    }
    
    public Boolean getIsUploadSuccessful() {
    	return this.status == STATUS_SUCCESS;
    }
    
    /**
     * Sets information on the specified file for associating the file to Chatter
     * @param attachment - the ContentVersion file that will be uploaded
     */
    public static void setChatterAttachmentInfo(ContentVersion attachment) {
    	attachment.Origin = ATTACHMENT_ORIGIN_CHATTER;
        attachment.OwnerId = UserInfo.getUserId();
    }
    
    /**
     * Gets the ContentDocumentId associated to the ContentVersion with the specified Id
     * @param contentVersionId - Id of the ContentVersion
     * @return Id
     */
    public static Id getContentDocumentId(Id contentVersionId) {
    	if (contentVersionId != null) {
	    	List <ContentVersion> versions = [select ContentDocumentId from ContentVersion where Id = :contentVersionId];
	    	if (versions.size() > 0) {
	    		return versions[0].ContentDocumentId;
	    	}
    	}
    	return null;
    }
    
    /**
     * Upload file using the specified blob value or attachment
     * When uploading for mobile, the blob value will be specified, otherwise the attachment will be specified
     * @param base64BlobValue - String of the encoded base 64 string with the file contents
     * @param attachment - ContentVersion that was initialized by the controller, or null if it was not initialized
     * @return Map containing the results of the upload with the following keys: fileId, status, message
     */
    // note, remote actions aren't allowed in iframes and this doesn't need to be one 
    // we have the remote action in ChatterUIController call this static method 
    public static Map<String, String> uploadAttachment(String base64BlobValue, ContentVersion attachment) {
    	Map<String, String> uploadResult = new Map<String, String>();
    	
    	if (attachment == null) {
            attachment = new ContentVersion();
    	}
    	
    	try {
            setChatterAttachmentInfo(attachment);
            
            if (base64BlobValue != null) {
                // set the file data and path
                attachment.VersionData = EncodingUtil.Base64Decode(base64BlobValue);
                
                String newPhotoName = getNewPhotoName();
                attachment.PathOnClient = newPhotoName;
                // setting just the path on client does not preserve the file extension, but additionally setting the title does
                attachment.Title = newPhotoName;
            }
            
            insert attachment;      
            uploadResult.put(PARAM_FILE_ID, getContentDocumentId(attachment.Id));
            uploadResult.put(PARAM_UPLOAD_STATUS, STATUS_SUCCESS);
                    
        } catch (Exception e) {
        	uploadResult.put(PARAM_UPLOAD_STATUS, STATUS_ERROR);
        	uploadResult.put(PARAM_ERROR_MESSAGE, e.getMessage());
        
        } finally {
            // reset
            attachment = new ContentVersion();
        }
        return uploadResult;
    }
    
    /**
     * Generates a file name based on the current date and time for mobile uploads
     * @return String - the new photo name
     */
    private static String getNewPhotoName() {
        return StringUtil.formatDate(Date.today(), 'MMddyyyy') + '_' + System.currentTimeMillis() + '.jpeg'; 	
    }
    
    private static testmethod void testUploadAttachment() {
        ContentVersion contentVersion = new ContentVersion(
            ContentUrl = 'http://www.salesforce.com',
            Description = 'test attachment',
            Title = 'test'
        );
        ApexPages.StandardController sc = new ApexPages.StandardController(contentVersion);
    	ChatterUIFileUpload controller = new ChatterUIFileUpload(sc);
    	
        System.assertEquals('', controller.getAppSection()); 
    	
    	controller.appSection = APP_SECTION_GROUP;
    	System.assertEquals(APP_SECTION_GROUP, controller.getAppSection()); 
    	
        controller.appSection = APP_SECTION_USER_PROFILE;
        System.assertEquals(APP_SECTION_USER_PROFILE, controller.getAppSection()); 

        controller.uploadAttachment();
        System.assertNotEquals(null, controller.status);
        System.assertEquals(false, controller.getIsUploadSuccessful());
        
    }
    
    private static testMethod void getContentDocumentId() {
        /**
        ContentDocument contentDocument = new ContentDocument(
            Title = 'test document'
        );
        insert contentDocument;
        */
        System.assertEquals(null, getContentDocumentId(null));

        Blob b = Blob.valueOf(EncodingUtil.base64Encode(Blob.valueOf('test string')));
        ContentVersion contentVersion = new ContentVersion(
            PathOnClient = '/test.jpg',
            VersionData = b, 
            Description = 'test attachment',
            Origin = 'H',
            Title = 'test'
        );
        insert contentVersion;
        System.assertNotEquals(null, getContentDocumentId(contentVersion.Id));
    }
    
    private static testMethod void testUploadAttachment2() {
        String base64BlobValue = EncodingUtil.base64Encode(Blob.valueOf('test string'));
        Map<String, String>  resultsMap = ChatterUIFileUpload.uploadAttachment(base64BlobValue, null);
        System.assertNotEquals(null, resultsMap.get(PARAM_UPLOAD_STATUS));    	
    }
}