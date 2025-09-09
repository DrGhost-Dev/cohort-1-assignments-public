#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// 입력 파일 경로: /app/project/1a/broadcast/...
const broadcastPath = path.join('/app', 'cohort-1-assignments-public', '1a', 'broadcast', 'MiniAMM.s.sol', '11155111', 'run-latest.json');

// 출력 파일 경로: sc-deployment-server와 공유될 /deployment 폴더
const outputPath = path.join('/deployment', 'deployment.json');

try {
  const broadcastData = JSON.parse(fs.readFileSync(broadcastPath, 'utf8'));
  
  const contracts = {

    mock_erc_0: null,

    mock_erc_1: null,

    mini_amm: null

  };


  let mockErcCount = 0;


  for (const tx of broadcastData.transactions) {
    if (tx.transactionType === 'CREATE') {
      if (tx.contractName === 'MockERC20') {
        if (mockErcCount === 0) {
          contracts.mock_erc_0 = tx.contractAddress;
        } else if (mockErcCount === 1) {
          contracts.mock_erc_1 = tx.contractAddress;
        }
        mockErcCount++;
      } else if (tx.contractName === 'MiniAMM') {
        contracts.mini_amm = tx.contractAddress;
      }
    }
  }

  // deployment.json 파일 생성
  fs.writeFileSync(outputPath, JSON.stringify(contracts, null, 4));
  
  console.log(`✅ Contract addresses extracted to ${outputPath}:`);
  console.log(JSON.stringify(contracts, null, 2));
  
} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}