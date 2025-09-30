#!/bin/bash

# -------------------------------
# Setup AWS environment and CDK
# -------------------------------

# 1. Set AWS profile
export AWS_PROFILE=Aqib
echo "Using AWS profile: $AWS_PROFILE"

# 2. Get AWS account ID
AWS_ACCOUNT=$(aws sts get-caller-identity --query Account --output text 2>/dev/null)
if [ -z "$AWS_ACCOUNT" ]; then
    echo "❌ Unable to get AWS account. Make sure your profile '$AWS_PROFILE' exists and has valid credentials."
    exit 1
fi
export AWS_ACCOUNT
echo "AWS Account: $AWS_ACCOUNT"

# 3. Get AWS region from profile, default to us-east-1
AWS_REGION=$(aws configure get region)
AWS_REGION=${AWS_REGION:-us-east-1}
export AWS_REGION
echo "AWS Region: $AWS_REGION"

# 4. Bootstrap CDK environment
echo "Bootstrapping CDK environment..."
cd infra || { echo "Infra folder not found"; exit 1; }
npx cdk bootstrap aws://$AWS_ACCOUNT/$AWS_REGION

echo "✅ CDK bootstrap complete!"
echo "You can now run 'npm run synth' or 'npm run deploy'"
