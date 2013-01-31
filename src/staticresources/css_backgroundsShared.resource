/**!
 * css_backgroundsShared.css
 *
 *
 */


/* Spinners are from: http://ajaxload.info/ - Use 'Indicator lite' */

#pageMask,
.spinner {
    background: url('media_image_status_gif_ajaxLoaderDark') 50% 50% no-repeat;
}

.alternate .spinner {
    background: url('media_image_status_gif_ajaxLoader') 50% 50% no-repeat;
}

/* Using important to avoid duplication in the high res screen media query. Cascade will still work since that file is last */
.saving {
    background: url('media_image_status_gif_ajaxLoader') 50% 50% no-repeat !important;
}

/* Leaving these .saving rules here just in case the background colors change for each of them down the road */
/*
.removeItem .saving,
.removeConfirm .saving {
    background: url('media_image_status_gif_ajaxLoaderRemoveItem') 50% 50% no-repeat !important;
}

.fullItem .saving {
    background: url('media_image_status_gif_ajaxLoaderFullItem') 50% 50% no-repeat !important;
}*/

.columnContent,
.landingPage .columnContent {
    background: #fff;
}

.validInput {
    background: url('media_image_icons_png8_valid16') 0 0 no-repeat;
}

.inValidInput {
    background: url('media_image_icons_png8_error16') 0 0 no-repeat;
}

#simplemodal-container a.modalCloseImg {
    background: url('media_image_buttons_png_appleClose') no-repeat;
}
