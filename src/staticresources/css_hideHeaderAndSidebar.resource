/**!
 *
 * css_hideHeaderAndSidebar
 *
 * Hides the header and sidebar page elements and leaves a static single content area
 *
 */


/* Overrides */
html {
    min-height: 100%;
}

body {
    overflow: visible;	/* Return to default to override fix for inertial scrolling in Lion */
    background: #029DDC;
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#029DDC), color-stop(100%, #2a83af));
    background: -webkit-linear-gradient(top, #029DDC 0%, #2a83af 100%);
    background:    -moz-linear-gradient(top, #029DDC 0%, #2a83af 100%);
    background:     -ms-linear-gradient(top, #029DDC 0%, #2a83af 100%);
    background:      -o-linear-gradient(top, #029DDC 0%, #2a83af 100%);
    background:   linear-gradient(to bottom, #029DDC 0%, #2a83af 100%);
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#029DDC', endColorstr='#2a83af',GradientType=0);
    min-height: 100%;
}


.header,
.headerMask,
.toolbar,
.sidebar {
    display: none;
}


.header {
    min-height: 0;
}


.wrapper {
    /* Needed to have iOS/phones be able to scroll the page height */
    position: static;
    /* Using translate3d on elements containing form inputs causing weird "jumping"
     * behavior in Android 2.x. Don't do it! :)
     * https://github.com/jquery/jquery-mobile/issues/search?utf8=✓&q=292
     * http://bit.ly/m7aNev
     */
    /*-moz-transform: 	translate(0, 0);
    -webkit-transform: 	translate(0, 0);
    -o-transform: 		translate(0, 0);
    -ms-transform: 		translate(0, 0);*/
}


.content {
    background: none;
}

