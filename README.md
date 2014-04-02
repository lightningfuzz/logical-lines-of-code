LLOC
========

###lloc.rb 
Counts logical lines of code in a C/C++ program using the following formula:  

    LLOC =      NPU         // Number of programming units: main program plus all functions  
              + NSC         // semi-colons in the whole program, except comments    
              + NEQ         // assignments within data definitions only (eg. int i = 5;)   
              + Nif         // all if statements  
              + Nswitch     // all switch statements  
              + Nwhile      // all while statements  
              + Nfor        // all for statements  
---
    Usage: "ruby lloc.rb [filename]"
     		  	
==
###countAll.rb  
A script that runs LLOC on all C/C++ files in a given directory.

    USAGE: "ruby countAll.rb [dir_name]"  

==
###Future Work
LLOC is currently written in a procedural programming style. In future work, it should be made to be more         object-oriented. 

