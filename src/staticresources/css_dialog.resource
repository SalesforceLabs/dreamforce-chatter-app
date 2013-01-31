/**!
 * css_dialog.css
 *
 * Masks and modal dialogs
 *
 */

/* Prevent page from being scrolled */
body.blocked {
    overflow: hidden;
    position: fixed;
    height: 100%;
    width: 100%;
}

#pageMask,
.areaMask,
.transparentMask,
.confirmOverlay {
    overflow: hidden;
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    /* Don't use 'bottom' or else the mask will not fill page on scroll on mobiles */
    width: 100%;
    height: 100%;
    display: none;
    z-index: 9000;
}

.transparentMask {
    height: 2000em;
}

/* This should always be the highest on the page since it is meant for blocking everything */
#pageMask {
    z-index: 99999999;
}

.spinner {
    height: 100%;
    width: 100%;
}

#modalContent {
    display:none;
}

#overlayContent {
    padding: 0.5em 1em;
    width: 100%;
    height: 100%;
    position:absolute;
    display: none;
}

#simplemodal-container {
    height: 75%;
    min-height: 18em;
    max-height: 24em;
    width: 37.5em;
}

#simplemodal-container .simplemodal-data {
    padding: 0.4em;
}

.buttonContainer a,
.buttonContainer input,
.buttonContainer a:hover {
    margin:1.3em 0.5em;
}
.buttonContainer a.uiButton,
.buttonContainer a.uiButton:hover {
    color: #fff;
}
