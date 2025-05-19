import { LightningElement, track } from 'lwc';

export default class HomePopup extends LightningElement {
    @track showPopup = false;

    connectedCallback() {
        // Show popup only once per login session
        const alreadyShown = sessionStorage.getItem('popupShownAfterLogin');

        if (!alreadyShown) {
            this.showPopup = true;
            sessionStorage.setItem('popupShownAfterLogin', 'true');
        }
    }

    closePopup() {
        this.showPopup = false;
    }
}