import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class HomePage extends NavigationMixin(LightningElement) {
    showPopup = false;

    connectedCallback() {
        // Check if popup has already been shown in this session
        const popupShown = sessionStorage.getItem('popupShown');
        if (popupShown) {
            this.showPopup = false;
            return;
        }

        // Get URL parameters
        const urlParams = new URLSearchParams(window.location.search);
        const fromLogin = urlParams.get('fromLogin');

        // Show popup only if coming from login
        if (fromLogin === 'true') {
            this.showPopup = true;
            // Mark popup as shown in session storage
            sessionStorage.setItem('popupShown', 'true');
        }
    }

    handlePopupClose() {
        this.showPopup = false;
    }
}