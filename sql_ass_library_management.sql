create database library_management;

use library_management;

-- Branch
create table library_branch(
library_branch_BranchID int auto_increment unique primary key,
library_branch_BranchName varchar(100) not null,
library_branch_BranchAddress varchar(100) not null);

select * from library_branch;

-- borrower
create table borrower(
borrower_CardNo int auto_increment primary key,
borrower_BorrowerName varchar(50),
borrower_BorrowerAddress varchar(100),
borrower_BorrowerPhone varchar(40));
select * from borrower;

-- publisher
create table publisher(
publisher_PublisherName varchar(100) primary key,
publisher_PublisherAddress varchar(100),
publisher_PublisherPhone varchar(40));
select * from publisher;

-- books
create table books(
book_BookID int auto_increment primary key,
book_Title text,
book_PublisherName varchar(50),
foreign key(book_PublisherName)
references publisher(publisher_PublisherName)
ON DELETE CASCADE
ON UPDATE CASCADE);
select * from books;

-- authors
drop table authors;
create table authors(
-- book_Authors_AuthorID int auto_increment primary key,
book_authors_BookID int,
book_authors_AuthorName varchar(100),
foreign key(book_authors_BookID)
references books(book_BookID));
ALTER TABLE authors
ADD COLUMN book_Authors_AuthorID INT AUTO_INCREMENT PRIMARY KEY;
select * from authors;

-- copies
drop table copies;
create table copies(
book_copies_BookID int not null,
book_copies_BranchID int not null,
book_copies_No_Of_Copies int not null,
foreign key(book_copies_No_Of_Copies)
references books(book_BookID)
on delete cascade
on update cascade,
foreign key(book_copies_BranchID)
references library_branch(library_branch_BranchID)
on delete cascade
on update cascade);
ALTER TABLE copies
ADD COLUMN book_copies_CopiesID INT AUTO_INCREMENT PRIMARY KEY;

select * from copies;

-- loans
drop table loans;
create table loans(
-- book_loans_LoansID int auto_increment primary key,
book_loans_BookID int,
book_loans_BranchID int not null,
book_loans_CardNo int not null,
book_loans_DateOut date,
book_loans_DueDate date,
foreign key(book_loans_BookID)
references books(book_BookID)
on delete cascade
on update cascade,
foreign key(book_loans_BranchID)
references library_branch(library_branch_BranchID)
on delete cascade
on update cascade,
foreign key(book_loans_CardNo)
references borrower(borrower_CardNo)
on delete cascade
on update cascade);
ALTER TABLE loans
ADD COLUMN book_loans_LoansID INT AUTO_INCREMENT PRIMARY KEY;
select * from loans;


-- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select b.book_Title,lb.library_branch_BranchName,sum(c.book_copies_No_Of_Copies) as No_Of_Copies
from copies as c
inner join books as b on c.book_copies_BookID = b.book_BookID
join library_branch as lb on c.book_copies_BranchID = lb.library_branch_BranchID
where b.book_Title = "The Lost Tribe"
and lb.library_branch_BranchName = "Sharpstown";


-- 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select b.book_Title,lb.library_branch_BranchName as branch_name,count(c.book_copies_No_Of_Copies) as No_Of_Copies
from copies as c
inner join books as b on c.book_copies_BookID = b.book_BookID
join library_branch as lb on c.book_copies_BranchID = lb.library_branch_BranchID
where b.book_Title = "The Lost Tribe"
group by lb.library_branch_BranchName;


-- 3.Retrieve the names of all borrowers who do not have any books checked out.
select borrower_BorrowerName
from borrower as b
left join loans as l
ON b.borrower_CardNo = l.book_loans_CardNo
WHERE l.book_loans_CardNo is null;


-- 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, 
-- retrieve the book title, the borrower's name, and the borrower's address.
select b.book_Title,borrow.borrower_BorrowerName,borrow.borrower_BorrowerAddress
from books as b
join loans as l on l.book_loans_BookID = b.book_BookID
join library_branch as lb on l.book_loans_BranchID = lb.library_branch_BranchID
join borrower as borrow on borrow.borrower_CardNo = l.book_loans_CardNo
where l.book_loans_DueDate = '2/3/18' and lb.library_branch_BranchName = "Sharpstown";


-- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select lb.library_branch_BranchName,count(*) as toal_loans
from loans as l
join library_branch as lb 
on l.book_loans_BranchID = lb.library_branch_BranchID
join books as b on b.book_BookID = l.book_loans_BookID
group by  lb.library_branch_BranchName;


select * from books;
-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select br.borrower_BorrowerName,br.borrower_BorrowerAddress,count(b.book_BookID) as no_of_books
from books as b
join loans as l on b.book_BookID = l.book_loans_BookID
join borrower as br on l.book_loans_CardNo = br.borrower_CardNo
group by br.borrower_BorrowerName,br.borrower_BorrowerAddress
having no_of_books > 5;


-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
select b.book_Title,c.book_copies_No_Of_Copies
from books as b
join authors as a on a.book_authors_BookID = b.book_BookID
join copies as c on b.book_BookID = c.book_copies_BookID
join library_branch as lb on c.book_copies_BranchID = library_branch_BranchID
where a.book_authors_AuthorName = 'Stephen King' and lb.library_branch_BranchName = 'Central';
