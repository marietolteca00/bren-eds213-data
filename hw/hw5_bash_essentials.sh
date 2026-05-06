1. Compare the output of these three commands
`ls` - `a.csv   b.csv   c.csv   d.csv   e.csv`: `ls` refers to what files and subdirectories are in here
`ls .` - `a.csv   b.csv   c.csv   d.csv   e.csv`: The `ls .` refers to print a list of current directoy
`ls "$(pwd)/../for_bash_essentials"` - `a.csv   b.csv   c.csv   d.csv   e.csv`: $(pwd) is a command substitution, Bash runs pwd and replaces it with the full absolute path. The full string then becomes `/home/user/data/for_bash_essentials/../for_bash_essentials`. `..` navigates up to the parent directory, then `/for_bash_essentials` goes back down into the same folder. So ls ends up listing the same files as the previous commands `ls` and `ls .`

2. `wc -l *.csv` : Is a wildcard expansion, meaning that for every csv file in our current location, it will print out how many lines are in the files. This prints all the files because no specific files were listed, a wildcard (*) was used.
`cat *.csv | wc -l`: This is concatonating all the csvs in the files and counts the number of lines for all the csvs making one. This only prints a single number output because after the pipe (|) into wc-l. Since wc-l does not have a specific file name it will only print a single count with no filename

3. `wc -l a.csv` is given a filename argument, so it reads directly from a.csv and ignores the piped input from cat. It prints the line count and filename for a.csv only.

4. This didn't work because the computer thinks it is all one variable, when echo is ran, it prints nothing since it was not assigned to the name. In order to fix, this we have to add curly brackets to only name so the computer knows they are separate.
name=Moe
echo "${name}_Howard"

5. bash myscript.sh *.csv - 
$1 = is the first argument passed, since we are still in the for_essential_bash 
$# = There are 5 files. this is a special variable that holds the total count of arguments
The script does not use just one argument since the wildcard is used, it is passing all those files (total 5) before the script is ran.

6. bash myscript.sh "$(date)" $(date)
$1 = This prints out the whole date with time (ex. Tue May 5 14:09:17 PDT 2026) one argument
$3 = This will print out the third word in the date, in this case it would be '5' 

7. When the `>` operator was used, it overwrote my the current file and replaced it with a new one.
To sort: I did `sort junk_file.txt > temp.txt` : This made a sort copy of junk_file and exported reults to new txt.
Then followed that with `mv text.txt junk_file.txt` : Once i had the results i wanted, I added my results back into the junk_file txt with the move code.

8. `rm * .csv` Rm in this case would delete all the files in the directory. There are two arguments in this which is the wildcard (*) delete every file and then grab a file named .csv, if there no file names `.csv` it will throw an error about a file not being named that in the directory.