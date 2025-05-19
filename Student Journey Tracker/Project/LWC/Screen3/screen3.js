import { LightningElement, api, track } from 'lwc';
import student from "@salesforce/resourceUrl/student";
import outline_left from "@salesforce/resourceUrl/outline_left";
import outline_right from "@salesforce/resourceUrl/outline_right";
import linkdin from "@salesforce/resourceUrl/linkdin";
import mail from "@salesforce/resourceUrl/mail";
import phone from "@salesforce/resourceUrl/phone";

export default class StudentJourneyTracker extends LightningElement {
    @track semesters = [
        'Sem - 1 (2021)', 'Sem - 2 (2021)', 'Sem - 3 (2022)', 'Sem - 4 (2022)', 
        'Sem - 5 (2023)', 'Sem - 6 (2023)', 'Sem - 7 (2024)', 'Sem - 8 (2024)'
    ];
    @track progressData = [
        { id: 'Sem - 1', percentage: 83, barStyle: 'height: 83%; background-color: #A4B561;' },
        { id: 'Sem - 2', percentage: 100, barStyle: 'height: 100%; background-color: #00A2B3;' },
        { id: 'Sem - 3', percentage: 75, barStyle: 'height: 75%; background-color: #F28C28;' },
        { id: 'Sem - 4', percentage: 88, barStyle: 'height: 88%; background-color: #F1788D;' },
        { id: 'Sem - 5', percentage: 85, barStyle: 'height: 85%; background-color: #9567E8;' },
        { id: 'Sem - 6', percentage: 80, barStyle: 'height: 80%; background-color: #5bc0de;' },
        { id: 'Sem - 7', percentage: 90, barStyle: 'height: 90%; background-color: #f0ad4e;' },
        { id: 'Sem - 8', percentage: 95, barStyle: 'height: 95%; background-color: #d9534f;' }
    ];

    @track filteredSemesters = [...this.semesters];
    @track filteredProgressData = [...this.progressData];
    @track startIndex = 0;

    @api student = student;
    @api outline_left = outline_left;
    @api outline_right = outline_right;
    @api phone = phone;
    @api linkdin = linkdin;
    @api mail = mail;

    handleYearChange(event) {
        const selectedYear = event.target.value;
        if (selectedYear === 'all') {
            this.filteredSemesters = [...this.semesters];
            this.filteredProgressData = [...this.progressData];
        } else {
            const year = parseInt(selectedYear, 10);
            const startIndex = (year - 1) * 2;
            this.filteredSemesters = this.semesters.slice(startIndex, startIndex + 2);
            this.filteredProgressData = this.progressData.slice(startIndex, startIndex + 2);
        }
        this.startIndex = 0;
    }

    get semestersToShow() {
        return this.filteredSemesters.slice(this.startIndex, this.startIndex + 5);
    }

    get visibleSemesters() {
        return this.filteredProgressData.slice(this.startIndex, this.startIndex + 5);
    }

    handleNext() {
        if (this.startIndex + 5 < this.filteredSemesters.length) {
            this.startIndex += 3;
        }
    }

    handlePrev() {
        if (this.startIndex > 0) {
            this.startIndex -= 3;
        }
    }
}


// import { LightningElement, api, track } from 'lwc';
// import student from "@salesforce/resourceUrl/student";
// import outline_left from "@salesforce/resourceUrl/outline_left";
// import outline_right from "@salesforce/resourceUrl/outline_right";
// import linkdin from "@salesforce/resourceUrl/linkdin";
// import mail from "@salesforce/resourceUrl/mail";
// import phone from "@salesforce/resourceUrl/phone";

// export default class StudentJourneyTracker extends LightningElement {
//     @track semesters = [
//         'Sem - 1 (2021)', 'Sem - 2 (2021)', 'Sem - 3 (2022)', 'Sem - 4 (2022)', 
//         'Sem - 5 (2023)', 'Sem - 6 (2023)', 'Sem - 7 (2024)', 'Sem - 8 (2024)'
//     ];
//     @track progressData = [
//                 { id: 1, name: 'Sem - 1', year: 'I', percentage: 83, barStyle: 'height: 83%; background-color: #A4B561;' },
//                 { id: 2, name: 'Sem - 2', year: 'I', percentage: 100, barStyle: 'height: 100%; background-color: #00A2B3;' },
//                 { id: 3, name: 'Sem - 3', year: 'II', percentage: 75, barStyle: 'height: 75%; background-color: #F28C28;' },
//                 { id: 4, name: 'Sem - 4', year: 'II', percentage: 88, barStyle: 'height: 88%; background-color: #F1788D;' },
//                 { id: 5, name: 'Sem - 5', year: 'III', percentage: 85, barStyle: 'height: 85%; background-color: #9567E8;' },
//                 { id: 6, name: 'Sem - 6', year: 'III', percentage: 80, barStyle: 'height: 80%; background-color: #5bc0de;' },
//                 { id: 7, name: 'Sem - 7', year: 'IV', percentage: 90, barStyle: 'height: 90%; background-color: #f0ad4e;' },
//                 { id: 8, name: 'Sem - 8', year: 'IV', percentage: 95, barStyle: 'height: 95%; background-color: #d9534f;' }
//             ];
        
//             // get visibleSemesters() {
//             //     return this.progressData;
               
//             // }
//             get visibleSemesters() {
//                 // Use `filteredProgressData` if it exists and has elements; otherwise, use `progressData`
//                 if (this.filteredProgressData && this.filteredProgressData.length > 0) {
//                     return this.filteredProgressData.slice(this.startIndex, this.startIndex + 5);
//                 } 
//                 return this.progressData.slice(this.startIndex, this.startIndex + 5);
//             }
            
    
//     @track filteredSemesters = [...this.semesters];
//     @track filteredProgressData = [...this.progressData];
//     @track startIndex = 0;

//     @api student = student;
//     @api outline_left = outline_left;
//     @api outline_right = outline_right;
//     @api phone = phone;
//     @api linkdin = linkdin;
//     @api mail = mail;

//     handleYearChange(event) {
//         const selectedYear = event.target.value;
//         if (selectedYear === 'all') {
//             this.filteredSemesters = [...this.semesters];
//             this.filteredProgressData = [...this.progressData];
//         } else {
//             const year = parseInt(selectedYear);
//             const startIndex = (year - 1) * 2; // Each year has two semesters
//             this.filteredSemesters = this.semesters.slice(startIndex, startIndex + 2);
//             this.filteredProgressData = this.progressData.slice(startIndex, startIndex + 2);
//         }
//         this.startIndex = 0; // Reset start index when filtering
//     }

//     get semestersToShow() {
//         return this.filteredSemesters.slice(this.startIndex, this.startIndex + 5);
//     }

//     get semestersBarsToshow() {
//         return this.filteredProgressData.slice(this.startIndex, this.startIndex + 5);
//     }

//     handleNext() {
//         if (this.startIndex + 5 < this.filteredSemesters.length) {
//             this.startIndex += 3;
//         }
//     }

//     handlePrev() {
//         if (this.startIndex > 0) {
//             this.startIndex -= 3;
//         }
//     }
// }


// import { LightningElement,api,track } from 'lwc';
// import student from "@salesforce/resourceUrl/student";
// import outline_left from "@salesforce/resourceUrl/outline_left";
// import outline_right from "@salesforce/resourceUrl/outline_right";
// import linkdin from "@salesforce/resourceUrl/linkdin";
// import mail from "@salesforce/resourceUrl/mail";
// import phone from "@salesforce/resourceUrl/phone";

// export default class StudentJourneyTracker extends LightningElement {
//     @track semesters = ['Sem - 1 (2021)', 'Sem - 2 (2021)', 'Sem - 3 (2022)', 'Sem - 4 (2022)', 'Sem - 5 (2023)', 'Sem - 6 (2023)', 'Sem - 7 (2024)', 'Sem - 8 (2024)'];
//     @track progressData = [
//         { sem: 'Sem - 1', percentage: 83, style: 'height: 83%;', subject1: 'HTML', subject2: 'Java', subject3: 'SQL' },
//         { sem: 'Sem - 2', percentage: 92, style: 'height: 92%;', subject1: 'HTML', subject2: 'Java', subject3: 'SQL' },
//         { sem: 'Sem - 3', percentage: 75, style: 'height: 75%;', subject1: 'HTML', subject2: 'Java', subject3: 'SQL' },
//         { sem: 'Sem - 4', percentage: 88, style: 'height: 88%;', subject1: 'HTML', subject2: 'Java', subject3: 'SQL' },
//         { sem: 'Sem - 5', percentage: 88, style: 'height: 88%;', subject1: 'HTML', subject2: 'Java', subject3: 'SQL' },
//         { sem: 'Sem - 6', percentage: 88, style: 'height: 88%;', subject1: 'HTML', subject2: 'Java', subject3: 'SQL' },
//         { sem: 'Sem - 7', percentage: 88, style: 'height: 88%;', subject1: 'HTML', subject2: 'Java', subject3: 'SQL' },
//         { sem: 'Sem - 8', percentage: 88, style: 'height: 88%;', subject1: 'HTML', subject2: 'Java', subject3: 'SQL' },
//      ];
//     @track startIndex = 0;
//     @api student=student;
//     @api outline_left=outline_left;
//     @api outline_right=outline_right;
//     @api phone=phone;
//     @api linkdin=linkdin;
//     @api mail=mail;
    
    
//     handleYearChange(event) {
//         const selectedYear = event.target.value;
//         console.log('Selected Year:', selectedYear);
//     }

//     get semestersToShow() {
//         return this.semesters.slice(this.startIndex, this.startIndex + 5);
//     }
//     get semestersBarsToshow() {
//         return this.progressData.slice(this.startIndex, this.startIndex + 5);
//     }


// handleNext() {
//     if (this.startIndex + 5 < this.semesters.length) {
//         this.startIndex += 3;
//     }
// }

// handlePrev() {
//     if (this.startIndex > 0) {
//         this.startIndex -= 3;
//     }
// }


//     renderedCallback() {
//     if (this.canvasRendered) return;
//     this.canvasRendered = true;

//     // Select all canvas elements in the template
//     const canvases = this.template.querySelectorAll('.bar-graph-canvas');

//     // Loop through each canvas and draw the graph for its respective sem data
//     canvases.forEach((canvas, index) => {
//         const ctx = canvas.getContext('2d');
//         const data = this.progressData[index]; // Get the progressData for this canvas

//         // Define the bar graph properties
//         const barWidth = 40;
//         const spaceBetweenBars = 10;
//         const startX = 30;
//         const startY = canvas.height - 30;

//         // Loop through the subjects to create bars
//         const subjects = ['subject1', 'subject2', 'subject3'];
//         subjects.forEach((subject, subIndex) => {
//             const percentage = data[subject];
//             const barHeight = (percentage / 100) * (canvas.height - 50); // Scale the height based on percentage
//             const xPosition = startX + (barWidth + spaceBetweenBars) * subIndex;
//             const yPosition = startY - barHeight;

//             // Set the color based on percentage
//             let color = '#FF5733'; // Default color (red)
//             if (percentage >= 80) {
//                 color = '#28a745'; // Green for high percentages
//             } else if (percentage >= 60) {
//                 color = '#ffc107'; // Yellow for mid-range percentages
//             } else {
//                 color = '#dc3545'; // Red for low percentages
//             }

//             // Set the color for the bar
//             ctx.fillStyle = color;

//             // Draw the bar
//             ctx.fillRect(xPosition, yPosition, barWidth, barHeight);
//         });
//     });
// }

    
// }




// import { LightningElement, api, track } from 'lwc';
// import sjtprofilepicture from "@salesforce/resourceUrl/sjtprofilepicture";
// import back from "@salesforce/resourceUrl/back";
// import left from "@salesforce/resourceUrl/left";
// import right from "@salesforce/resourceUrl/right";
// import mail from "@salesforce/resourceUrl/mail";
// import contact from "@salesforce/resourceUrl/contact";
// import linkedin from "@salesforce/resourceUrl/linkedin";

// import { LightningElement,api,track } from 'lwc';
// import student from "@salesforce/resourceUrl/student";           
// import outline_left from "@salesforce/resourceUrl/outline_left";  
// import outline_right from "@salesforce/resourceUrl/outline_right";     
// import linkdin from "@salesforce/resourceUrl/linkdin";
// import mail from "@salesforce/resourceUrl/mail";
// import phone from "@salesforce/resourceUrl/phone";

// export default class ProfileCardWithBarGraph extends LightningElement {
//     // Properties for profile details
//     @api goback = back;
//     @api profilePicture = student;
//     @api name = 'TONY STARK';
//     @api program = 'Java Full Stack';
//     @api shortDescription = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
//     @api about = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
//     @api email = 'tonystarkmark003@gmail.com';
//     @api phone = '9652348956';
//     @api linkedinProfile = 'https://www.linkedin.com';
//     @api left = outline_left;
//     @api right = outline_right;
//     @api contact = phone;
//     @api mail = mail;
//     @api linkedin = linkdin;

//     @track semesters = ['Sem - 1 (2021)', 'Sem - 2 (2021)', 'Sem - 3 (2022)', 'Sem - 4 (2022)', 'Sem - 5 (2023)', 'Sem - 6 (2023)', 'Sem - 7 (2024)', 'Sem - 8 (2024)'];
//     @track progressData = [
//         { sem: 'Sem - 1', percentage: 83, subject1: 'HTML', subject2: 'Java', subject3: 'SQL' },
//         { sem: 'Sem - 2', percentage: 92, subject1: 'HTML', subject2: 'Java', subject3: 'SQL' },
//         { sem: 'Sem - 3', percentage: 75, subject1: 'HTML', subject2: 'Java', subject3: 'SQL' },
//         { sem: 'Sem - 4', percentage: 88, subject1: 'HTML', subject2: 'Java', subject3: 'SQL' },
//         { sem: 'Sem - 5', percentage: 60, subject1: 'HTML', subject2: 'Java', subject3: 'SQL' },
//     ];

//     @track startIndex = 0;
    
//     get semestersToShow() {
//         return this.semesters.slice(this.startIndex, this.startIndex + 5);
//     }

//     // Handlers for navigation arrows
//     handlePrev() {
//         console.log('Previous arrow clicked');
//         if (this.startIndex > 0) {
//             this.startIndex -= 3;
//         }
//     }

//     handleNext() {
//         console.log('Next arrow clicked');
//         if (this.startIndex + 5 < this.progressData.length) {
//             this.startIndex += 3;
//         }
//     }

//     // Handler for year change dropdown
//     handleYearChange(event) {
//         const selectedYear = event.target.value;
//         console.log('Selected Year: ' + selectedYear);
//     }

//     // Go back to the previous page
//     goBack() {
//         window.history.back();
//     }

// //     // Bar graph rendering
// //     renderedCallback() {
// //         if (this.canvasRendered) return;
// //         this.canvasRendered = true;

// //         // Get the canvas element after the component is rendered
// //         const canvas = this.template.querySelector('canvas');
// //         const ctx = canvas.getContext('2d');

// //         // Define the bar graph properties
// //         const barWidth = 60;
// //         const spaceBetweenBars = 20;
// //         const startX = 30;
// //         const startY = canvas.height - 30;

// //         // Loop through the progressData to create bars
// //         this.progressData.forEach((data, index) => {
// //             const barHeight = (data.percentage / 100) * (canvas.height - 50); // Scale the height based on percentage
// //             const xPosition = startX + (barWidth + spaceBetweenBars) * index;
// //             const yPosition = startY - barHeight;

// //             // Set a color for each bar (you can customize this as needed)
// //             const color = '#FF5733'; // Example color for the bars
// //             ctx.fillStyle = color;

// //             // Draw the bar
// //             ctx.fillRect(xPosition, yPosition, barWidth, barHeight);

// //             // Add label below the bar
// //             ctx.fillStyle = '#000';
// //             ctx.font = '12px Arial';
// //             ctx.fillText(data.sem, xPosition + barWidth / 4, startY + 15);
// //         });
// //     }
// renderedCallback() {
//     if (this.canvasRendered) return;
//     this.canvasRendered = true;

//     // Get the canvas element after the component is rendered
//     const canvas = this.template.querySelector('canvas');
//     const ctx = canvas.getContext('2d');

//     // Define the bar graph properties
//     const barWidth = 40;
//     const spaceBetweenBars = 10;
//     const startX = 30;
//     const startY = canvas.height - 30;

//     // Loop through the progressData to create bars
//     this.progressData.forEach((data, index) => {
//         const barHeight = (data.percentage / 100) * (canvas.height - 50); // Scale the height based on percentage
//         const xPosition = startX + (barWidth + spaceBetweenBars) * index;
//         const yPosition = startY - barHeight;

//         // Set the color based on percentage
//         let color = '#FF5733'; // Default color (red)
//         if (data.percentage >= 80) {
//             color = '#28a745'; // Green for high percentages
//         } else if (data.percentage >= 60) {
//             color = '#ffc107'; // Yellow for mid-range percentages
//         } else {
//             color = '#dc3545'; // Red for low percentages
//         }

//         // Set the color for the bar
//         ctx.fillStyle = color;

//         // Draw the bar
//         ctx.fillRect(xPosition, yPosition, barWidth, barHeight);

        
//     });
// }
// }