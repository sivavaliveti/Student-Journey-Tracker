import { LightningElement, track } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
// import AttributeFormat from '@salesforce/schema/SamlSsoConfig.AttributeFormat';
import getTopHeadersData from '@salesforce/apex/Sjtscreen1.getTopHeadersData';
import getUniversityWiseData from '@salesforce/apex/Sjtscreen1.getUniversityWiseData';
//import getUniqueProgramNames from '@salesforce/apex/Sjtscreen1.getUniqueProgramNames';
import callSOAPAPI from '@salesforce/apex/Sjtexample.callSOAPAPI';

import getStudents from '@salesforce/apex/AccountDetails.getStudents';

import callRESTAPI from '@salesforce/apex/SjtexampleRest.callRESTAPI';

import runBatchJob from '@salesforce/apex/BatchFetchContacts.runBatchJob';
import getContacts from '@salesforce/apex/BatchFetchContacts.getContacts';
export default class UniversityDashboard extends NavigationMixin(LightningElement) {
    @track selectedUniversity='';
    @track searchQuery = ''; // Store user input
    @track currentPage = 1;
    @track itemsPerPage = 4;
    @track universitiesCount=0;
    @track studentsCount=0;
    @track mentorsCount=0;
    @track programsCount=0;
    @track coursesCount=0;
    @track allRecords = []; // Initialize as an empty array
@track visibleRecords = []; // Ensure this is also initialized
@track inputParam = '';
@track response = '';


@track inputNumber = '';
@track outputWords = '';
@track errorMessage = '';

@track students = [];
    @track totalStudents = 0;
    @track error;


 @track contacts;
    @track error;

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Email', fieldName: 'Email', type: 'email' },
        { label: 'Phone', fieldName: 'Phone', type: 'phone' },
        { label: 'Account Name', fieldName: 'Account.Name' }
    ];

    // Run Batch Job
    handleRunBatch() {
        runBatchJob()
            .then(() => {
                console.log('Batch Job Started');
            })
            .catch(error => {
                console.error('Error running batch:', error);
                this.error = error.body.message;
            });
    }

    // Fetch Contacts
    handleFetchContacts() {
        getContacts()
            .then(result => {
                this.contacts = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error.body.message;
                this.contacts = undefined;
            });
    }

handleNumberChange(event) {
    this.inputNumber = event.target.value;
}

handleConvert() {
    if (this.inputNumber) {
        callRESTAPI({ inputParam: this.inputNumber })
            .then(result => {
                if (result.startsWith('Error:') || result.startsWith('Exception:')) {
                    this.errorMessage = result;
                    this.outputWords = '';
                } else {
                    this.outputWords = result;
                    this.errorMessage = '';
                }
            })
            .catch(error => {
                this.errorMessage = 'Error: ' + (error.body ? error.body.message : error);
                this.outputWords = '';
            });
    } else {
        this.errorMessage = 'Please enter a number';
        this.outputWords = '';
    }
}



handleInputChange(event) {
    this.inputParam = event.target.value;
}

callSOAPAPI() {
    callSOAPAPI({ inputParam: this.inputParam })
        .then(result => {
            this.response = result;
        })
        .catch(error => {
            this.response = 'Error: ' + JSON.stringify(error);
        });
}


    connectedCallback() {
    this.fetchData();
 this.fetchStudents();
    }
 
    fetchStudents() {
        getStudents()
            .then((data) => {
                this.students = data.students;
                this.totalStudents = data.totalStudents;
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                this.students = [];
                this.totalStudents = 0;
            });
    }
    fetchData() {
        getTopHeadersData()
            .then((result) => {
                console.log('getTopHeadersData',result);
                this.universitiesCount = result.UniqueUniversities ;
                this.studentsCount = result.UniqueContacts || 0;
                this.mentorsCount = result.UniqueMentors || 0;
                this.programsCount = result.UniquePrograms || 0;
                this.coursesCount = result.UniqueCourses || 0;
            })
            .catch((error) => {
                console.error('Error fetching data:', error);
            });

          
        getUniversityWiseData({ selectedUniversity: '' })
    .then((result) => {
        
        console.log('getUniversityWiseData', result);
        this.allRecords = result || []; // Default to empty array if null or undefined
        this.visibleRecords = this.getDataWithRowNumbers(this.allRecords.slice(0, 5));
    })
    .catch((error) => {
        console.error('Error fetching data:', error);
        this.allRecords = []; // Ensure a fallback to an empty array
        this.visibleRecords = [];
    })
    .finally(() => {
        this.showSpinner = false;
        
    });

    }
    
    getDataWithRowNumbers(records) {
        if (!Array.isArray(records)) {
            return []; // Return an empty array if records is not an array
        }
        return records.map((item, index) => ({
            ...item,
            rowNumber: index + 1,
        }));
    }
    



    // get filteredUniversities() {
    //     // Return filtered universities based on the filteredQuery
    //     return this.universities.filter((university) =>
    //         university.name.toLowerCase().includes(this.filteredQuery.toLowerCase())
    //     );
    // }
    handlenavigation(event){
      
const universityId = event.target.dataset.id;
    const universityName = event.target.textContent.trim();
    const url = `/screen2?universityId=${universityId}&universityName=${encodeURIComponent(universityName)}`;
    console.log('universityId', universityId);
    console.log('universityName', universityName);

    this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
            attributes: {
                url: url,
            },
        state: {
            universityId: universityId,
            universityName: universityName
        }
    });
        
    }

    get totalPages() {
        return Math.ceil(this.visibleRecords.length / this.itemsPerPage);
    }
    

    get paginationNumbers() {
        return Array.from({ length: this.totalPages }, (_, i) => i + 1);
    }

    get isFirstPage() {
        return this.currentPage === 1;
    }

    get isLastPage() {
        return this.currentPage === this.totalPages;
    }

    // Handle search input change
    handleSearchChange(event) {
        this.searchQuery = event.target.value; // Capture input but don't filter yet
    }

    handleSearch() {
        // Filter records based on searchQuery
        this.visibleRecords = this.allRecords.filter((record) =>
            record.name.toLowerCase().includes(this.searchQuery.toLowerCase()) 
        );
    
        // Set row numbers for the filtered records
        this.visibleRecords = this.getDataWithRowNumbers(this.visibleRecords);
    
        // Reset to the first page after search
        this.currentPage = 1;
    }
    

    // Handle previous page
    previousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
        }
    }

    // Handle next page
    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
        }
    }

    // Navigate to a specific page
    navigateToPage(event) {
        this.currentPage = Number(event.target.dataset.page);
    }
}