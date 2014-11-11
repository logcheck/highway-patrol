Highway Patrol
--------------

A dynamic DNS enforcer for Amazon Route 53.

Very loosely based on [a bash script by Will Warren][1].

[1]: http://willwarren.com/2014/07/03/roll-dynamic-dns-service-using-amazon-route53/

It is recommended that you create an IAM user with minimal privileges, and use
its access key for this script. A minimal policy is:

    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "Stmt1415657277000",
          "Effect": "Allow",
          "Action": [
            "route53:ChangeResourceRecordSets"
          ],
          "Resource": [
            "arn:aws:route53:::hostedzone/${HOSTEDZONEID}"
          ]
        }
      ]
    }
