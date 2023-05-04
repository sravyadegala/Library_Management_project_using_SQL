library_management_project_using_SQL:
    Key things to consider while creating database:
          Add auto increment constraint in all the table’s primary keys.
          Make sure you are using cascade and not null actions while creating foreign keys in all the tables.
          While importing the data carefully check whether the column names are matching to csv file column names or not.
Task Questions
1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?
3. Retrieve the names of all borrowers who do not have any books checked out.
4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's    address. 
5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
