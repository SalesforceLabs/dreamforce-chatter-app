ChatterUI.namespace('ChatterUI.FileManager');
ChatterUI.FileManager = (function($) {

    var templates = ChatterUI.Templates,
        mobileUploadInfo = {
            base64ImageData: null, // the photo that was taken
            photoTitle: null
        },
        submitAfterUploadInfo = {},
        imageReloadTimers = {},
        TEN_MINUTES_IN_MILLIS = 1*60000*10,
        TYPE_FILE = 'file',
        TYPE_PHOTO = 'photo',
        FILE_INPUT_ENABLED,
        UPLOADING_CLASS = 'fileUploading',
        ACCEPTABLE_IMAGE_TYPES = [ 'png', 'jpg', 'jpeg', 'gif' ],
        ACCEPTABLE_IMAGE_TYPES_STR = ACCEPTABLE_IMAGE_TYPES.toString(),
        ACCEPTABLE_IMAGE_TYPES_FOR_DISPLAY = ACCEPTABLE_IMAGE_TYPES.join(', '),
        FILE_EXT_TO_TYPE = {
            "aac": "audio",
            "ai": "ai",
            "asf": "video",
            "avi": "video",
            "bmp": "image",
            "css": "unknown",
            "csv": "csv",
            "dwg": "image",
            "eps": "eps",
            "xls": "excel",
            "xlsm": "excel",
            "xlsx": "excel",
            "exe": "exe",
            "swf": "flash",
            "gif": "image",
            "gdoc": "gdoc",
            "gpres": "gpres",
            "gsheet": "gsheet",
            "htm": "html",
            "html": "html",
            "jar": "zip",
            "jpeg": "image",
            "jpg": "image",
            "js": "unknown",
            "link": "link",
            "m4a": "mp4",
            "m4v": "mp4",
            "mov": "video",
            "mp3": "audio",
            "mp4": "mp4",
            "mpeg": "video",
            "mpg": "video",
            "opx": "unknown",
            "pack": "pack",
            "pdf": "pdf",
            "png": "image",
            "ppt": "ppt",
            "pptm": "ppt",
            "potx": "ppt",
            "pptx": "ppt",
            "pps": "ppt",
            "ppsx": "ppt",
            "psd": "psd",
            "mht": "unknown",
            "rtf": "rtf",
            "slide": "ppt",
            "txt": "txt",
            "thtml": "html",
            "tif": "image",
            "trtf": "rtf",
            "txml": "xml",
            "unknown": "unknown",
            "vsd": "visio",
            "wav": "audio",
            "htt": "html",
            "wmv": "video",
            "doc": "word",
            "docm": "word",
            "dotx": "word",
            "docx": "word",
            "wrf": "webex",
            "xjs": "unknown",
            "xml": "xml",
            "xpsd": "psd",
            "xzip": "zip",
            "zip": "zip"
        },
        FILE_MIME_TYPE_TO_TYPE = {
            "application/html": "html",
            "application/java-archive": "zip",
            "application/msword": "word",
            "application/octet-stream": "exe",
            "application/octet-stream": "webex",
            "application/opx": "unknown",
            "application/pdf": "pdf",
            "application/postscript": "ai",
            "application/postscript": "eps",
            "application/rtf": "rtf",
            "application/vnd.ms-excel.sheet.macroEnabled.12": "excel",
            "application/vnd.ms-excel": "excel",
            "application/vnd.ms-powerpoint.presentation.macroEnabled.12": "ppt",
            "application/vnd.ms-powerpoint": "ppt",
            "application/vnd.ms-word.document.macroEnabled.12": "word",
            "application/vnd.openxmlformats-officedocument.presentationml.presentation": "ppt",
            "application/vnd.openxmlformats-officedocument.presentationml.slideshow": "ppt",
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": "excel",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document": "word",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.template": "word",
            "application/vnd.visio": "visio",
            "application/x-javascript": "unknown",
            "application/x-shockwave-flash": "flash",
            "application/x-zip-compressed": "zip",
            "application/xml": "xml",
            "application/zip": "zip",
            "audio/mp4": "mp4",
            "audio/mpeg": "audio",
            "audio/x-aac": "audio",
            "audio/x-ms-wmv": "video",
            "audio/x-wav": "audio",
            "binary/file": "unknown",
            "image/bmp": "image",
            "image/gif": "image",
            "image/jpeg": "image",
            "image/png": "image",
            "image/tiff": "image",
            "image/vnd.adobe.photoshop": "psd",
            "image/vnd.dwg": "image",
            "image/x-photoshop": "psd",
            "message/rfc822": "unknown",
            "text/css":  "unknown",
            "text/csv": "csv",
            "text/html": "html",
            "text/javascript": "unknown",
            "text/plain": "txt",
            "text/rtf": "rtf",
            "text/webviewhtml": "html",
            "text/xml": "xml",
            "video/mp4": "mp4",
            "video/mpeg": "video",
            "video/quicktime": "video",
            "video/x-m4v": "mp4",
            "video/x-ms-asf": "video",
            "video/x-msvideo": "video",
            "application/vnd.openxmlformats-officedocument.presentationml.template": "ppt"
        },
        FILE_MIME_TYPE_TO_EXT = {
            "application/html": "html",
            "application/java-archive": "zip",
            "application/msword": "doc",
            "application/octet-stream": "exe",
            "application/pdf": "pdf",
            "application/postscript": "ai",
            "application/rtf": "rtf",
            "application/vnd.ms-excel.sheet.macroEnabled.12": "xls",
            "application/vnd.ms-excel": "xls",
            "application/vnd.ms-powerpoint.presentation.macroEnabled.12": "ppt",
            "application/vnd.ms-powerpoint": "ppt",
            "application/vnd.ms-word.document.macroEnabled.12": "doc",
            "application/vnd.openxmlformats-officedocument.presentationml.presentation": "ppt",
            "application/vnd.openxmlformats-officedocument.presentationml.slideshow": "ppt",
            "application/vnd.openxmlformats-officedocument.presentationml.template": "ppt",
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": "xls",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document": "doc",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.template": "doc",
            "application/vnd.visio": "vsd",
            "application/x-javascript": "js",
            "application/x-shockwave-flash": "swf",
            "application/x-zip-compressed": "zip",
            "application/xml": "xml",
            "application/zip": "zip",
            "audio/mp4": "mp4",
            "audio/mpeg": "mpeg",
            "audio/x-aac": "aac",
            "audio/x-ms-wmv": "wmv",
            "audio/x-wav": "wav",
            "image/bmp": "bmp",
            "image/gif": "gif",
            "image/jpeg": "jpeg",
            "image/png": "png",
            "image/tiff": "tiff",
            "image/vnd.adobe.photoshop": "psd",
            "image/vnd.dwg": "dwg",
            "image/x-photoshop": "psd",
            "text/css":  "css",
            "text/csv": "csv",
            "text/html": "html",
            "text/javascript": "js",
            "text/plain": "txt",
            "text/rtf": "rtf",
            "text/webviewhtml": "html",
            "text/xml": "xml",
            "video/mp4": "mp4",
            "video/mpeg": "mpeg",
            "video/quicktime": "mov",
            "video/x-m4v": "mp4",
            "video/x-ms-asf": "asf",
            "video/x-msvideo": "avi"
        };

    //// MOBILE

    /**
     * Takes a picture using the camera
     */
    function takePicture() {
        var destinationType = navigator.camera.DestinationType;     // sets the format of returned value

        // don't set height / width to avoid cropping when in landscape mode
        // and use a lower quality to control the file size
        navigator.camera.getPicture(onPhotoDataSuccess, onPhotoFail, {
            quality: 10,
            destinationType: destinationType.DATA_URL,
            correctOrientation: true
        });
    }

    /**
     * Retrieves an image from the camera's gallery
     */
    function selectPicture() {
        var pictureSource = navigator.camera.PictureSourceType;     // picture source
        var destinationType = navigator.camera.DestinationType;     // sets the format of returned value

        navigator.camera.getPicture(onPhotoSelectSuccess, onPhotoFail, {
            quality: 10,
            destinationType: destinationType.DATA_URL,
            sourceType: pictureSource.PHOTOLIBRARY
        });
    }

    function onPhotoDataSuccess(imageData) {
        setImageData(imageData, 'Photo taken on ');
    }

    function onPhotoSelectSuccess(imageData) {
        setImageData(imageData, 'Photo selected on ');
    }

    function setImageData(imageData, imageDisplayTitleWithoutDate) {
        mobileUploadInfo.base64ImageData = imageData;

        var now = new Date();
        mobileUploadInfo.photoTitle = imageDisplayTitleWithoutDate + (now.getMonth() + 1) + '/' + now.getDate() + '/' + now.getFullYear();
        setMobilePhotoTitle(mobileUploadInfo.photoTitle);
    }

    function onPhotoFail(message) {
        navigator.notification.alert('Failed because: ' + message);
        resetMobileUploadInfo();
    }

    function uploadAttachmentForMobile(callback) {
        ChatterUIController.uploadAttachment(mobileUploadInfo.base64ImageData, function (result, event) {
            callback(result, event);

        }, {escape: false});
    }

    function resetMobileUploadInfo($actionBtn) {
        mobileUploadInfo.base64ImageData = null;
        mobileUploadInfo.photoTitle = null;
        setMobilePhotoTitle('');

        if ($actionBtn) {
            $actionBtn.removeClass(UPLOADING_CLASS);
        }
    }

    function getMobilePhotoTitle() {
        return mobileUploadInfo.photoTitle;
    }

    function setMobilePhotoTitle(title) {
        if (title.length > 0) {
            title = '<div class="fileTypeIcon sprite-doctype_image_32"></div><div class="mobileTitle">' + title + '</div>';
        }

        $('div.chatter-page div.mobilePhotoTitle').html(title);
    }

    function wireMobilePhotoActions($actionsContainer) {
        var cameraSelector = 'a.camera',
            gallerySelector = 'a.gallery';

        $actionsContainer.off('click', cameraSelector).on('click', cameraSelector, function() {
            takePicture();
            return false;
        });

        $actionsContainer.off('click', gallerySelector).on('click', gallerySelector, function() {
            selectPicture();
            return false;
        });
    }

    function openLinkForMobile(link) {
        window.plugins.urlManager.handleUrl($Cloud.phonegapOnSuccess, $Cloud.phonegapOnError, {url: link});
        return false;
    }

    function openAttachmentForMobile(attachment) {
        var fileExtension = getFileExtension(attachment.title),
            fileMimeType = attachment.mimeType,
            title = attachment.title,
            downloadUrl = (attachment.downloadUrl.indexOf('http') == 0) ? attachment.downloadUrl : ChatterUI.env.baseUrl + attachment.downloadUrl, // If the address sent is an absolute route don't concatenate the domain
            authorization = 'OAuth ' + ChatterUI.UserContext.sessionId;

        if (fileExtension.length == 0) {
            // mobile requires a file extension in order to correctly open the file
            // try to get the extension by the mime type
            fileExtension = FILE_MIME_TYPE_TO_EXT[fileMimeType] || '';

            if (fileExtension.length > 0) {
                title += '.' + fileExtension;
            }
        }

        if(isFileType(fileExtension, fileMimeType, 'image')) {
            window.plugins.chWebView.openImage($Cloud.phonegapOnSuccess, $Cloud.phonegapOnError, {file: downloadUrl, name: title, mimeType: fileMimeType, authorization: authorization});
        } else {
            window.plugins.chWebView.openFile($Cloud.phonegapOnSuccess, $Cloud.phonegapOnError, {file: downloadUrl, name: title, mimeType: fileMimeType, authorization: authorization});
        }
        return false;
    }

    //// DESKTOP
    function setDesktopPhotoTitle(title, $container) {
        $container.find('div.desktopPhotoTitle').text(title);
    }

    function getFileUploadIFrameWindow() {
        var iframeEl = document.getElementById('ChatterUIFileIFrame');
        if (iframeEl) {
            return iframeEl.contentWindow;
        }
        return null;
    }

    function getFileUploadIFrameDoc() {
        var iframeEl = getFileUploadIFrameWindow();
        if (iframeEl) {
            return iframeEl.document;
        }
        return null;
    }

    function showFilePaths(fileInput, imageOnly, section) {
        var fileValue = fileInput.value;

        if (imageOnly) {
            // validate the selected file is an image
            var fileExtension = getFileExtension(fileValue).toLowerCase(),
                validImageFile = (ACCEPTABLE_IMAGE_TYPES_STR.indexOf(fileExtension) > -1);

            if (!validImageFile) {
                $Cloud.newModal({type: 'error', message: 'Please select an image file ('+ACCEPTABLE_IMAGE_TYPES_FOR_DISPLAY+').'});
                return false;
            }
        }

        var iframeDocEl = getFileUploadIFrameDoc();
        if (iframeDocEl == null) return;

        var hiddenFilePath = $(iframeDocEl).find('textarea.filePath');

        // remove fake path if present
        if (fileValue != null && fileValue.indexOf('fakepath') > -1) {
            fileValue = fileValue.substring(fileValue.indexOf('fakepath') + 9);
        }
        hiddenFilePath.val(fileValue);

        $(iframeDocEl).find('div.input-placeholder-container input').val(fileValue);

        if (imageOnly) {
            setDesktopPhotoTitle(fileValue, $('div.form-post-container.' + section + '-img-upload'));
        }
    }

    function setHandlers(successHandlerName, errorHandlerName) {
        var iframeWindowEl = getFileUploadIFrameWindow();

        // these are input hiddens in the VF form
        iframeWindowEl.successHandler.value = successHandlerName;
        iframeWindowEl.errorHandler.value = errorHandlerName;
    }

    function resetDesktopUploadInfo($actionBtn) {
        var iframeWindowEl = getFileUploadIFrameWindow(),
            iframeDocEl = getFileUploadIFrameDoc();

        if (iframeWindowEl && iframeDocEl) {
            // clear out the input hiddens
            iframeWindowEl.successHandler.value = '';
            iframeWindowEl.errorHandler.value = '';

            // clear out the file path container
            $(iframeDocEl).find('textarea.filePath').val('');
            $(iframeDocEl).find('input.inputFile').val('');

            // display the iframe in case it was hidden (after successful upload)
            // this is needed for profile and group photo upload in case the upload succeeds but the association to the user/group fails
            // in which case we want to show the user the upload form so they can choose another photo
            $(iframeDocEl).find('div.form-upload').removeClass('display-none');
        }

        submitAfterUploadInfo = {};

        if ($actionBtn) {
            $actionBtn.removeClass(UPLOADING_CLASS);

            // clear out the title for group/profile upload
            var section = $actionBtn.hasClass('create-group') ? 'group' : $actionBtn.hasClass('save-profile') ? 'profile' : '';
            if (section.length > 0) {
                setDesktopPhotoTitle('', $('div.form-post-container.' + section + '-img-upload'));
            }
        }
    }

    /**
     * Resets the upload state for mobile or desktop
     * @param $actionBtn - the button that invoked the original form action
     */
    function resetUploadInfo($actionBtn) {
        if (ChatterUI.UserContext.usingMobile) {
            resetMobileUploadInfo($actionBtn);
        } else {
            resetDesktopUploadInfo($actionBtn);
        }
    }

    function processUploadResult(uploadResult, successHandlerName, errorHandlerName) {
        if (uploadResult.status == 'success') {
            // process the result
            // using eval makes it possible for this upload page to be generic
            // and called by different components of the app
             var handlers = successHandlerName.split('.'),
                namespace = handlers[0], component = handlers[1], callback = handlers[2],
                successCallbackFn = window[namespace][component][callback];

            // call the handler
            if (successCallbackFn) {
                successCallbackFn(uploadResult.fileId);
            }

        } else if (uploadResult.status == 'error') {
            // process the error
            var handlers = errorHandlerName.split('.'),
                namespace = handlers[0], component = handlers[1], callback = handlers[2],
                errorCallbackFn = window[namespace][component][callback];
            // call the handler
            if (errorCallbackFn) {
                errorCallbackFn(ChatterUI.htmlEncode(uploadResult.message));
            }
        }
    }

    function uploadAttachment() {
        // uploadAttachment is an actionFunction in the VF page
        getFileUploadIFrameWindow().uploadAttachment();
    }

    //// SHARED
    function wirePhotoUploadContainer($container, $iframeContainer, section) {
        $container.removeClass('display-none');

        if (ChatterUI.UserContext.usingMobile) {
            // reset mobile title
            setMobilePhotoTitle('');

            wireMobilePhotoActions($container);

        } else {
            // reset the desktop photo title
            setDesktopPhotoTitle('', $iframeContainer);

            // load file upload iframe for desktop, even if it was previously loaded
            // this is to handle cases when there are timeout or network connection issues
            var photoUploadIframeEl = $iframeContainer.find('div.iframeContainer');

            // show the iframe
            photoUploadIframeEl.html($.tmpl(templates['fileUploadIframe'], {section:section, width:(ChatterUI.env.isIELt9() ? 300 : 138), height:35}));
            photoUploadIframeEl.removeClass('display-none').addClass('inline-block');
        }
    }

    function validForUpload() {
        // mobile
        if (ChatterUI.UserContext.usingMobile) {
            if (mobileUploadInfo.base64ImageData && mobileUploadInfo.base64ImageData.length > 0) {
                return true;
            }
            return false;
        }

        // desktop
        var iframeDocEl = getFileUploadIFrameDoc();
        if (iframeDocEl == null) return false;

        var hiddenFilePath = $(iframeDocEl).find('textarea.filePath');

        if (hiddenFilePath.val() != '') {
            return true;
        }
        return false;
    }

    /**
     * Handles errors after upload on desktop browser
     * @param message - the message to display
     * @param uploadType - TYPE_PHOTO or TYPE_FILE, displayed in the error message
     * @param $actionBtn - the button that invoked the upload
     */
    function handleUploadError(message, uploadType, $actionBtn) {
        resetUploadInfo($actionBtn);

        // show the error message
        $Cloud.newModal({type: 'error', message: 'Error uploading '+uploadType+': '+message});
    }

    /**
     * Handles errors after uploading user/group photo on desktop browser
     * @param message - the message to display
     */
    function handlePhotoUploadError(message) {
        var $actionBtn = submitAfterUploadInfo.actionBtn;

        handleUploadError(message, TYPE_PHOTO, $actionBtn);

        // clear it out
        submitAfterUploadInfo = {};
    }

    /**
     * Cleans up the global state of this component, used when navigating between left nav section
     */
    function resetGlobalState() {
        if (ChatterUI.UserContext.usingMobile) {
            resetMobileUploadInfo();
        } else {
            submitAfterUploadInfo = {};
        }
        clearImageReloadTimers();
    }

    function getFileExtension(fileName) {
        if (fileName.indexOf('.') == -1) {
            // no extension
            return '';
        }

        var fileNameParts = fileName.split('.'),
            fileExt = fileNameParts[fileNameParts.length-1].toLowerCase();
        return fileExt;
    }

    function getFileTypeClassName(fileExtension, mimeType) {
        var fileIcon,
            fileTypeClass;

        if (fileExtension.length > 0) {
            // get the icon based on the extension
            fileIcon = FILE_EXT_TO_TYPE[fileExtension] || '';

        } else {
            // get the icon based on the mimeType
            fileIcon = FILE_MIME_TYPE_TO_TYPE[mimeType] || '';
        }

        fileTypeClass = 'sprite-doctype_' + fileIcon + '_32';
        return fileTypeClass;
    }

    function handleValidThumbnailImage($imageEl, feedItemAttachment) {
        // add a border to the image thumbnail in case it's mostly white
        if (!$imageEl.hasClass('border-1')) {
            $imageEl.addClass('border-1');
        }

        // make the thumbnail clickable to open the large preview for files that are eligible
        var fileCanHaveLargePreview = isEligibleForLargePreview(feedItemAttachment);
        if (fileCanHaveLargePreview && !$imageEl.hasClass('large-preview')) {
            $imageEl.addClass('large-preview cursor-pointer');
        }

        if ($imageEl.hasClass('display-none')) {
            // image was reloaded and is now valid
            clearImageReloadTimer(feedItemAttachment.versionId);

            // remove generic file type icon classes that were initially set when the thumbnail preview failed
            $imageEl.removeClass('display-none');

            var $previewDiv = $imageEl.parent('.preview-image');
            $previewDiv.removeClass('fileTypeIcon');

            // remove the specific file type icon
            var previewClassesArr = $previewDiv.attr('class').split(' '),
                previewClassesLen = previewClassesArr.length;

            if (previewClassesLen > 1) {
                for (var i=0; i<previewClassesLen; i++) {
                    if (previewClassesArr[i].indexOf('sprite-doctype_') > -1) {
                        $previewDiv.removeClass(previewClassesArr[i]);
                    }
                }
            }
        }
        ChatterUI.refreshScroller();
    }

    /**
     * If the thumbnail fails to load, show the file type icon
     * If the file extension or mime type indicates it's a file try loading the image again in case it was not yet available through the API
     */
    function handleBadThumbnailImage($imageEl, feedItemAttachment) {
        var $thumbnailEl = $imageEl.parent('.preview-image'),
            fileExtension = getFileExtension(feedItemAttachment.title),
            fileMimeType = feedItemAttachment.mimeType,
            fileTypeIconClass = getFileTypeClassName(fileExtension, fileMimeType);

        $thumbnailEl.addClass('fileTypeIcon ' + fileTypeIconClass);
        $imageEl.addClass('display-none');

        if (fileCanHavePreview(fileExtension, fileMimeType)) {
            // try waiting and getting the image again
            handleThumbnailImageReload($imageEl, feedItemAttachment);
        }
    }

    function handleThumbnailImageReload($imageEl, feedItemAttachment) {
        var fileVersionId = feedItemAttachment.versionId,
            imageTimer = imageReloadTimers[fileVersionId];

        if (!imageTimer) {
            // this is the first time the image failed to load in this context, setup a new object for handling the retries
            imageTimer = {
                timeoutID: null,
                retries: 2
            };
            imageReloadTimers[fileVersionId] = imageTimer;

        } else {
            // the image has been reloaded at least once
            imageTimer.retries = (imageTimer.retries - 1);
        }

        if (imageTimer.retries > 0) {
            // image is eligible for another reload
            var timerId = window.setTimeout(function() {
                // add a timestamp to avoid browser caching
                var newImageSrc = getFilePreviewURL(feedItemAttachment) + '&' + getCurrentTimestamp();
                $imageEl.attr('src', newImageSrc);
            }, 500);
            imageTimer.timeoutID = timerId;

        } else {
            // we're done trying to reload the image, cleanup
            delete imageReloadTimers[fileVersionId];
        }
    }

    function isEligibleForLargePreview(attachment) {
        var fileExtension = getFileExtension(attachment.title),
            mimeType = attachment.mimeType;

        return isFileType(fileExtension, mimeType, 'image');
    }

    function isFileEligibleForPreview(attachment, postDate) {
        if (attachment.hasImagePreview) {
            return true;
        }

        // check if this is an image file, the image might not yet have a preview if it was just uploaded
        // this should only be done for recently posted files, and not all files
        // files should have a preview within a few minutes, so check that the post happened within the last 10 minutes
        var currentDate = new Date(),
            currentDateInMillis = currentDate.getTime(),
            postDateInMillis = postDate.getTime(),
            timeDiff = currentDateInMillis - postDateInMillis;

        if (timeDiff <= TEN_MINUTES_IN_MILLIS) {
            // file was posted within the last 10 minutes, check if the file type can have a preview
            var fileExtension = getFileExtension(attachment.title),
                mimeType = attachment.mimeType;

            return fileCanHavePreview(fileExtension, mimeType);
        }
        return false;
    }

    function fileCanHavePreview(fileExtension, mimeType) {
        return (isFileType(fileExtension, mimeType, 'image')
            || isFileType(fileExtension, mimeType, 'ppt')
            || isFileType(fileExtension, mimeType, 'word')
            || isFileType(fileExtension, mimeType, 'excel')
            || isFileType(fileExtension, mimeType, 'pdf')
            || isFileType(fileExtension, mimeType, 'rtf'));
    }

    function isFileType(fileExtension, mimeType, fileType) {
        return (FILE_EXT_TO_TYPE[fileExtension] == fileType)
            || (FILE_MIME_TYPE_TO_TYPE[mimeType] == fileType);
    }

    function isFileUploadEnabled() {
        if (ChatterUI.UserContext.usingMobile) {
            return true;
        }

        if (FILE_INPUT_ENABLED !== undefined) {
            return FILE_INPUT_ENABLED;
        }
        var fileInput = document.createElement("input");
        fileInput.setAttribute("type", "file");
        FILE_INPUT_ENABLED = !fileInput.disabled;
        return FILE_INPUT_ENABLED;
    }

    /**
     * Clear timeout information used for reloading thumbnails that initially failed
     */
    function clearImageReloadTimers() {
        for (fileVersionId in imageReloadTimers) {
            clearImageReloadTimer(fileVersionId);
        }
    }

    /**
     * Clears timeout information for a specific thumbnail
     */
    function clearImageReloadTimer(fileVersionId) {
        var imageTimerInfo = imageReloadTimers[fileVersionId],
            thisTimeoutID = imageTimerInfo.timeoutID;

        if (thisTimeoutID) {
            clearTimeout(thisTimeoutID);
        }
        delete imageReloadTimers[fileVersionId];
    }

    function getCurrentTimestamp() {
        return new Date().getTime();
    }

    function getFilePreviewURL(attachment) {
        return ChatterUI.env.baseUrl + '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB120BY90&versionId=' + attachment.versionId + '&operationContext=CHATTER';
    }

    function getLargeFilePreviewURL(attachment) {
        return ChatterUI.env.baseUrl + '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=' + attachment.versionId + '&operationContext=CHATTER';
    }

    function getFileDownloadURL(attachment) {
        return ChatterUI.env.baseUrl + '/sfc/servlet.shepherd/version/download/' + attachment.versionId + '?operationContext=CHATTER';
    }

    return {
        // shared
        TYPE_FILE                   : TYPE_FILE,
        TYPE_PHOTO                  : TYPE_PHOTO,
        UPLOADING_CLASS             : UPLOADING_CLASS,
        validForUpload              : validForUpload,
        resetUploadInfo             : resetUploadInfo,
        resetGlobalState            : resetGlobalState,
        wirePhotoUploadContainer    : wirePhotoUploadContainer,
        getFileExtension            : getFileExtension,
        getFileTypeClassName        : getFileTypeClassName,
        handleBadThumbnailImage     : handleBadThumbnailImage,
        handleValidThumbnailImage   : handleValidThumbnailImage,
        getFilePreviewURL           : getFilePreviewURL,
        getLargeFilePreviewURL      : getLargeFilePreviewURL,
        getFileDownloadURL          : getFileDownloadURL,
        isFileEligibleForPreview    : isFileEligibleForPreview,
        isEligibleForLargePreview   : isEligibleForLargePreview,

        // mobile
        uploadAttachmentForMobile   : uploadAttachmentForMobile,
        takePicture                 : takePicture,
        selectPicture               : selectPicture,
        resetMobileUploadInfo       : resetMobileUploadInfo,
        getMobilePhotoTitle         : getMobilePhotoTitle,
        wireMobilePhotoActions      : wireMobilePhotoActions,
        isFileUploadEnabled			: isFileUploadEnabled,
        openAttachmentForMobile		: openAttachmentForMobile,
        openLinkForMobile			: openLinkForMobile,

        // desktop
        showFilePaths               : showFilePaths,
        setHandlers                 : setHandlers,
        uploadAttachment            : uploadAttachment,
        resetDesktopUploadInfo      : resetDesktopUploadInfo,
        handleUploadError           : handleUploadError,
        handlePhotoUploadError      : handlePhotoUploadError,
        processUploadResult         : processUploadResult,
        getFileUploadIFrameWindow   : getFileUploadIFrameWindow,
        getFileUploadIFrameDoc      : getFileUploadIFrameDoc
    };

})(jQuery);
