import { LightningElement, track, api } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import getUniversityWiseData from '@salesforce/apex/topData.getUniversityWiseData';
import getProgramsAndCourses from '@salesforce/apex/topData.getProgramsAndCourses';
export default class UniversityDashboard extends NavigationMixin(LightningElement) {
    // @track universitiesCount = 0;
    // @track studentsCount = 0;
    // @track mentorsCount = 0;
    // @track programsCount = 0;
    // @track coursesCount = 0;
    @track showSpinner = true;
    @track selectedUniversity='';
    @track searchQuery = ''; // Store user input
    @track currentPage = 1;
    @track itemsPerPage = 4;
    @track allRecords = []; // Initialize as an empty array
@track visibleRecords = [];
    @api selectedCRTValue = false;


    @track programOptions = [];
    @track courseOptions = [];
    @track selectedProgram = '';
    @track selectedCourse = '';

    connectedCallback() {
        this.fetchData();
        this.fetchProgramsAndCourses();

        }
    
        fetchData() {              
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


        fetchProgramsAndCourses() {
            this.showSpinner = true;
            console.log('Fetching program and course names');
    
            getProgramsAndCourses()
                .then((result) => {
                    // Extract unique programs and courses
                    let programs = new Set();
                    let courses = new Set();
    
                    result.forEach((item) => {
                        programs.add(item.programName);
                        courses.add(item.courseName);
                    });
    
                    this.programOptions = [
                        { label: 'All Programs', value: '' },
                        ...Array.from(programs).map((program) => ({ label: program, value: program })),
                    ];
    
                    this.courseOptions = [
                        { label: 'All Courses', value: '' },
                        ...Array.from(courses).map((course) => ({ label: course, value: course })),
                    ];
    
                    console.log('Programs:', this.programOptions);
                    console.log('Courses:', this.courseOptions);
                })
                .catch((error) => {
                    console.error('Error fetching programs and courses:', error);
                })
                .finally(() => {
                    this.showSpinner = false;
                });
        }
    
        handleProgramChange(event) {
            this.selectedProgram = event.target.value;
            console.log('Selected Program:', this.selectedProgram);
        }
    
        handleCourseChange(event) {
            this.selectedCourse = event.target.value;
            console.log('Selected Course:', this.selectedCourse);
        }
    

        // fetchPrograms() {
        //     this.showSpinner = true;
        //     console.log('fetchPrograms this.selectedUniversity', this.selectedUniversity);
        //     getUniqueProgramNames({ selectedUniversity: this.selectedUniversity})
        //         .then((result) => {
        //             this.programOptions = [
        //                 { label: 'All Programs', value: 'All Programs' },
        //                 ...result.map((program) => ({ label: program, value: program })),
        //             ];
        //             this.showSpinner = false;
        //         })
        //         .catch((error) => {
        //             console.error('Error fetching programs:', error);
        //             this.showSpinner = false;
        //         });
                
        // }
        
        getDataWithRowNumbers(records) {
            if (!Array.isArray(records)) {
                return []; // Return an empty array if records is not an array
            }
            return records.map((item, index) => ({
                ...item,
                rowNumber: index + 1,
            }));
        }
        
    
        fetchPrograms() {
            this.showSpinner = true;
            console.log('Fetching all program names');
    
            getUniqueProgramNames()
            .then((result) => {
                this.programOptions = [
                    { label: 'All Programs', value: '' }, // Default option
                    ...result.map((program) => ({ label: program, value: program })),
                ];
                console.log('Fetched programs:', this.programOptions);
            })
            .catch((error) => {
                console.error('Error fetching programs:', error);
            })
            .finally(() => {
                this.showSpinner = false;
            });
    }

    handleProgramChange(event) {
        this.selectedProgram = event.target.value;
        console.log('Selected Program:', this.selectedProgram);
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
    
    
        
    
    
    
    
        // get totalPages() {
        //     return Math.ceil(this.filteredUniversities.length / this.itemsPerPage);
        // }
        get totalPages() {
            return Math.ceil(this.visibleRecords.length / this.itemsPerPage);
        }
        
    
        // get paginatedUniversities() {
        //     const start = (this.currentPage - 1) * this.itemsPerPage;
        //     return this.filteredUniversities.slice(start, start + this.itemsPerPage);
        // }
    
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
    
        // Trigger search when the user clicks the 'Search' button
        // handleSearch() {
        //     this.filteredQuery = this.searchQuery; // Set the filtered query to the input value
        //     this.currentPage = 1; // Reset to the first page after search
        // }
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
    

//     connectedCallback() {
//         this.fetchData();
//         }
// fetchData() {
  

//     getTopHeadersData()
//         .then((result) => {
//             console.log('getTopHeadersData',result);
//             this.universitiesCount = result.UniqueUniversities ;
//             this.studentsCount = result.UniqueContacts || 0;
//             this.mentorsCount = result.UniqueMentors || 0;
//             this.programsCount = result.UniquePrograms || 0;
//             this.coursesCount = result.UniqueCourses || 0;
//         })
//         .catch((error) => {
//             console.error('Error fetching top headers data:', error);
//         })


//         getData({ selectedUniversity: '' })
//     .then((result) => {
        
//         console.log('getUniversityWiseData', result);
//         this.allRecords = result || []; // Default to empty array if null or undefined
//         this.visibleRecords = this.getDataWithRowNumbers(this.allRecords.slice(0, 5));
//     })
//     .catch((error) => {
//         console.error('Error fetching data:', error);
//         this.allRecords = []; // Ensure a fallback to an empty array
//         this.visibleRecords = [];
//     })
//         .finally(() => {
//             this.showSpinner = false;
//         });
// }

// getDataWithRowNumbers(records) {
//     if (!Array.isArray(records)) {
//         return []; // Return an empty array if records is not an array
//     }
//     return records.map((item, index) => ({
//         ...item,
//         rowNumber: index + 1,
//     }));
// }

// handlenavigation(event){
      
//     const universityId = event.target.dataset.id;
//         const universityName = event.target.textContent.trim();
//         const url = `/screen2?universityId=${universityId}&universityName=${encodeURIComponent(universityName)}`;
//         console.log('universityId', universityId);
//         console.log('universityName', universityName);
    
//         this[NavigationMixin.Navigate]({
//             type: 'standard__webPage',
//                 attributes: {
//                     url: url,
//                 },
//             state: {
//                 universityId: universityId,
//                 universityName: universityName
//             }
//         });
            
//         }



}