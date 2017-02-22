# url: http://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo_c () {
	echo -e "${RED}$1${NC}"
}

echo_w () {
	echo -e "${YELLOW}$1${NC}"
}

USE_TUPLES_LIST() {
	# url: http://stackoverflow.com/a/9713189
	# $1: list tuples ((value0, value1) (value0, value1) ...)
	# $2: echo bash instruction							($1: value0, $2: value1)
	# $3: sh command (using bash parameters (results))	($1: value0, $2: value1)
	TUPLES=$1
	CALLBACK_ECHO=$2
	CALLBACK_CMD=$3

	# on retire les espaces, retours lignes, tabM
	TUPLES=$(echo "$TUPLES" | sed 's/ //g' | tr -d '\n' | tr -d '\t')
	# echo "TUPLES: ${TUPLES}"

	IFS='()'
	for t in $TUPLES; do
		[ -n "$t" ] &&
		{
			IFS=','
			set -- $t
			[ -n "$1" ] &&
			eval $CALLBACK_ECHO
			eval $(eval echo '$CALLBACK_CMD')	# ok
			# wstool set -y $1 --git $2	# ok
		};
	done
}