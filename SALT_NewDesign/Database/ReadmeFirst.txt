To create (or re-create) the salt database on your machine the following steps must be performed.

* Caution * 
Following these instructions will * Destroy * the Salt database on the server that is entered.
If you wish to keep this database then it will have to be backed up before running this script.

1. Get latest version of the database project.

2. Create the salt_user login in the sql server 
    (This is trickier on MSDE - use the SALT.DBS,salt_user.LGN and salt_user.USR scripts manually)

3. Make any necessary changes the stored procedures/views/functions etc in the individual scripts attached to this project.
 
4. Save all changes

5. If any new tables / stored proc / views etc were added them add their name to the appropriate section in "RecreateDatabasec.cmd"

6. Ensure that the "Complete Script files are checked out"

7. Right Click the "Recreate Databasec.cmd" file and select "Run"

8. Enter the hostname of the server to recreate the database on.

9. Remember to run the load data script from the deployment package to populate the database with the static data required.

10. If you want to use the saltadmin account then you will need to adjust its username, password