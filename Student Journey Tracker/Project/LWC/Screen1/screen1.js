import { LightningElement, track } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import getTopHeadersData from '@salesforce/apex/Sjtscreen1.getTopHeadersData';
export default class UniversityDashboard extends NavigationMixin(LightningElement) {
    @track universities = [
        { id: 1, name: "KLC Tech College", programs: 15, students: 100, mentors: 15 },
        { id: 2, name: "Alpha University", programs: 12, students: 200, mentors: 25 },
        { id: 3, name: "Beta Institute", programs: 20, students: 300, mentors: 30 },
        { id: 4, name: "Gamma College", programs: 18, students: 400, mentors: 20 },
        { id: 5, name: "Delta Academy", programs: 22, students: 500, mentors: 28 },
        { id: 6, name: "Epsilon School", programs: 10, students: 600, mentors: 10 },
        { id: 7, name: "KLC Tech College", programs: 15, students: 100, mentors: 15 },
        { id: 8, name: "Alpha University", programs: 12, students: 200, mentors: 25 },
        { id: 9, name: "Beta Institute", programs: 20, students: 300, mentors: 30 },
        { id: 10, name: "Gamma College", programs: 18, students: 400, mentors: 20 },
        { id: 11, name: "Delta Academy", programs: 22, students: 500, mentors: 28 },
        { id: 12, name: "Epsilon School", programs: 10, students: 600, mentors: 10 },
        // Add more as needed
    ];

    @track universitiesCount=0;
    @track studentsCount=0;
    @track mentorsCount=0;
    @track programsCount=0;
    @track coursesCount=0;
    connectedCallback() {
        this.fetchData();
    }

    fetchData() {
        getTopHeadersData()
            .then((result) => {
                console.log('getTopHeadersData',result);
                this.universitiesCount = result.UniqueUniversities || 0;
                this.studentsCount = result.UniqueContacts || 0;
                this.mentorsCount = result.UniqueMentors || 0;
                this.programsCount = result.UniquePrograms || 0;
                this.coursesCount = result.UniqueCourses || 0;
            })
            .catch((error) => {
                console.error('Error fetching data:', error);
            });
    }




    @track searchQuery = ''; // Stores the current input value
    @track filteredQuery = ''; // Stores the query to filter when search is clicked
    @track currentPage = 1;
    @track itemsPerPage = 6;
    handlenavigation(){
        this[NavigationMixin.Navigate]({
            type:'standard__webPage',
            attributes:{
                url:'/screen2'
            }
        });
    }
    // Computed properties
    // get universitiesCount() {
    //     return this.filteredUniversities.length;
    // }

    // get studentsCount() {
    //     return this.filteredUniversities.reduce((sum, uni) => sum + uni.students, 0);
    // }

    // get mentorsCount() {
    //     return this.filteredUniversities.reduce((sum, uni) => sum + uni.mentors, 0);
    // }

    // get programsCount() {
    //     return this.filteredUniversities.reduce((sum, uni) => sum + uni.programs, 0);
    // }

    // get coursesCount() {
    //     return 300; // Example value
    // }

    get filteredUniversities() {
        return this.universities.filter((university) =>
            university.name.toLowerCase().includes(this.filteredQuery.toLowerCase())
        );
    }

    get totalPages() {
        return Math.ceil(this.filteredUniversities.length / this.itemsPerPage);
    }

    get paginatedUniversities() {
        const start = (this.currentPage - 1) * this.itemsPerPage;
        return this.filteredUniversities.slice(start, start + this.itemsPerPage);
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

    handleSearchChange(event) {
        // Update only the input value, not the filtered query
        this.searchQuery = event.target.value;
    }

    handleSearch() {
        // Update the filtered query only when the Search button is clicked
        this.filteredQuery = this.searchQuery;
        this.currentPage = 1; // Reset to the first page
    }

    previousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
        }
    }

    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
        }
    }

    navigateToPage(event) {
        this.currentPage = Number(event.target.dataset.page);
    }


}