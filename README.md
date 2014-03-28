LLOC
========

#####lloc.rb counts logical lines of code in a C/C++ program using the following formula:
> LLOC = NPU ----- Number of programming units: main program plus all functions  
    \+ NSC -------- semi-colons in the whole program, except comments    
    \+ NEQ -------- assignments within data definitions only (eg. int i = 5;)   
    \+ Nif ----------- all if statements  
    \+ Nswitch ---- all switch statements  
    \+ Nwhile ------ all while statements  
    \+ Nfor	--------- all for statements  
     		  	

#####countAll.rb is a script that runs LLOC on all C/C++ files in a given directory. 
> USAGE: "ruby coutAll.rb [dir_name]"
