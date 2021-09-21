#!/bin/bash -e

RUN_TEST=0
CONFIGURATION=Release
PACKAGE_DIR=package
PROJECT=SimulationCSharpClient

die() {
  echo "ERROR: ${@}" 1>&2
  exit 1
}

show_help() {
  echo "USAGE: build.sh [options]"
  echo ""
  echo "OPTIONS:"
#   echo "  --coverage"
#   echo "    Calculate code coverage of unit tests, enables --test."
  echo "  --debug"
  echo "    Build with debugging information."
  echo "  -h | --help"
  echo "    Show this help page."
  echo "  --pkg-dir=<publish_directory>"
  echo "    Publish output to specified directory [${PUBLISH_DIR}]. Relative path will be under src/Azure."
  echo "  --test"
  echo "    Build and execute unit tests."
  echo ""
}

for i in "${@}"; do
  case "${i}" in
    # debug
    --debug)
    CONFIGURATION=Debug
    ;;
    # help
    -h|--help)
    show_help
    exit 0
    ;;
    # pkg-dir
    --pkg-dir=*)
    PACKAGE_DIR="${i#*=}"
    ;;
    # testing
    --test)
    RUN_TEST=1
    ;;
    # bad argument
    *)
    die "Unknown option '${i}'"
    ;;
  esac
done

if [[ "${RUN_TEST}" == "1" ]]; then
  echo "Running tests..."
  for t in test/*.Tests; do
    dotnet test ${t}
  done
fi

echo "Building nuget package"
dotnet pack -c ${CONFIGURATION} -o ${PACKAGE_DIR} src/${PROJECT}