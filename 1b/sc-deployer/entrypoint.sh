#!/bin/sh

set -e

echo "🚀 Starting smart contract deployment..."

# geth-init 완료 대기
echo "⏳ Waiting for geth-init to complete prefunding..."
until [ -f "/shared/geth-init-complete" ]; do
  sleep 1
done
echo "✅ Prefunding completed, proceeding with deployment..."

# 작업 경로가 /app이므로, /app 내부에 프로젝트 클론
echo "📥 Cloning repository..."
git clone https://github.com/DrGhost-Dev/cohort-1-assignments-public.git 
cd cohort-1-assignments-public



# Navigate to the 1a directory

cd 1a



# 의존성 설치
echo "📦 Installing dependencies..."
forge install

# 프로젝트 빌드
echo "🔨 Building project..."
forge build

# 컨트랙트 배포 (Private Key는 환경 변수에서 가져옴)
echo "🚀 Deploying MiniAMM contracts..."
forge script script/MiniAMM.s.sol:MiniAMMScript \
    --rpc-url http://geth:8545 \
    --private-key cb479f3aed51419828e9b2a4af880c758b9cbf4bcb34108514aa1897c22bd558\
    --broadcast

echo "✅ Deployment completed!"

# 주소 추출 스크립트 실행 (작업 경로 기준)
echo "📝 Extracting contract addresses..."
node /app/extract-addresses.js

echo "✅ All done! Check deployment.json for contract addresses."