FMT='<%H<%P<%aN<%aE<%aI<%cN<%cE<%cI%n%x09%D%n%w(0,1,1)%B'
ARG="--format='$FMT' --decorate=full -U0 --output-indicator-old=#"
PRG='BEGIN { OFS = "\t" }
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
}'
if [ -n "$1" ]
then
	export GIT_DIR=$(basename "$1" .git)/.git
fi
if [ -n "$GIT_DIR" ]
then
	if [ -d $GIT_DIR ]
	then
		git pull -q
	else
		git clone -q "$1"
	fi
	git log $ARG | awk "$PRG" | gzip | tee "${GIT_DIR%/.git}.tsv.gz" | cksum >&2
else
	while read -r repo
		do time -p sh -x $0 $repo
	done
fi
