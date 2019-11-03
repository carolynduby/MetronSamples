{
    sep = ""
    for(i = 1; i <= NF; i++) {
       field = ""
       if ($i == "GlobalRank" ) {
           field = "rank"
       } else if ($i == "Domain" ) {
           field = "domain"
       }
       printf "%s%s", sep, field;
       sep = ","
    }
    printf "\n";
}
