# Copyright (c) 2016-2023 The Ruby-Eth Contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Provides the {Eth} module.
module Eth

  # Provides the `Eth::Api` module grouping known RPC commands.
  module Api

    # Implements the available RPC-APIs provided by Geth version 1.10.26.
    COMMANDS = [
      "account_ecRecover",
      "account_new",
      "account_signData",
      "account_signTransaction",
      "account_signTypedData",
      "admin_addPeer",
      "admin_addTrustedPeer",
      "admin_datadir",
      "admin_exportChain",
      "admin_importChain",
      "admin_nodeInfo",
      "admin_peerEvents",
      "admin_peers",
      "admin_removePeer",
      "admin_removeTrustedPeer",
      "admin_startHTTP",
      "admin_startWS",
      "admin_stopHTTP",
      "admin_stopWS",
      "clef_deriveAccount",
      "clef_listWallets",
      "clef_openWallet",
      "clique_discard",
      "clique_getSigner",
      "clique_getSigners",
      "clique_getSignersAtHash",
      "clique_getSnapshot",
      "clique_getSnapshotAtHash",
      "clique_proposals",
      "clique_propose",
      "clique_status",
      "db_getHex",
      "db_getString",
      "db_putHex",
      "db_putString",
      "debug_accountRange",
      "debug_backtraceAt",
      "debug_blockProfile",
      "debug_chaindbCompact",
      "debug_chaindbProperty",
      "debug_cpuProfile",
      "debug_dbAncient",
      "debug_dbAncients",
      "debug_dbGet",
      "debug_dumpBlock",
      "debug_freeOSMemory",
      "debug_freezeClient",
      "debug_gcStats",
      "debug_getAccessibleState",
      "debug_getBadBlocks",
      "debug_getBlockRlp",
      "debug_getHeaderRlp",
      "debug_getModifiedAccountsByHash",
      "debug_getModifiedAccountsByNumber",
      "debug_getRawBlock",
      "debug_getRawHeader",
      "debug_getRawReceipts",
      "debug_getRawTransaction",
      "debug_goTrace",
      "debug_intermediateRoots",
      "debug_memStats",
      "debug_mutexProfile",
      "debug_preimage",
      "debug_printBlock",
      "debug_seedHash",
      "debug_setBlockProfileRate",
      "debug_setGCPercent",
      "debug_setHead",
      "debug_setMutexProfileFraction",
      "debug_stacks",
      "debug_standardTraceBadBlockToFile",
      "debug_standardTraceBlockToFile",
      "debug_startCPUProfile",
      "debug_startGoTrace",
      "debug_stopCPUProfile",
      "debug_stopGoTrace",
      "debug_storageRangeAt",
      "debug_subscribe",
      "debug_traceBadBlock",
      "debug_traceBlock",
      "debug_traceBlockByHash",
      "debug_traceBlockByNumber",
      "debug_traceBlockFromFile",
      "debug_traceCall",
      "debug_traceChain",
      "debug_traceTransaction",
      "debug_verbosity",
      "debug_vmodule",
      "debug_writeBlockProfile",
      "debug_writeMemProfile",
      "debug_writeMutexProfile",
      "eth_accounts",
      "eth_blockNumber",
      "eth_call",
      "eth_chainId",
      "eth_compileLLL",
      "eth_compileSerpent",
      "eth_compileSolidity",
      "eth_createAccessList",
      "eth_estimateGas",
      "eth_feeHistory",
      "eth_gasPrice",
      "eth_getBalance",
      "eth_getBlockByHash",
      "eth_getBlockByNumber",
      "eth_getBlockTransactionCountByHash",
      "eth_getBlockTransactionCountByNumber",
      "eth_getCode",
      "eth_getCompilers",
      "eth_getFilterChanges",
      "eth_getFilterLogs",
      "eth_getLogs",
      "eth_getProof",
      "eth_getStorageAt",
      "eth_getTransactionByBlockHashAndIndex",
      "eth_getTransactionByBlockNumberAndIndex",
      "eth_getTransactionByHash",
      "eth_getTransactionCount",
      "eth_getTransactionReceipt",
      "eth_getUncleByBlockHashAndIndex",
      "eth_getUncleByBlockNumberAndIndex",
      "eth_getUncleCountByBlockHash",
      "eth_getUncleCountByBlockNumber",
      "eth_getWork",
      "eth_hashrate",
      "eth_maxPriorityFeePerGas",
      "eth_mining",
      "eth_newBlockFilter",
      "eth_newFilter",
      "eth_newPendingTransactionFilter",
      "eth_protocolVersion",
      "eth_sendRawTransaction",
      "eth_sendTransaction",
      "eth_sign",
      "eth_signTransaction",
      "eth_submitHashrate",
      "eth_submitWork",
      "eth_syncing",
      "eth_uninstallFilter",
      "eth_unsubscribe",
      "les_addBalance",
      "les_clientInfo",
      "les_getCheckpoint",
      "les_getCheckpointContractAddress",
      "les_latestCheckpoint",
      "les_priorityClientInfo",
      "les_serverInfo",
      "les_setClientParams",
      "les_setDefaultParams",
      "miner_getHashrate",
      "miner_setEtherbase",
      "miner_setExtra",
      "miner_setGasLimit",
      "miner_setGasPrice",
      "miner_setRecommitInterval",
      "miner_start",
      "miner_stop",
      "net_listening",
      "net_peerCount",
      "net_version",
      "personal_deriveAccount",
      "personal_ecRecover",
      "personal_importRawKey",
      "personal_initializeWallet",
      "personal_initializeWallets",
      "personal_listAccounts",
      "personal_listWallets",
      "personal_lockAccount",
      "personal_newAccount",
      "personal_openWallet",
      "personal_sendTransaction",
      "personal_sign",
      "personal_signTransaction",
      "personal_unlockAccount",
      "personal_unpair",
      "shh_addToGroup",
      "shh_getFilterChanges",
      "shh_getMessages",
      "shh_hasIdentity",
      "shh_newFilter",
      "shh_newGroup",
      "shh_newIdentity",
      "shh_post",
      "shh_uninstallFilter",
      "shh_version",
      "txpool_content",
      "txpool_contentFrom",
      "txpool_inspect",
      "txpool_status",
      "web3_clientVersion",
      "web3_sha3",
    ]
  end
end
