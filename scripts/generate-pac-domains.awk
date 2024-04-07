{
    domainzone = gensub(/(.*)\.([^.]+$)/, "\\2", 1)
    domainname = gensub(/(.*)\.([^.]+$)/, "\\1", 1)
}
    @include "temp/replace-common-sequences.awk"
{
    domainlength = length(domainname)
    domainarray[domainzone][domainlength][domainname] = domainname
    #print "adding", $0, ":", domainzone, domainlength, domainname
}


function printarray(arrname, arr) {
    firsttime_1 = 1
    firsttime_2 = 1

    print arrname, "= {"

    for (domainzone in arr) {
        if (firsttime_1 == 0) {printf ",\n"} firsttime_1 = 0;

        printf "\"" domainzone "\":{"

        for (domainlength in arr[domainzone]) {
            if (firsttime_2 == 0) {printf ","} firsttime_2 = 0;

            printf "%s", "" domainlength ":"
            printf "%d", length(arr[domainzone][domainlength]) * domainlength
            #for (domainname in arr[domainzone][domainlength]) {
            #    printf "%d", length(domainname)
            #}
            #printf "\""
        }

        firsttime_2 = 1;
        printf "}"
    }
    print "};"
}

function printarray_oneline(arr) {
    for (domainzone in arr) {
        for (domainlength in arr[domainzone]) {
            for (domainname in arr[domainzone][domainlength]) {
                printf "%s", domainname
            }
        }
    }
}

# Final function
END {
    if (lzp) {
        printarray_oneline(domainarray)
    } else {
        printarray("domains", domainarray)
    }
}
