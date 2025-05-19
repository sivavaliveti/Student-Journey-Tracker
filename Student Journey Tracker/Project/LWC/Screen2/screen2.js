import { LightningElement, track, api } from 'lwc';
import goback from '@salesforce/resourceUrl/goback';
import { NavigationMixin } from 'lightning/navigation';
import getUniqueProgramNames from '@salesforce/apex/Sjtscreen1.getUniqueProgramNames';
import getAllStudentsData from '@salesforce/apex/Sjtscreen1.getAllStudentsData';

export default class CollegeStudentTracker extends NavigationMixin(LightningElement) {
    @api goback = goback;
    @track filteredStudents = [];
    @track paginatedStudents = [];
    @track itemsPerPage = 6;
    @track showSpinner = true;
    @track selectedUniversity = '';
    @track selectedProgram = 'All Programs';
    @track programOptions = [];
    @track visibleRecords = [];
    @track allRecords = [];
    @track searchKey = '';
    @track selectedYear = 'All Years';
    @track selectedSemester = 'All Semesters';
    @track currentPage = 1;
    @track universityName = '';

    @track yearOptions = [
        { label: '2023-2024', value: '2023-2024' },
        { label: '2022-2023', value: '2022-2023' },
        { label: '2021-2022', value: '2021-2022' },
        { label: '2020-2021', value: '2020-2021' },
        { label: 'All Years', value: '' },
    ];

    @track semesterOptions = [
        { label: 'Sem-I', value: 'Sem-I' },
        { label: 'Sem-II', value: 'Sem-II' },
        { label: 'Sem-III', value: 'Sem-III' },
        { label: 'Sem-IV', value: 'Sem-IV' },
        { label: 'Sem-V', value: 'Sem-V' },
        { label: 'Sem-VI', value: 'Sem-VI' },
        { label: 'Sem-VII', value: 'Sem-VII' },
        { label: 'Sem-VIII', value: 'Sem-VIII' },
        { label: 'All Semesters', value: '' },
    ];

    connectedCallback() {
        const queryParams = new URLSearchParams(window.location.search);
        this.selectedUniversity = queryParams.get('universityId');
        this.universityName = queryParams.get('universityName');
        this.fetchPrograms();
        this.fetchInitialData();

    }
    fetchInitialData() {
        this.showSpinner = true;
        getAllStudentsData({
            searchKey: '',
            selectedUniversity: this.selectedUniversity,
            selectedProgram: '',
            selectedYear: '',
            selectedSemester: '',
        })
            .then((result) => {
                this.allRecords = result.map((student) => ({
                    ...student,
                    skillList: student.Skill ? student.Skill.split(';') : [],
                }));
            this.visibleRecords = this.getDataWithRowNumbers(this.allRecords.slice(0, 4));
                this.showSpinner = false;
            })
            .catch((error) => {
                console.error('Error fetching student data:', error);
                this.showSpinner = false;
            });
    }



 
   
    fetchPrograms() {
        this.showSpinner = true;
        console.log('fetchPrograms this.selectedUniversity', this.selectedUniversity);
        getUniqueProgramNames({ selectedUniversity: this.selectedUniversity})
            .then((result) => {
                this.programOptions = [
                    { label: 'All Programs', value: 'All Programs' },
                    ...result.map((program) => ({ label: program, value: program })),
                ];
                this.showSpinner = false;
            })
            .catch((error) => {
                console.error('Error fetching programs:', error);
                this.showSpinner = false;
            });
            
    }

    paginateRecords() {
        const start = (this.currentPage - 1) * this.itemsPerPage;
        const end = this.currentPage * this.itemsPerPage;
        this.visibleRecords = this.getDataWithRowNumbers(this.allRecords.slice(start, end));
    }

    getDataWithRowNumbers(records) {
        return records.map((item, index) => ({
            ...item,
            rowNumber: (this.currentPage - 1) * this.itemsPerPage + index + 1,
            StudentName: item.StudentName || 'Unknown Student',
        }));
    }

   
    handleSearch() {
        this.showSpinner = true;
        if (!this.searchKey) {
            console.log('No search key provided, fetching initial data.');
            this.fetchInitialData();
            this.showSpinner = false;
            return; 
        }
        getAllStudentsData({
            searchKey: this.searchKey,
            selectedUniversity: this.selectedUniversity,
            selectedProgram: '',
            selectedYear: '',
            selectedSemester: ''    
        })
        .then((result) => {
            this.allRecords = result;
            console.log('all records');
            this.visibleRecords = this.getDataWithRowNumbers(this.allRecords.slice(0, 50));
            this.showSpinner = false;
        })
        .catch((error) => {
            console.error('fetching student data', error);
            this.showSpinner = false;
        });
    }


    handlePagination(event) {
        this.currentPage = parseInt(event.target.dataset.page, 10);
        this.paginateRecords();
    }
    

    previousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.paginateRecords();
        }
    }

    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.paginateRecords();
        }
    }

    get totalPages() {
        return Math.ceil(this.allRecords.length / this.itemsPerPage);
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

    goBack() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/screen1',
            },
        });
    }

    handleInputChange(event) {
        this.searchKey = event.target.value;
    }
    
    handleProgramChange(event) {
        console.log('selected program');
        this.selectedProgram = event.detail.value; 
        console.log('bye', this.selectedProgram);
    }

    handleYearChange(event) {
        this.selectedYear = event.detail.value;
        this.applyFilters(); 
    }
    
    handleSemisterChange(event) {
        this.selectedSemester = event.detail.value;
        console.log('Selected Semester:', this.selectedSemester);
        this.applyFilter(); 
    }
    
    applyFilters() {
        this.showSpinner = true;
        getAllStudentsData({
            searchKey: this.searchKey,
            selectedUniversity: this.selectedUniversity,
            selectedProgram: this.selectedProgram === 'All Programs' ? '' : this.selectedProgram,
            selectedYear: this.selectedYear === 'All Years' ? '' : this.selectedYear,
            selectedSemester: this.selectedSemester === 'All Semesters' ? '' : this.selectedSemester,
        })
            .then((result) => {
                this.allRecords = result.map((student) => ({
                    ...student,
                    skillList: student.Skill ? student.Skill.split(';') : [],
                }));
                this.visibleRecords = this.getDataWithRowNumbers(this.allRecords.slice(0, this.itemsPerPage));
                this.showSpinner = false;
            })
            .catch((error) => {
                console.error('Error applying filters:', error);
                this.showSpinner = false;
            });
    }
    
    handleDropdownChange(event) {
        const { name, value } = event.target.dataset;
        this[name] = value;
    }

    
}





// import { LightningElement, track, api } from 'lwc';
// import goback from '@salesforce/resourceUrl/goback';
// import { NavigationMixin } from 'lightning/navigation';
// import getUniqueProgramNames from '@salesforce/apex/Sjtscreen1.getUniqueProgramNames';
// import getAllStudentsData from '@salesforce/apex/Sjtscreen1.getAllStudentsData';

// export default class CollegeStudentTracker extends NavigationMixin(LightningElement) {
//     @api goback = goback;
//     @track filteredStudents = [];
//     @track paginatedStudents = [];
//     @track itemsPerPage = 6;
//     @track showSpinner = true;
//     @track selectedUniversity = '';
//     @track selectedProgram = 'All Programs';
//     @track programOptions = [];
//     @track visibleRecords = [];
//     @track allRecords = [];
//     @track searchKey = '';
//     @track selectedYear = 'All Years';
//     @track selectedSemester = 'All Semesters';
//     @track currentPage = 1;
//     @track universityName = '';

//     @track yearOptions = [
//         { label: '2023-2024', value: '2023-2024' },
//         { label: '2022-2023', value: '2022-2023' },
//         { label: '2021-2022', value: '2021-2022' },
//         { label: '2020-2021', value: '2020-2021' },
//         { label: 'All Years', value: '' },
//     ];

//     @track semesterOptions = [
//         { label: 'Sem-I', value: 'Sem-I' },
//         { label: 'Sem-II', value: 'Sem-II' },
//         { label: 'Sem-III', value: 'Sem-III' },
//         { label: 'Sem-IV', value: 'Sem-IV' },
//         { label: 'Sem-V', value: 'Sem-V' },
//         { label: 'Sem-VI', value: 'Sem-VI' },
//         { label: 'Sem-VII', value: 'Sem-VII' },
//         { label: 'Sem-VIII', value: 'Sem-VIII' },
//         { label: 'All Semesters', value: '' },
//     ];

//     connectedCallback() {
//         const queryParams = new URLSearchParams(window.location.search);
//         this.selectedUniversity = queryParams.get('universityId');
//         this.universityName = queryParams.get('universityName');
//         this.fetchPrograms();
//         this.fetchInitialData();

//     }
//     fetchInitialData() {
//         this.showSpinner = true;
//         getAllStudentsData({
//             searchKey: '',
//             selectedUniversity: this.selectedUniversity,
//             selectedProgram: '',
//             selectedYear: '',
//             selectedSemester: '',
//         })
//             .then((result) => {
//                 this.allRecords = result.map((student) => ({
//                     ...student,
//                     skillList: student.Skill ? student.Skill.split(';') : [],
//                 }));
//             this.visibleRecords = this.getDataWithRowNumbers(this.allRecords.slice(0, 4));
//                 this.showSpinner = false;
//             })
//             .catch((error) => {
//                 console.error('Error fetching student data:', error);
//                 this.showSpinner = false;
//             });
//     }



 
   
//     fetchPrograms() {
//         this.showSpinner = true;
//         console.log('fetchPrograms this.selectedUniversity', this.selectedUniversity);
//         getUniqueProgramNames({ selectedUniversity: this.selectedUniversity})
//             .then((result) => {
//                 this.programOptions = [
//                     { label: 'All Programs', value: 'All Programs' },
//                     ...result.map((program) => ({ label: program, value: program })),
//                 ];
//                 this.showSpinner = false;
//             })
//             .catch((error) => {
//                 console.error('Error fetching programs:', error);
//                 this.showSpinner = false;
//             });
            
//     }

//     paginateRecords() {
//         const start = (this.currentPage - 1) * this.itemsPerPage;
//         const end = this.currentPage * this.itemsPerPage;
//         this.visibleRecords = this.getDataWithRowNumbers(this.allRecords.slice(start, end));
//     }

//     getDataWithRowNumbers(records) {
//         return records.map((item, index) => ({
//             ...item,
//             rowNumber: (this.currentPage - 1) * this.itemsPerPage + index + 1,
//             StudentName: item.StudentName || 'Unknown Student',
//         }));
//     }

   
//     handleSearch() {
//         this.showSpinner = true;
//         if (!this.searchKey) {
//             console.log('No search key provided, fetching initial data.');
//             this.fetchInitialData();
//             this.showSpinner = false;
//             return; 
//         }
//         getAllStudentsData({
//             searchKey: this.searchKey,
//             selectedUniversity: this.selectedUniversity,
//             selectedProgram: '',
//             selectedYear: '',
//             selectedSemester: ''    
//         })
//         .then((result) => {
//             this.allRecords = result;
//             console.log('all records');
//             this.visibleRecords = this.getDataWithRowNumbers(this.allRecords.slice(0, 50));
//             this.showSpinner = false;
//         })
//         .catch((error) => {
//             console.error('fetching student data', error);
//             this.showSpinner = false;
//         });
//     }


//     handlePagination(event) {
//         this.currentPage = parseInt(event.target.dataset.page, 10);
//         this.paginateRecords();
//     }
    

//     previousPage() {
//         if (this.currentPage > 1) {
//             this.currentPage--;
//             this.paginateRecords();
//         }
//     }

//     nextPage() {
//         if (this.currentPage < this.totalPages) {
//             this.currentPage++;
//             this.paginateRecords();
//         }
//     }

//     get totalPages() {
//         return Math.ceil(this.allRecords.length / this.itemsPerPage);
//     }

//     get paginationNumbers() {
//         return Array.from({ length: this.totalPages }, (_, i) => i + 1);
//     }

//     get isFirstPage() {
//         return this.currentPage === 1;
//     }

//     get isLastPage() {
//         return this.currentPage === this.totalPages;
//     }

//     goBack() {
//         this[NavigationMixin.Navigate]({
//             type: 'standard__webPage',
//             attributes: {
//                 url: '/screen1',
//             },
//         });
//     }

//     handleInputChange(event) {
//         this.searchKey = event.target.value;
//     }
    
//     handleProgramChange(event) {
//         console.log('selected program');
//         this.selectedProgram = event.detail.value; 
//         console.log('bye', this.selectedProgram);
//     }

//     handleYearChange(event) {
//         this.selectedYear = event.detail.value;
//         this.applyFilters(); 
//     }
    
//     handleSemisterChange(event) {
//         this.selectedSemester = event.detail.value;
//         this.applyFilter(); 
//     }
    
//     applyFilters() {
//         this.showSpinner = true;
//         getAllStudentsData({
//             searchKey: this.searchKey,
//             selectedUniversity: this.selectedUniversity,
//             selectedProgram: this.selectedProgram === 'All Programs' ? '' : this.selectedProgram,
//             selectedYear: this.selectedYear === 'All Years' ? '' : this.selectedYear,
//             selectedSemester: this.selectedSemester === 'All Semesters' ? '' : this.selectedSemester,
//         })
//             .then((result) => {
//                 this.allRecords = result.map((student) => ({
//                     ...student,
//                     skillList: student.Skill ? student.Skill.split(';') : [],
//                 }));
//                 this.visibleRecords = this.getDataWithRowNumbers(this.allRecords.slice(0, this.itemsPerPage));
//                 this.showSpinner = false;
//             })
//             .catch((error) => {
//                 console.error('Error applying filters:', error);
//                 this.showSpinner = false;
//             });
//     }
    
//     handleDropdownChange(event) {
//         const { name, value } = event.target.dataset;
//         this[name] = value;
//     }

    
// }