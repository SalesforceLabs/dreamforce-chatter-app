ChatterUI.namespace('ChatterUI.PostBuilder');
ChatterUI.PostBuilder = (function($) {
    var mentionedUsers = [],
        FILE_UPLOADING_CLASS = ChatterUI.FileManager.UPLOADING_CLASS;

    /**
     * wire a button to submit posts
     */
    function wireSubmit($form, handler) {
        handler = handler || 'addItem';

        // bind submit
        $form.find('input.button').off('click').on('click', function() {
            var $this = $(this),
                method = $form.attr('data-method') || 'postNewsFeedItem',
                id = $form.attr('data-param') || '';

            // if there's a file to upload, upload it first
            var startedFileUpload = initPostFileUpload($form, method, id, handler, $this);

            if (startedFileUpload == false) {
                // standard post without files
                submitPost($form, method, id, handler, $this, null);
            }
        });
    }

    /**
     * Initializes the file upload process
     * @param $form - the form with user-entered post data
     * @param method - the Service method to call
     * @param handler - the FeedItemBuilder handler invoked after post
     * @param $this - the button that invoked the post submit
     */
    function initPostFileUpload($form, method, id, handler, $this) {
        if ($this.hasClass(FILE_UPLOADING_CLASS) || ChatterUI.FileManager.validForUpload() == false) {
            // either the file is already being uploaded and we need to wait for it to finish
            // or there's no file data specified for upload
            return false;
        }

        // file data was specified, start the upload
        if (ChatterUI.UserContext.usingMobile) {
            $this.addClass(FILE_UPLOADING_CLASS);
            ChatterUI.FileManager.uploadAttachmentForMobile(function(result, event) {
                if (ChatterUI.isValidResponseEvent(result)) {
                    // upload succeeded, proceed with the post
                    var uploadedFileId = result.fileId;
                    submitPost($form, method, id, handler, $this, uploadedFileId)
                    ChatterUI.FileManager.resetMobileUploadInfo($this);

                } else {
                    // show error, reset the file data
                    ChatterUI.FileManager.handleUploadError(event.message, ChatterUI.FileManager.TYPE_FILE, $this);
                }
            });
            return true;

        } else {
            // file upload for desktop
            $this.addClass(FILE_UPLOADING_CLASS);

            // set the callback handlers
            ChatterUI.FileManager.setHandlers('ChatterUI.PostBuilder.submitPostAfterUpload', 'ChatterUI.PostBuilder.handleFileUploadError');

            // this will be used in the callback function submitPostAfterUpload
            ChatterUI.FileManager.submitAfterUploadInfo = {
                fn: submitPost,
                context: this,
                args: [$form, method, id, handler ,$this],
                actionBtn: $this
            };

            // start the upload, once done the iframe upload page will call the submit post function
            ChatterUI.FileManager.uploadAttachment();
            return true;
        }
        return false;
    }

    /**
     * Handles errors after upload on desktop browser
     * @param message - the message to display
     */
    function handleFileUploadError(message) {
        ChatterUI.FileManager.handleUploadError(message, ChatterUI.FileManager.TYPE_FILE, ChatterUI.FileManager.submitAfterUploadInfo.actionBtn);
    }

    /**
     * Handles submitting the post after the file upload completed
     * @param uploadedFileId - the id of the file that was uploaded and needs to be associated to the post
     */
    function submitPostAfterUpload(uploadedFileId) {
        var submitFn = ChatterUI.FileManager.submitAfterUploadInfo.fn,
            submitFnArgs = ChatterUI.FileManager.submitAfterUploadInfo.args,
            submitContext = ChatterUI.FileManager.submitAfterUploadInfo.context;

        submitFnArgs.push(uploadedFileId);

        // call the function to handle associating the file to the post
        submitFn.apply(submitContext, submitFnArgs);

        // reset the source
        ChatterUI.FileManager.resetDesktopUploadInfo(ChatterUI.FileManager.submitAfterUploadInfo.actionBtn);
    }

    /**
     * Submits the post form
     * @param $form - the form with user-entered post data
     * @param method - the Service method to call
     * @param handler - the FeedItemBuilder handler invoked after post
     * @param $this - the button that invoked the post submit
     * @param uploadedFileId - the id of the file that was uploaded and needs to be associated to the post
     */
    function submitPost($form, method, id, handler, $this, uploadedFileId) {
        var post = collectPostData($form, uploadedFileId),
            postJSON = post ? JSON.stringify(post) : '';

        if (postJSON) {
            if ($this.hasClass('posting')) {
                // wait for the original post to finish
                return false;
            }
            $this.addClass('posting');
            $form.find('div.long-message').remove();
            if (id) {
                ChatterUI.Service[method](id, postJSON, function(result, event) {
                    postHandler($form, handler, result, event, uploadedFileId);
                });
                if ($form.hasClass('comment-post')) {
                    blurCommentField($form);
                }
            } else {
                ChatterUI.Service[method](postJSON, function(result, event) {
                    postHandler($form, handler, result, event, uploadedFileId);
                });
            }
        }
    }

    function postHandler($form, handler, result, event, uploadedFileId) {
        if (event.status && ChatterUI.isValidResponseEvent(event)) {

            // photos are processed asynchronously and may not be visible right away, so wait a little if the post contained a file
            var delay = (uploadedFileId ? 300 : 0);

            setTimeout(function () {
                ChatterUI.FeedItemBuilder[handler](result, ChatterUI.FeedBuilder.feeds[$form.attr('data-feed-id')], true);
                $form.find('textarea').attr('value', '').css('height', 'auto').attr('rows', 1);
            }, delay);

            // hide the upload container if it's displayed
            if ($('form.form-post a.post-menu').hasClass('active')) {
                ChatterUI.FeedBuilder.hidePostActionsContainer();
            }
            ChatterUI.refreshScroller();
            var isComment = $form.hasClass('comment-post');
            ChatterUI.track('', (isComment ? 'comment' : 'post'));
        } else {
			if (event.message && event.message.toLowerCase().indexOf('you do not have permission') > -1) {
				$Cloud.newModal({type: 'error', message: 'You must belong to this group to post.'});
			} else {
				$Cloud.newModal({type: 'error', message: ChatterUI.escapeHtml(event.message)});
			}
        }

        $form.find('input.button').removeClass('posting ' + FILE_UPLOADING_CLASS);
    }

    /**
     * json-stringify all form fields
     */
    function collectPostData($form, uploadedFileId) {
        var postParts;
        $form.find('textarea').each(function(){
            postParts = parsePost($(this).val(), uploadedFileId);
            return; // only do once
        });

        if (!postParts) {
            return '';
        }

        var postData = {
            body: {
                messageSegments: postParts.messageSegments
            }
        };

        if (postParts.attachment) {
            postData.attachment = postParts.attachment;
        }
        return postData;
    }

    /**
     * find all message segments in the post
     */
    function parsePost(val, uploadedFileId) {
        var postParts,
            attachmentForPost;

        // check if there's a file to associate to the post, regardless of the post text
        if (uploadedFileId && uploadedFileId.length > 0) {
            postParts = {
                attachment: getAttachmentForPostBody(uploadedFileId),
                messageSegments: []
            };
        }

        if (!val) {
            return postParts;
        }

        // find all http:/https:, #, @
        // anything else is text
        var msg = []
            ,els = []
            ,end = 0
            ,pos = 0
            ,repl = function() {
                els.push(arguments[1]);
                return arguments[0];
            };
        val.replace(/\@\[/g, repl);

        // now sort els
        if (els.length > 0) {
            els.sort(function(a,b){return a-b;});
        }

        if (els.length == 0 || els[0] != 0) {
            msg.push({
                type:   'Text'
                ,text:  els.length == 0 ? val : val.substring(0, els[0])
            });
            pos = msg[0].text.length;
        }

        for (var i=0; i<els.length; i++) {
            var str = val.substring(els[i]);
            if (val.charAt(els[i]) == '@' && str.indexOf(']') > -1) {
                end = str.indexOf(']') + 1;
            } else if (str.search(/[ \t\r\n]/) != -1){
                end = str.search(/[ \t\r\n]/);
            } else {
                end = str.length;
            }

            var subs = str.substring(0, end);
            pos += subs.length;
            if (val.charAt(els[i]) == '@') {
                var mentionId = findMentionedUser(val.substring(els[i], pos));
                if (mentionId) {
                    msg.push({
                        type:	'Mention',
                        id:		mentionId
                    });
                } else {
                    msg.push({
                        type:	'Text',
                        text:	val.substring(els[i], pos).replace('[', '').replace(']', '')
                    });
                }
            }

            if (pos != els[i] && val.substring(pos) != '') {
                msg.push({
                    type:   'Text',
                    text:  i + 1 == els.length ? val.substring(pos) : val.substring(pos, els[i+1])
                });
                pos += msg[msg.length-1].text.length;
            }
        }

        if (!postParts) {
            postParts = {};
        }
        postParts.messageSegments = msg;
        return postParts;
    }

    /**
     * Constructs an object for posting attachments
     */
    function getAttachmentForPostBody(uploadedFileId) {
        return {
            contentDocumentId: uploadedFileId
        };
    }

    function blurCommentField($comment) {
        $comment.find('div.item-foto').hide();
        setTimeout(function() {
            $comment.find('input.button').hide();
        }, 200);
    }

    function findMentionedUser(name) {
        if (!name) {
            return '';
        }

        for (var i = 0 ; i < mentionedUsers.length; i++) {
            if (mentionedUsers[i]) {
                if ('@[' + mentionedUsers[i].name + ']' == name) {
                    return mentionedUsers[i].id;
                }
            }
        }
        return '';
    }
    
    function resetMentionList() {
    	mentionList = [];
    }

    return {
        wireSubmit            : wireSubmit,
        mentionedUsers        : mentionedUsers,
        submitPostAfterUpload : submitPostAfterUpload,
        handleFileUploadError : handleFileUploadError,
        blurCommentField      : blurCommentField,
        resetMentionList	  : resetMentionList
    };

})(jQuery);

