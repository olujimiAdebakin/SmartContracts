// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SchoolRegister {
    // Struct representing a student
    struct Register {
        string name;
        uint256 id;
        uint256 classNumber;
    }

    // Contract deployer admin/school authority
    address public owner;

    // Mapping of school address to their list of students
    mapping(address => Register[]) private schoolRecords;

    // Event triggered when a student is registered
    event StudentRegistered(address indexed school, string name, uint256 id, uint256 classNumber);

    // Modifier to restrict access to contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized: Only the school can perform this action");
        _;
    }

    // Constructor to set the contract deployer as owner
    constructor() {
        owner = msg.sender;
    }

    /**
     Register a new student under a school
     param school The school's wallet address
     param _name Student's name
     param _id Unique student ID
     param _classNumber The class number the student belongs to
     */
    function registerStudent(
        address school,
        string calldata _name,
        uint256 _id,
        uint256 _classNumber
    ) external onlyOwner {
        require(school != address(0), "Invalid school address");
        require(bytes(_name).length > 0, "Student name is required");
        require(_id > 0, "Invalid student ID");
        require(_classNumber > 0, "Invalid class number");

        Register[] storage records = schoolRecords[school];

         // Prevent fraudulent cases where ID and class number are the same
        require(_id != _classNumber, "Fraud detected: ID must not match class number");

        // Check for duplicate ID incase of fraud
        for (uint256 i = 0; i < records.length; i++) {
            require(records[i].id != _id, "Student ID already exists for this school get the fuck you scam");
        }

        Register memory newStudent = Register({
            name: _name,
            id: _id,
            classNumber: _classNumber
        });

        records.push(newStudent);

        emit StudentRegistered(school, _name, _id, _classNumber);
    }

    /**
     Retrieve all students registered by the caller => school
     return Array of student records
     */
    function getAllStudentRecords() external view returns (Register[] memory) {
        return schoolRecords[msg.sender];
    }

    /**
      Retrieve a specific student by ID
     param _id The student's ID
     return The student record if found
     */
    function getStudentRecordById(uint256 _id) external view returns (Register memory) {
        Register[] memory records = schoolRecords[msg.sender];

        for (uint256 i = 0; i < records.length; i++) {
            if (records[i].id == _id) {
                return records[i];
            }
        }

        revert("Student with given ID not found");
    }

    /*
      Retrieve all students in a specific class
    param _classNumber The class number to search
    return Array of matching student records
     */
    function getStudentsByClass(uint256 _classNumber, uint256 _id) external view returns (Register[] memory) {
        Register[] memory records = schoolRecords[msg.sender];

        uint256 matchCount = 0;
    for (uint i = 0; i < schoolRecords[msg.sender].length; i++) {
    require(schoolRecords[msg.sender][i].id != _id, "Student ID already exists");
}


        Register[] memory matchedStudents = new Register[](matchCount);
        uint256 index = 0;

        for (uint256 i = 0; i < records.length; i++) {
            if (records[i].classNumber == _classNumber) {
                matchedStudents[index] = records[i];
                index++;
            }
        }

        return matchedStudents;
    }
}
