textarea, input[type="text"] {
    outline: none;
}

/*img upload*/
.form-post-container.profile-img-upload {
    background-color: inherit;
    border: medium none;
    display: block;
    padding: 0;
    text-align: center;
}

.form-post-container.profile-img-upload .post-actions-container {
    display:block;
}

.form-post-container.profile-img-upload .post-actions-container .actions-bucket.mobile,
.form-post-container.profile-img-upload .post-actions-container .actions-bucket.desktop {
    display: block;
    padding:5px 0;
    position: relative;
}

.form-post-container.profile-img-upload .post-actions-container .actions-bucket.desktop .file-wrap {
    margin-top: 9px;
}

.form-post-container.profile-img-upload .post-actions-container .actions-bucket.desktop .cta {
    display:block;
}

.form-post-container.profile-img-upload .post-actions-container .actions-bucket.desktop .button-browse {
    position: absolute;
    right: 12px;
    top: 6px;
}

.form-post-container.profile-img-upload .post-actions-container .actions-bucket.desktop .button-browse .cta {
    color: #fff;
    font-size: inherit;
    font-weight: bold;
    padding: 0.75em 1em;
}

.form-post-container.profile-img-upload .actions-bucket.mobile .box {
    border: 1px solid #000000;
    border-radius: 10px 10px 10px 10px;
    color: white;
    display: inline-block;
    font-weight: bold;
    margin: 0 3px 0 0;
    padding: 0.5em 1.2em;
}

.form-post-container.profile-img-upload .actions-bucket.mobile .box .icon-camera,
.form-post-container.profile-img-upload .actions-bucket.mobile .box .icon-gallery {
    display: inline-block;
    margin: 0;
    vertical-align: middle;
}
/*end img upload*/

.profile-container .user-details .user-info {
    margin: 0.5em 0;
    overflow: hidden;
    padding: 0;
}

.profile-container .user-details .user-info .item {
    display: inline-block;
    margin: 0.5em 1em 0.5em 0;
    text-align: center;
    color: #3D9CD1;
    font-weight:bold;
}

.profile-container .user-details .user-info .item a {
    word-wrap: break-word;
}

/* profile user info icons */
.profile-container .user-details .user-info .icons-profile {
    background: url("media_image_icons_png_chatterProfileIcons") no-repeat scroll 0 0 transparent;
     padding-left: 1.4em;
}

.profile-container .user-details .user-info .icons-profile.iconWork{
    background-position: -2px 2px;
    padding-left:1.4em;
}

.profile-container .user-details .user-info .icons-profile.iconMobile{
    background-position: -2px -55px;
    padding-left:1.1em;
}

.profile-container .user-details .user-info .icons-profile.iconEmail{
    background-position: -2px -37px;
    padding-left:1.4em;
}

.profile-container .user-details .user-info .icons-profile.iconTwitter{
    background-position: -2px -21px;
    padding-left:1.4em;
}
/* end profile user info icons */

.profile-container .buttons {
    float: right;
    margin-bottom: 10px;
    margin-right: 20px;
    margin-top: 30px;
    text-align: center;
    white-space: nowrap;
}

.profile-container .user-about-container {
    margin: 20px 0;
}

.profile-container .user-about-container .user-about-more-a {
    font-size: 0.813em;
    font-weight: bold;
}

.profile-container .user-about-more {
    display:none;
}

.profile-chatter-info .info-item {
    float:left;
    width:25%;
}

.profile-container .actions .follow-link:hover,
.email:hover {
    color: #FFF;
}

.edit-profile-container {
    display: none;
}

.edit-profile-container input.checkbox {
    margin: 0 10px 0 0;
       vertical-align: middle;
       width:auto;
}

.create-contact.display-none {
    display: none;
}


/*max-width: 480px*/
@media screen and (max-width: 30em) {
    .form-post-container.profile-img-upload .post-actions-container .actions-bucket.mobile,
    .form-post-container.profile-img-upload .post-actions-container .actions-bucket.desktop {
        padding: 25px 0 0;
    }

    .form-post-container.profile-img-upload {
        float:left;
        margin:0 0 0 10px;
    }

    .edit-profile-container.edit-container .form-container .fields-container {
        width: 100%;
    }

    .profile-container .user-details .user-info .item{
        display: block;
        text-align: left;
        padding-left:0;
    }
}

