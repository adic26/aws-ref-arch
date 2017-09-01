#!/bin/bash
set -e


# print stdout/stderr to terminal and /var/log/messages
exec 1>> /var/log/messages 2>&1

# Constants
TRANSFER_HOST=$HOSTNAME

#nsnotify daemaon passes the following args in this order:
# 1.  name of the notified zone, 2. SOA serial number, 3. address of the master authority server to check for zone transfers

ZONE="$1"
SERIAL="$2"
SOURCE_IP=192.168.6.200

[ ! -z "$3" ] && SOURCE_IP="$3"

# download the synch control file to determine if this host is allowed to synch files.  Exit if control does not exist or does not contain this host
CONTROL_FILE="/tmp/route53-sync-host"
[ -f $CONTROL_FILE ] && rm $CONTROL_FILE

aws s3 cp s3://hbc-configs/bind-server/route53-synch-host $CONTROL_FILE

if [[ ! -f $CONTROL_FILE || $(grep -c -i $HOSTNAME $CONTROL_FILE) == 0 ]]
then
  echo "This host is not allowed to synch with Route 53.  Exiting"
  echo "Contents of control file $CONTROL_FILE: `cat $CONTROL_FILE`"
  exit 0;
fi

# check command line parameters
if [ -z "${ZONE}" -o -z "${SERIAL}" ]; then
  echo "Usage: $0 <zone> <serial> <authority-ip>" >&2
  echo "Was provided: $0 '$1' '$2' '$3'"
  exit 1
fi

ZONEFILE=`mktemp /tmp/${ZONE}.zonefile.XXX`
dig +noall +answer +onesoa +rrcomments @${SOURCE_IP} ${ZONE} axfr > ${ZONEFILE} 2>&1

# check for error messages in the transfer response to account for dig giving an exit code of 0 on some failures
if ! egrep "Transfer failed|connection timed out|Name or service not known|connection refused|network unreachable|host unreachable|end of file|communications error|couldn't get address" ${ZONEFILE} > /dev/null; then
  #extract serial from ZONEFILE
  SOA_SERIAL=$( cat ${ZONEFILE} | awk '{if ($4 == "SOA") print $7;}' | head -1 )

  if [ "$SOA_SERIAL" -eq "$SERIAL" ] 2>/dev/null; then
    SERIAL=$SOA_SERIAL
  else
    echo "SOA record not found in transferred zone, couldn't extract serial"
    exit
  fi

  # append a serial number record for troubleshooting
  echo -e "\serial.dynamic.${ZONE}. IN TXT \"${SERIAL}\"" >> ${ZONEFILE}

  # push into Route53
  cli53 import --file ${ZONEFILE} --replace ${ZONE}
fi

echo "Removing the zonefile"
rm ${ZONEFILE}
