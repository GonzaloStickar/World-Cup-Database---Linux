  Required:
  
    Install psql:
      $ sudo apt-get install psql
    To Initialize psql ( Problems to initialize psql might probably be solved on solution B) ):
      psql --username=username --dbname=databasename
        Replace "username" with your username that you are using, or you will use.
        Replace "database" with your databasename that you are using, or you will use.



  Problems related with opening psql:
  
  A) Connection refused.
  
    psql: error: connection to server at "<host_ip>", port "port" failed: Connection refused
    Is the server running on that host and accepting TCP/IP connections?
  
    Solution: 
    Credit: https://stackoverflow.com/questions/32439167/psql-could-not-connect-to-server-connection-refused-error-when-connecting-to
    Step by step:
    
      1- Open file named "postgresql.conf"
      
        1.1) Located "/etc/postgresql/<version>/main/"
          1.1.1) How to find the route to the file ( if we wouldn't know 1.1) ):
            $ sudo find / -type f -name "name_of_file"
        1.2) Open file named "postgresql.conf" by going to 1.3)
        1.3) $ sudo vi postgresql.conf
        Using "vi" to edit (We can also use "nano" if we want)
          1.3.1) To find it:
            $ sudo find / -type f -name "postgresql.conf"
          1.3.2) Once it is found, you must open it ( Copy and Paste the exact location (Folders) ):
            $ sudo vi /etc/postgresql/<version>/main/postgresql.conf
        1.4) Once opened, scroll down to the bottom and add this line (Without modifying anything else)
            listen_addresses = '*'
          1.4.1) To add it:
            Press key "i" to insert a line where you are selecting.
            It should look something like this: 
              Data
              listen_addresses = '*'
          1.4.2) To save the file
            1.4.1) Press "ESC"
            1.4.2) Press ":wq"
            1.4.3) Press "ENTER"
        
      2- Open file named "pg_hba.conf"
      
        2.1) Located /etc/postgresql/<version>/main/pg_hba.conf
          2.1.1) How to find the route to the file ( if we wouldn't know 1.1) ):
            $ sudo find / -type f -name "name_of_file"
        2.2) Open file named "pg_hba.conf" by going 2.3)
        2.3) $ sudo vi pg_hba.conf
          Using "vi" to edit (We can also use "nano" if we want)
          2.3.1) To find it:
            $ sudo find / -type f -name "pg_hba.conf"
          2.3.2) Once it is found, you must open it ( Copy and Paste the exact location (Folders) ):
            $ sudo vi /etc/postgresql/<version>/main/pg_hba.conf
        2.4) Once opened, scroll down to the bottom and add this line (Without modifying anything else)
            host  all  all 0.0.0.0/0 md5
          2.4.1) To add it:
            Press key "i" to insert a line where you are selecting.
            It should look something like this: 
              Data...
              host  all  all 0.0.0.0/0 md5
          2.4.2) To save the file
            2.4.1) Press "ESC"
            2.4.2) Press ":wq"
            2.4.3) Press "ENTER"
          2.4.3) Extra - Explanation of added line:
            host: Indicates that we are configuring an access rule for connections via TCP/IP. 
            all: Indicates that the rule applies to all databases. 
            all: Indicates that the rule applies to all users. 
            0.0.0.0/0: Indicates that the rule allows connections from any IP address. 
            md5: Indicates that authentication is performed using the MD5 authentication method, which is a secure authentication method using encrypted passwords.
            
      3- Restart psql server
      
        $ sudo /etc/init.d/postgresql restart
  
  
    
  B) Role of user does not exist in your psql server.
  
    psql --username=username --dbname=databasename
    psql: error: connection to server at <host_ip>, port "port" failed: FATAL:  role "username" does not exist
    
    Solution:
    Step by step:
    
      1) Copy and Paste this line in your terminal / console
          1.1) Initialize psql
            $ psql -U postgres
          1.2) You can create a database:
            CREATE DATABASE databasename;
      2) Copy and Paste this line in your terminal / console (your_password ( Generate a password that you will remember) )
        CREATE ROLE username WITH LOGIN PASSWORD 'your_password';
      3) Connect to your database with:
        $ psql --username=username --dbname=databasename
          Replace "username" with your username that you are using, or you will use.
          Replace "database" with your databasename that you are using, or you will use.
      4) Extra - Give all privileges to your "username"
        GRANT ALL PRIVILEGES ON DATABASE databasename TO username;
      5) Extra - To exit psql, type in terminal / console
          \q
  C) Change files permissions ( ".sh" it's used as an example, you can do it with every file ).

    Permissions:
      +r
        Read file.
      +x
        Excecute file.
      +a
        Gives access to someone or all users.
    
    1) Using + will add
    2) Using - will demote

    Example of use:
    chmod +x file.sh

    Example of use in 2 different files:
    chmod +x file1.sh file2.sh



Requirements for this project assigned:

- You should create a database named worldcup
- You should connect to your worldcup database and then create teams and games tables
- Your teams table should have a team_id column that is a type of SERIAL and is the primary key, and a name column that has to be UNIQUE
- Your games table should have a game_id column that is a type of SERIAL and is the primary key, a year column of type INT, and a round column of type VARCHAR
- Your games table should have winner_id and opponent_id foreign key columns that each reference team_id from the teams table
- Your games table should have winner_goals and opponent_goals columns that are type INT
- All of your columns should have the NOT NULL constraint
- Your two script (.sh) files should have executable permissions. Other tests involving these two files will fail until permissions are correct. When these permissions are enabled, the tests will take significantly longer to run
- When you run your insert_data.sh script, it should add each unique team to the teams table. There should be 24 rows
- When you run your insert_data.sh script, it should insert a row for each line in the games.csv file (other than the top line of the file). There should be 32 rows. Each row should have every column filled in with the appropriate info. Make sure to add the correct ID's from the teams table (you cannot hard-code the values)
- You should correctly complete the queries in the queries.sh file. Fill in each empty echo command to get the output of what is suggested with the command above it. Only use a single line like the first query. The output should match what is in the expected_output.txt file exactly, take note of the number of decimal places in some of the query results
