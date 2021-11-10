sub(/^</, "") {
	gsub(/\\/, "\\\\")
	gsub(/\t/, "\\t")
	gsub(/</, "\t")
	commit = $0
	getline
	if (sub(/^\t[^,]* refs\//, "\t")) gsub(/,[^,]* refs\//, " ")
	commit = commit $0
	sep = "\t"
	while (getline && sub(/^ /, "")) {
		gsub(/\\/, "\\\\")
		gsub(/\t/, "\\t")
		gsub(/\r/, "\\r")
		commit = commit sep $0
		sep = "\\n"
	}
	print commit
	next
}
sub(/^--- /, "\t") {
	file = $0
	getline
	sub(/^\+\+\+ /, file "\t")
	print
	next
}
sub(/^@@ -/, "") {
	sub(/ @@ .*$/, "")
	sub(/\+/, "")
	for (i = 2; i; i--) if (!sub(/,/, "\t", $i)) $i = $i "\t1"
	print "\t\t" $0
	next
}
