# Convert videos using the docker container.

Param(
  [Parameter(Mandatory=$true, Position=0, HelpMessage="Specify the local path to the input file.")]
  [String]
  $InputFile,

  [Parameter(Mandatory=$true, Position=1, HelpMessage="Specify the local path and filename for the converted video.")]
  [String]
  $OutputFile,

  [Parameter(HelpMessage="Specify which docker image to use for the operation.")]
  [String]
  $DockerImage = "kfsone/m2mconvert:latest",

  [Parameter(HelpMessage="Foricbly rebuild the docker image locally.")]
  [Switch]
  $RebuildImage,

  [Parameter(HelpMessage="Proceed even if -OutputFile exists.")]
  [Switch]
  $Force
)

# Check the input file exists.
$p = Resolve-Path $InputFile -ErrorAction Stop

$OutputFilename = Split-Path -Leaf $OutputFile
$OutputExt = Split-Path -Extension $OutputFilename
if (!$OutputExt) {
  $Host.UI.WriteErrorLine("ERROR: -OutputFile needs to include an extension.")
  exit 1
}

$InputFilename = Split-Path -Leaf $InputFile
$InputExt = Split-Path -Extension $InputFilename
if (!$InputExt) {
  $Host.UI.WriteErrorLine("ERROR: -InputFile needs to include an extension.")
  exit 1
}

$OutputPath = Split-Path -Parent $OutputFile
if (!$OutputPath) {
  $OutputPath = "."
}
$OutputPath = (Resolve-Path $OutputPath -ErrorAction stop).Path
if (Resolve-Path $OutputPath -ErrorAction Ignore) {
  if (!$Force) {
    $Host.UI.WriteErrorLine("ERROR: -OutputFile exists. Remove or use -Force.")
    exit 1
  }
}

$InputPath = Split-Path -Parent $InputFile
if (!$InputPath) {
  $InputPath = "."
}
$InputPath = (Resolve-Path $InputPath -ErrorAction stop).Path

if ($RebuildImage) {
  docker build --tag ${DockerImage} .
}

docker run `
  --rm `
  -v "${InputPath}:/mnt/src" `
  -v "${OutputPath}:/mnt/dst" $DockerImage `
    -input /mnt/src/$InputFilename `
    -output /mnt/dst/$OutputFilename
