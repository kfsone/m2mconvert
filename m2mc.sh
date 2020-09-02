# Convert videos using the docker container.

DOCKER_IMAGE="${DOCKER_IMAGE:-kfsone/m2mconvert:latest}"
infile="${1:-}"
outfile="${2:-}"

function usage () {
	echo >&2 "Usage: $0 <source movie> <destination movie>"
	exit 1
}

if [ -z "${outfile}" -o -z "${infile}" ]; then
	usage
fi

case "${infile}" in
	-h|--help|-\?)
		usage
	;;
esac

function die {
	echo "ERROR: $*"
	exit 1
}

if [ ! -f "${infile}" ]; then
	die "'${infile}' does not exist."
fi
if [ -f "${outfile}" ]; then
	die "'${outfile}' already exists."
fi

infile="$(realpath "${infile}")"
infilename="$(basename "${infile}")"
extension="${infilename##*.}"
if [ -z "${extension}" ]; then
	die "input filename must include an extension (e.g file.mov)"
fi
inputdir="$(dirname "${infile}")"

outfilename="$(basename "${outfile}")"
extension="${outfilename##*.}"
if [ -z "${extension}" ]; then
	die "output filename must include an extension (e.g. file.mp4)"
fi
outputdir="$(dirname "${outfile}")"
if [ ! -d "${outputdir}" ]; then
	die "output directory '${outputdir}' does not exist."
fi
outputdir="$(realpath "${outputdir}")"

docker run \
  --rm \
  -v "${inputdir}:/mnt/src" \
  -v "${outputdir}:/mnt/dst" \
  	"${DOCKER_IMAGE}" \
    -input "/mnt/src/${infilename}" \
    -output "/mnt/dst/${outfilename}"
