# AWSMonitoring
Monitoring Python script
import boto3

# Initialize the CloudWatch and CloudTrail clients
cloudwatch = boto3.client('cloudwatch')
cloudtrail = boto3.client('cloudtrail')

# Create a CloudWatch alarm for high CPU utilization on EC2 instances
def create_cpu_alarm(instance_id, threshold, evaluation_periods, alarm_actions):
    cloudwatch.put_metric_alarm(
        AlarmName=f'HighCPUUtilization-{instance_id}',
        ComparisonOperator='GreaterThanOrEqualToThreshold',
        EvaluationPeriods=evaluation_periods,
        MetricName='CPUUtilization',
        Namespace='AWS/EC2',
        Period=60,
        Statistic='SampleCount',
        Threshold=threshold,
        ActionsEnabled=True,
        AlarmActions=alarm_actions,
        AlarmDescription=f'Alarm for high CPU utilization on instance {instance_id}',
        Dimensions=[
            {
                'Name': 'InstanceId',
                'Value': instance_id
            }
        ],
        Unit='Percent'
    )

# Monitor CloudTrail events for specific actions
def monitor_cloudtrail_events(event_name, sns_topic_arn):
    response = cloudtrail.lookup_events(
        LookupAttributes=[
            {
                'AttributeKey': 'EventName',
                'AttributeValue': event_name
            }
        ]
    )

    for event in response['Events']:
        print(f"Event: {event['EventName']} - {event['EventTime']}")
        # Send a notification to the specified SNS topic
        sns = boto3.client('sns')
        sns.publish(
            TopicArn=sns_topic_arn,
            Message=f"Event: {event['EventName']} - {event['EventTime']}",
            Subject=f"Notification for {event_name} event"
        )

# Example usage
instance_id = 'your-instance-id'
threshold = 80
evaluation_periods = 5
sns_topic_arn = 'your-sns-topic-arn'

create_cpu_alarm(instance_id, threshold, evaluation_periods, [sns_topic_arn])
monitor_cloudtrail_events('StartInstances', sns_topic_arn)
