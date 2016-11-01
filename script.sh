#!/bin/bash
# ------------------------------------------------------------------
# [www.joss.manger] REACTOR CORE
#          Fuel Rod
# ------------------------------------------------------------------

VERSION=0.0.1
SUBJECT=fuel-rod
USAGE="Usage: command -ihv args"

# --- Options processing -------------------------------------------
if [ $# == 0 ] ; then
  echo $USAGE
  exit 1;
fi

while getopts ":i:vh" optname
do
  case "$optname" in
    "v")
    echo "Version $VERSION"
    exit 0;
    ;;
    "i")
    echo "-i argument: $OPTARG"
    ;;
    "h")
    echo $USAGE
    exit 0;
    ;;
    "?")
    echo "Unknown option $OPTARG"
    exit 0;
    ;;
    ":")
    echo "No argument value for option $OPTARG"
    exit 0;
    ;;
    *)
    echo "Unknown error while processing options"
    exit 0;
    ;;
  esac
done

shift $(($OPTIND - 1))

param1=$1
param2=$2

# --- Locks -------------------------------------------------------
LOCK_FILE=/tmp/$SUBJECT.lock
if [ -f "$LOCK_FILE" ]; then
  echo "Script is already running"
  exit
fi

trap "rm -f $LOCK_FILE" EXIT
touch $LOCK_FILE

# --- Functions -------------------------------------------------------
function opts-concat {
  RESOURCE_TYPE=$1"s";
  RESOURCE_PATH=$2;
  STR="";
  presets_length=$(cat package.json | json $RESOURCE_PATH.length);
  START=0;
  END=$presets_length;
  for (( i=$START; i<$END; i++ ))
  do
    preset=$(cat package.json | json $RESOURCE_PATH[$i]);
    STR=$STR$RESOURCE_TYPE"[]="$preset
    if [[ $i<$(($END-1)) ]]; then
      STR=$STR",";
    fi
  done
  echo $STR
}




# --- Body --------------------------------------------------------

# ---Concat of variables
modules=$(opts-concat "preset" "config.presets.react");
plugins=$(opts-concat "plugin" "config.presets.plugins");

ENV=$npm_package_config_target_dir;

webpack_opts="$npm_package_config_webpack_opts --module-bind js=babel?$modules,$plugins,ignore=node_modules,cacheDirectory $npm_package_config_source_dir/$npm_package_config_source_js $npm_package_config_target_dir/$npm_package_config_target_js"

if [ "$param1" = "build" ]; then
  echo "running build task"
  #echo "webpack $webpack_opts";
  webpack $webpack_opts;
  cp $npm_package_config_source_dir/index.html $npm_package_config_target_dir
  exit
elif [ "$param1" = "watch" ]; then

  function watch {
    echo -e "Watching..."

    webpack --watch ${webpack_opts} &
    browser-sync start --files ${ENV} --server ${ENV}
  }

  # Check folder being watched exists
  if [ -d "${ENV}" ]; then
    echo "running watch task"
    watch
  else
    npm run build && watch
  fi

  exit
elif [ "$param1" = "dist" ]; then
  echo "running dist task"
  exit
else
  echo "No argument value for option \"$param1\""
  exit 1;
fi



# -----------------------------------------------------------------
