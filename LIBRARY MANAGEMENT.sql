CREATE DATABASE LIBRARYMANDB;
USE LIBRARYMANDB;

CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress TEXT,
    publisher_PublisherPhone VARCHAR(15)
);

SELECT * FROM TBL_PUBLISHER;

desc TBL_PUBLISHER;

CREATE TABLE tbl_book (
    book_BookID INT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
);

SELECT * FROM tbl_book;
desc tbl_book;

-- Table: tbl_book_authors
CREATE TABLE tbl_book_authors(
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(255),
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID)
);
SELECT * FROM tbl_book_authors;
desc tbl_book_authors;
-- DROP TABLE tbl_book_authors;

-- Table: tbl_library_branch
CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress TEXT
);

SELECT * FROM tbl_library_branch;
desc tbl_library_branch;

-- Table: tbl_book_copies
CREATE TABLE tbl_book_copies (
    book_copies_CopiesID INT PRIMARY KEY AUTO_INCREMENT,
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
);

SELECT * FROM tbl_book_copies;
desc tbl_book_copies;
-- DROP TABLE tbl_book_copies;

-- Table: tbl_borrower
CREATE TABLE tbl_borrower (
    borrower_CardNo INT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress TEXT,
    borrower_BorrowerPhone VARCHAR(15)
);
SELECT * FROM tbl_borrower;
desc tbl_borrower;


-- Table: tbl_book_loans
CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut DATE,
    book_loans_DueDate DATE,
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID),
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
);

SELECT * FROM tbl_book_loans;
desc tbl_book_loans;

SELECT * FROM TBL_BOOK WHERE BOOK_TITLE = "THE LOST TRIBE";


-- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
SELECT BC.book_copies_No_Of_Copies  FROM TBL_BOOK_COPIES BC
JOIN TBL_BOOK B 
ON BC.BOOK_COPIES_BOOKID = B.book_BookID
JOIN TBL_LIBRARY_BRANCH LB
ON BC.book_copies_BranchID = LB.library_branch_BranchID
WHERE B.book_Title = "THE LOST TRIBE"
AND library_branch_BranchName = "Sharpstown";


-- 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?

SELECT BC.book_copies_No_Of_Copies, LB.library_branch_BranchName FROM TBL_LIBRARY_BRANCH LB
JOIN TBL_BOOK_COPIES BC
ON LB.library_branch_BranchID = BC.book_copies_BranchID
JOIN TBL_BOOK B 
ON BC.BOOK_COPIES_BOOKID = B.book_BookID
WHERE B.book_Title = "THE LOST TRIBE";

-- 3. Retrieve the names of all borrowers who do not have any books checked out.

SELECT TB.borrower_BorrowerName FROM tbl_borrower TB
LEFT JOIN tbl_book_loans BL
ON BL.book_loans_CardNo = TB.borrower_CardNo
WHERE book_loans_CardNo IS NULL;


-- 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, 
-- retrieve the book title, the borrower's name, and the borrower's address. 

SELECT TB.book_Title, TBW.borrower_BorrowerName, TBW.borrower_BorrowerAddress
FROM tbl_book_loans TBL
JOIN tbl_borrower TBW
ON TBL.book_loans_CardNo = TBW.borrower_CardNo
JOIN tbl_book TB
ON TB.book_BookID = TBL.book_loans_BookID
JOIN tbl_library_branch TLB
ON TLB.library_branch_BranchID = TBL.book_loans_BranchID
WHERE library_branch_BranchName = 'Sharpstown'
AND book_loans_DueDate = '2/3/18';

-- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
SELECT TLB.library_branch_BranchName, COUNT(*) FROM tbl_library_branch TLB
JOIN tbl_book_loans TBL
ON TBL.book_loans_BranchID = TLB.library_branch_BranchID
GROUP BY library_branch_BranchName;
-- HAVING library_branch_BranchName = "Ann Arbor";

-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

SELECT TB.borrower_BorrowerName, TB.borrower_BorrowerAddress, COUNT(TB.borrower_CardNo) AS NO_OF_BOOKS_CHECKED_OUT FROM tbl_borrower TB
JOIN tbl_book_loans TBL
ON TBL.book_loans_CardNo = TB.borrower_CardNo
GROUP BY borrower_CardNo
HAVING COUNT(borrower_CardNo)>5;

-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
SELECT TB.book_Title, TLB.library_branch_BranchName,tbc.book_copies_No_Of_Copies, book_authors_AuthorName from  tbl_book TB
join tbl_book_copies TBC
ON TBC.book_copies_BookID = TB.book_BookID
JOIN tbl_library_branch TLB
ON TLB.library_branch_BranchID = TBC.book_copies_BranchID
JOIN tbl_book_authors TBA
ON TBA.book_authors_BookID = TB.book_BookID
WHERE library_branch_BranchName = 'Central'
AND TBA.book_authors_AuthorName = 'Stephen King';

