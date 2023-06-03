// Generated by @wagmi/cli@1.0.2 on 5/30/2023 at 10:55:03 AM
import {
  getContract,
  GetContractArgs,
  writeContract,
  WriteContractMode,
  WriteContractArgs,
  WriteContractPreparedArgs,
  WriteContractUnpreparedArgs,
  prepareWriteContract,
  PrepareWriteContractConfig,
} from '@wagmi/core'

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Contract
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 *
 */
export const contractABI = [
  { stateMutability: 'payable', type: 'function', inputs: [], name: 'deposit', outputs: [] },
  { stateMutability: 'nonpayable', type: 'function', inputs: [], name: 'withdraw', outputs: [] },
] as const

/**
 *
 */
export const contractAddress = {
  31337: '0x5FbDB2315678afecb367f032d93F642f64180aa3',
} as const

/**
 *
 */
export const contractConfig = { address: contractAddress, abi: contractABI } as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Core
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Wraps __{@link getContract}__ with `abi` set to __{@link contractABI}__.
 *
 *
 */
export function getContract(
  config: Omit<GetContractArgs, 'abi' | 'address'> & { chainId?: keyof typeof contractAddress },
) {
  return getContract({ abi: contractABI, address: contractAddress[31337], ...config })
}

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link contractABI}__.
 *
 *
 */
export function writeContract<
  TFunctionName extends string,
  TMode extends WriteContractMode,
  TChainId extends number = keyof typeof contractAddress,
>(
  config:
    | (Omit<WriteContractPreparedArgs<typeof contractABI, TFunctionName>, 'abi' | 'address'> & {
        mode: TMode
        chainId?: TMode extends 'prepared' ? TChainId : keyof typeof contractAddress
      })
    | (Omit<WriteContractUnpreparedArgs<typeof contractABI, TFunctionName>, 'abi' | 'address'> & {
        mode: TMode
        chainId?: TMode extends 'prepared' ? TChainId : keyof typeof contractAddress
      }),
) {
  return writeContract({
    abi: contractABI,
    address: contractAddress[31337],
    ...config,
  } as unknown as WriteContractArgs<typeof contractABI, TFunctionName>)
}

/**
 * Wraps __{@link prepareWriteContract}__ with `abi` set to __{@link contractABI}__.
 *
 *
 */
export function prepareWriteContract<
  TAbi extends readonly unknown[] = typeof contractABI,
  TFunctionName extends string = string,
>(
  config: Omit<PrepareWriteContractConfig<TAbi, TFunctionName>, 'abi' | 'address'> & {
    chainId?: keyof typeof contractAddress
  },
) {
  return prepareWriteContract({
    abi: contractABI,
    address: contractAddress[31337],
    ...config,
  } as unknown as PrepareWriteContractConfig<TAbi, TFunctionName>)
}