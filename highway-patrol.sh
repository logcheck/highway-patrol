#!/bin/sh

# DEFAULTS
RECORD_TTL="300"
RECORD_TYPE="A"

# LOAD CONFIGURATION
source $1

PUBLIC_IP_CACHE="/Library/Caches/com.logcheck.highway-patrol.${DOMAIN_NAME}.ip"

PUBLIC_IP_ADDR=`curl --fail --silent https://icanhazip.com/`
if [ $? != 0 ]; then
	echo "Failed to retrieve public IP address."
	exit 1
fi

if [ -f "$PUBLIC_IP_CACHE" ]; then
	CACHED_IP_ADDR=`cat $PUBLIC_IP_CACHE`
	if [ "$PUBLIC_IP_ADDR" == "$CACHED_IP_ADDR" ]; then
		echo "IP address ${PUBLIC_IP_ADDR} for ${DOMAIN_NAME} is up-to-date."
		exit 0
	fi
fi

echo "Updating ${DOMAIN_NAME} with IP address ${PUBLIC_IP_ADDR}."

COMMENT="highway-patrol: `date`"

JSON_FILE=`mktemp -t com.logcheck.highway-patrol.${DOMAIN_NAME}`
cat > $JSON_FILE << EOF
{
	"Comment": "$COMMENT",
	"Changes": [{
		"Action": "UPSERT",
		"ResourceRecordSet": {
			"ResourceRecords": [{
					"Value": "$PUBLIC_IP_ADDR"
			}],
			"Name": "$DOMAIN_NAME",
			"Type": "$RECORD_TYPE",
			"TTL": $RECORD_TTL
		}
	}]
}
EOF

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
aws route53 change-resource-record-sets \
    --hosted-zone-id $AWS_HOSTED_ZONE_ID \
    --change-batch "file://${JSON_FILE}"
if [ $? == 0 ]; then
	# Cache public IP address for later
	echo $PUBLIC_IP_ADDR > "$PUBLIC_IP_CACHE"
fi

# Clean up
rm $JSON_FILE
