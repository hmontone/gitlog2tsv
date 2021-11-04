git log --format='<%H<%P<%aN<%aE<%aI<%cN<%cE<%cI%n%x09%D%n%w(0,1,1)%B'\
	--decorate=full -U0 --output-indicator-old=# | awk -P '
	sub(/^</, "") {
		gsub(/\\/, "\\\\")
		gsub(/\t/, "\\t")
		gsub(/</, OFS)
		commit = $0
		getline
		if (sub(/^\t[^,]* refs\//, OFS))
			gsub(/,[^,]* refs\//, " ")
		commit = commit $0
		sep = OFS
		while (getline && sub(/^ /, "")) {
			gsub(/\\/, "\\\\")
			gsub(/\t/, "\\t")
			commit = commit sep $0
			sep = "\\n"
		}
		print commit
		next
	}
	sub(/^--- (a\/)?/, "") {
		file = OFS $0
		getline
		sub(/^[+]{3} (b\/)?/, "")
		print file, $0
		next
	}
	sub(/^@@ -/, "") {
		sub(/ @@ .*$/, "")
		sub(/[+]/, "")
		for (i = 2; i; i--)
			if (!sub(/,/, "\t", $i)) $i = $i OFS 1
		print OFS, $0
		next
	}' OFS='\t'
