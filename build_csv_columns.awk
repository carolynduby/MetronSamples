{ 
    sep = "" 
    for(i = 1; i <= NF; i++) { 
        if (length($i) > 0) { 
            printf "%s \"%s\" : %d", sep, $i, i-1; 
        } 
        sep = ","
    } 
    printf "\n"; 
}
