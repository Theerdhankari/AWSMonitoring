#!/bin/bash

# Set your variables
INSTANCE_ID="your-instance-id"
THRESHOLD=80
EVALUATION_PERIODS=5
ALARM_NAME="HighCPUUtilization-$INSTANCE_ID"
SNS_TOPIC_ARN="your-sns-topic-arn"

# Create the CloudWatch alarm for high CPU utilization
aws cloudwatch put-metric-alarm \
  --alarm-name "$ALARM_NAME" \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --evaluation-periods $EVALUATION_PERIODS \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --period 60 \
  --statistic SampleCount \
  --threshold $THRESHOLD \
  --alarm-actions "$SNS_TOPIC_ARN" \
  --alarm-description "Alarm for high CPU utilization on instance $INSTANCE_ID" \
  --dimensions "Name=InstanceId,Value=$INSTANCE_ID" \
  --unit Percent