function find_homes
{
  unset global HOMES_ARR
  declare -g -A HOMES_ARR
  local LIST_OF_HOMES=($(echo "cat //HOME[contains(@TYPE, \"O\")]/@LOC" | \
                         xmllint --shell \
                         $(grep '^inventory_loc=' /etc/oraInst.loc | \
                           cut -d= -f2)/ContentsXML/inventory.xml | \
                           grep 'LOC=' | \
                           sed 's/.*="\([^"]\+\)"/\1/'))
  for MYHOME in "${LIST_OF_HOMES[@]?}"; do
    local HOME_TYPE=$(echo "cat /PRD_LIST/TL_LIST/COMP/@NAME" | \
                      xmllint --shell $MYHOME/inventory/ContentsXML/comps.xml | \
                      grep 'NAME=' | \
                      sed 's/.*="\([^"]\+\)"/\1/')
    HOMES_ARR["${MYHOME?}"]="${HOME_TYPE}"
  done
}

function grid
{
  find_homes
  for MYHOME in ${!HOMES_ARR[@]}; do
    local HOMETYPE=${HOMES_ARR["${MYHOME}"]}
    if [ "${HOMETYPE}" = "oracle.crs" ]; then
      sed -e 's/${ORAENV_ASK:-""}/"NO"/' -e 's%^\s*ORAHOME=.*%ORAHOME="'${MYHOME}'"%' $(which oraenv) > /tmp/oraenv$PPID
      . /tmp/oraenv$PPID
      rm -f /tmp/oraenv$PPID
      export GRID_HOME="${MYHOME}"
    fi
  done
}

function crs
{
        grid
        crsctl status resource -t
}

function dbset
{
        local MYDB="$1"
        local MYSID="$2"
        local OLD_ASK="$ORAENV_ASK"

        if [ ! -n "$MYDB" ]; then
                echo -e "Provide the oracle SID as the first argument\n"
                return 1
        fi

        export ORAENV_ASK="NO"
        export ORACLE_SID="$MYDB"

        . oraenv

        [ -n "$MYSID" ] && export ORACLE_SID="$MYSID"

        export ORAENV_ASK="$OLD_ASK"
}

function cdo
{
        cd $ORACLE_HOME
}
