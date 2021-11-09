if [ -z "$GIT_DIR" ]
then
	if [ -z "$1" ]
	then
		export GIT_DIR="$(git rev-parse --absolute-git-dir)" ||
			exit $?
	else
		export GIT_DIR="$(basename "$1" .git).git"
	fi
fi
if [ -n "$1" ]
then
	git clone -q --bare "$1" 2>/dev/null || git fetch -q || exit $?
fi
git log --all -U0 --no-prefix\
	--format='<%H<%P<%aN<%aE<%aI<%cN<%cE<%cI%n%x09%D%n%w(0,1,1)%B'\
	--decorate=full --output-indicator-old=#|awk -f "${0%.sh}.awk"|
	gzip|tee "${GIT_DIR%/.git}.tsv.gz"|cksum>&2
