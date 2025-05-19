import { LightningElement, track } from 'lwc';
import login from '@salesforce/apex/NewCustomLoginFormController.login';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class CustomLogin extends NavigationMixin(LightningElement) {
    @track username = '';
    @track password = '';
    @track message = '';
    @track isLoading = false;

    connectedCallback() {
        // Clear sessionStorage to ensure popup shows on every login
        sessionStorage.removeItem('popupShown');
    }

    handleUsernameChange(event) {
        this.username = event.target.value;
    }

    handlePasswordChange(event) {
        this.password = event.target.value;
    }

    async handleLoginClick(event) {
        event.preventDefault(); // Prevent default browser behavior
        this.message = '';
        this.isLoading = true;
        const startUrl = '/s/?fromLogin=true'; // Adjust as per your site base URL

        if (!this.username || !this.password) {
            this.message = 'Please enter both username and password.';
            this.isLoading = false;
            return;
        }

        try {
            const result = await login({ username: this.username, password: this.password, startUrl });
            if (result && result.includes('frontdoor.jsp')) {
                this.message = 'Login successful! Redirecting...';
                window.location.href = result;
            } else {
                this.message = result.startsWith('fail') ? result : 'Login failed. Please check your credentials.';
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Login Error',
                        message: this.message,
                        variant: 'error'
                    })
                );
            }
        } catch (error) {
            console.error('Login error:', error);
            this.message = 'Unexpected error. Please try again.';
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Login Error',
                    message: this.message,
                    variant: 'error'
                })
            );
        } finally {
            this.isLoading = false;
        }
    }

    handleForgotPasswordClick() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Forgot_Password' // ✅ API Name of the Forgot Password page from Experience Cloud
            }
        });
    }
}



















// import { LightningElement, track } from 'lwc';
// import login from '@salesforce/apex/NewCustomLoginFormController.login';

// export default class CustomLogin extends LightningElement {
//     @track username = '';
//     @track password = '';
//     @track message = '';

//     handleUsernameChange(event) {
//         this.username = event.target.value;
//     }

//     handlePasswordChange(event) {
//         this.password = event.target.value;
//     }

//     handleLoginClick() {
//         this.message = '';
//         const startUrl = 'https://thesmartbridge-1eb-dev-ed.develop.my.site.com/s/'; // or change to another route if needed

//         if (!this.username || !this.password) {
//             this.message = 'Please enter both username and password.';
//             return;
//         }

//         login({ username: this.username, password: this.password, startUrl })
//             .then(result => {
//                 if (result && result.includes('frontdoor.jsp')) {
//                     this.message = 'Login successful! Redirecting...';
//                     window.location.href = result; // 🔁 redirect to the login URL
//                 } else {
//                     this.message = result.startsWith('fail') ? result : 'Login failed. Please check your credentials.';
//                 }
//             })
//             .catch(error => {
//                 console.error('Login error:', error);
//                 this.message = 'Unexpected error. Please try again.';
//             });
//     }
// }