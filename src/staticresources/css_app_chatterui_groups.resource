/* GROUPS
   ================================================== */

/*img upload*/

.form-post-container.group-img-upload {
    background-color: #FFFFFF;
    border: medium none;
    display: block;
    padding: 0;
}

.form-post-container.group-img-upload .mobilePhotoTitle {
    font-size:0.8em;
}

.form-post-container.group-img-upload .post-actions-container {
    display:block;
}

.form-post-container.group-img-upload .post-actions-container .actions-bucket.display-none,
.form-post-container.profile-img-upload .post-actions-container .actions-bucket.display-none {
    display:none !important;
}

.form-post-container.group-img-upload .post-actions-container .actions-bucket.mobile,
.form-post-container.group-img-upload .post-actions-container .actions-bucket.desktop {
    display: block;
    padding: 5px 0;
    position: relative;
}

.form-post-container.group-img-upload .post-actions-container .actions-bucket.desktop .file-wrap {
    margin-top: 9px;
}

.form-post-container.group-img-upload .post-actions-container .actions-bucket.desktop .button-browse {
    position: absolute;
    right: 12px;
    top: 6px;
}

.form-post-container.group-img-upload .post-actions-container .actions-bucket.desktop .button-browse .cta {
    color: #fff;
    font-size: inherit;
    font-weight: bold;
    padding: 0.75em 1em;
}


/* override input in upload iframe */
.form-upload.desktop.group .input-placeholder {
    width:100px
}

.form-post-container.group-img-upload .actions-bucket.mobile .box {
    border: 1px solid #000000;
    border-radius: 10px 10px 10px 10px;
    color: white;
    display: inline-block;
	*display: inline;
	*zoom: 1;
    font-weight: bold;
    margin: 0 3px 0 0;
    padding: 0.5em 1.2em;
}

.form-post-container.group-img-upload .actions-bucket.mobile .box .icon-camera,
.form-post-container.group-img-upload .actions-bucket.mobile .box .icon-gallery {
    display: inline-block;
    margin: 0;
    vertical-align: middle;
}
/*end img upload*/


.list-container .list-item .request-pending {
	float:right;
	margin: 10px 5px 0 0;
}

.request-pending label {
	color: #666;
}

.group-container .search-container {
	float: left;
}

.group-container .add-member-nav {
    float: left;
    margin-left: 20px;
    padding: 10px 0;
}

.group-container .add-member-nav a.selected {
    background: none repeat scroll 0 0 transparent;
    color: #000000;
}

.group-container .list-item .follow-link.add-to-group {
    background: url("media_image_icons_png_groupAdd") no-repeat scroll 5px 5px #6EB338;
    height: 15px;
    padding: 0.75em 1em;
    width: 23px;
}

.group-container .list-item .follow-link.remove-from-group{
	background: url("media_image_icons_png_deny") no-repeat scroll 8px 5px #4D5253;
    height: 15px;
    padding: 0.75em 1em;
    width: 23px;
}


.icon-pending {
    background: url("media_image_icons_png_pending") no-repeat scroll 0 0 transparent;
    display: block;
    height: 21px;
    margin: 0 auto;
    vertical-align: middle;
    width: 16px;
}

.icon-approve {
    background: url("media_image_icons_png_approve") no-repeat scroll 0 0 transparent;
    display: inline-block;
    height: 14px;
    vertical-align: middle;
    width: 16px;
}

.icon-private {
    background: url("media_image_icons_png_groupPrivate") no-repeat scroll 2px 0 #FFFFFF;
    border: 1px solid #AFAFAF;
    height: 18px;
    left: 15px;
    position: absolute;
    width: 18px;
}

.icon-owner {
    background: url("media_image_icons_png_groupOwner") no-repeat scroll 1px 1px #FFFFFF;
    border: 1px solid #AFAFAF;
    height: 18px;
    left: 0;
    position: absolute;
    width: 17px;
}

.icon-approve {
    background: url("media_image_icons_png_approve") no-repeat scroll 0 0 transparent;
    display: inline-block;
    height: 14px;
    vertical-align: middle;
    width: 16px;
	*display: inline;
	*zoom: 1;
}

.icon-deny {
    background: url("media_image_icons_png_deny") no-repeat scroll 0 0 transparent;
    display: inline-block;
    height: 17px;
    vertical-align: middle;
    width: 17px;
	*display: inline;
	*zoom: 1;
}

.icon-group {
    background: url("media_image_icons_png_group") no-repeat scroll 0 0 transparent;
    cursor: pointer;
    display: inline-block;
    margin-right: 0.75em;
    vertical-align: middle;
    height: 15px;
    width: 23px;
}

#panels {
    position: relative
}

.group-container {
    height: 100%
}

.group-summary {
    padding: 0.625em
}

.create-group-icon, .edit-group-btn{
    float: right;
    line-height: 1em;
    margin: 0.175em 0 0;
}

.create-group-container a.display-none {
	display:none;
}

.group-container .button .label,
.create-group-container .button .label {
    padding: 0 2px;
    font-weight:bold;
    cursor: pointer;
}

.create-group-container {
    display: none;
    border-bottom: 1px solid #AFAFAF;
}

.list-container .list-item .request-link {
    display: block;
    margin: 4px 0;
    padding:.5em .5em;
}

.slider-container {
    display: block;
    float: left;
    height: 32px;
    margin-left: 78px;
    margin-top: 5px;
    padding: 0;
    position: relative;
    width: 90px;
}

.slider-container .slider-cta {
	display: block;
	margin: 0;
	padding: 0;
	width: 50px;
    height: 30px;
    line-height: 30px;
	background: #afc753; /* Old browsers */
	background: -moz-linear-gradient(top, #afc753 0%, #96ae3a 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#afc753), color-stop(100%,#96ae3a)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top, #afc753 0%,#96ae3a 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top, #afc753 0%,#96ae3a 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top, #afc753 0%,#96ae3a 100%); /* IE10+ */
	background: linear-gradient(to bottom, #afc753 0%,#96ae3a 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#afc753', endColorstr='#96ae3a',GradientType=0 ); /* IE6-9 */
	-webkit-transition: all 0.25s ease-in-out;
	-moz-transition: all 0.25s ease-in-out;
	transition: all 0.25s ease-in-out;
	color: #fff;
	font-weight: bold;
	font-size:13px;
	cursor: pointer;
	text-align: center;
    text-shadow:1px 1px 2px rgba(0, 0, 0, 0.5);

    -webkit-border-radius: 3px 0 0 3px;
    -moz-border-radius: 3px 0 0 3px;
    border-radius: 3px 0 0 3px;
}

.slider-container .slider-cta.on {
	margin-left: 38px;
	background: #418fc0; /* Old browsers */
	background: -moz-linear-gradient(top, #418fc0 0%, #2d83b9 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#418fc0), color-stop(100%,#2d83b9)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top, #418fc0 0%,#2d83b9 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top, #418fc0 0%,#2d83b9 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top, #418fc0 0%,#2d83b9 100%); /* IE10+ */
	background: linear-gradient(to bottom, #418fc0 0%,#2d83b9 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#418fc0', endColorstr='#2d83b9',GradientType=0 ); /* IE6-9 */

    -webkit-border-radius: 0 3px 3px 0;
    -moz-border-radius: 0 3px 3px 0;
    border-radius: 0 3px 3px 0;
}



/* max-width: 480px */
@media screen and (max-width: 30em) {
	.slider-container {
    	float: right;
    	margin-left: 0;
	}

	.form-post-container.group-img-upload .post-actions-container .actions-bucket.mobile,
	.form-post-container.group-img-upload .post-actions-container .actions-bucket.desktop {
		padding: 25px 0 0;
	}

	.form-post-container.group-img-upload {
	    float:left;
	    margin:0 0 0 10px;
	}

    .group-search-container .info-container {
    	border-top: 1px solid #9C9C9C;
    	width: 100%;
    }
    .group-search-container .search-container {
        width: 95%;
        margin: 7px;
    }

	.group-container .actions .button{
		max-width: 162px;
    	text-align: center;
	}

	.create-group-container {
    	border-bottom: none;
	}

	.create-group-form {
	    float: left;
	    margin-right: 10px;
	    width: 100%;
	    padding-top:10px;
	}

}

/* END GROUPS
   ================================================== */
