import { NETWORK, NFT_TYPES } from "../config";
import * as Log from "./log";

export function init(): void {
  const serverUrl = import.meta.env.VITE_MORALIS_SERVER;
  const appId = import.meta.env.VITE_MORALIS_APP;

  Moralis.start({ serverUrl, appId });
}

export async function login() {
  try {
    const user = await Moralis.authenticate({ signingMessage: "Log in Parasite" });
    const addr = user.get("ethAddress");

    Log.success(`Log in as: ${addr}`);
    return addr;
  } catch(err) {
    Log.error(err.message ?? "Log in error");
  }
}

export async function logout() {
  try {
    const user = Moralis.User.current();
    const addr = user?.get?.("ethAddress");

    await Moralis.User.logOut();
    Log.warning(`Log out: ${addr}`);
  } catch(err) {
    Log.error(err.message ?? "Log out error");
  }
}

export function listenAccountChange(callback: (addr: string) => any) {
  Moralis.onAccountChanged(async (addr: string | null) => {
    try {
      if (addr) {
        await callback(addr);
        Log.success(`Change address to: ${addr}`);
      }
    } catch(err) {
      Log.error(err.message ?? "Account change callback error");
    }
  });
}

interface OptionInfo {
  label: string;
  value: string;
  image: string;
}

export async function getAllNFTs(address?: string): Promise<Array<OptionInfo>> {
  const arr: Array<OptionInfo> = [];

  try {
    const nfts = await Moralis.Web3API.account.getNFTs({ chain: NETWORK, address });
    await Promise.allSettled(nfts?.result?.map?.(async o => {
      if (NFT_TYPES.includes(o?.contract_type)) {
        let metadata: Record<string, any>;

        if (o?.metadata) {
          metadata = JSON.parse(o?.metadata);
        } else if (o?.token_uri) {
          const res = await fetch(o?.token_uri);
          metadata = await res.json();
        }

        if (metadata) {
          const v = `${metadata?.name}#${o?.token_id}`;
          if (metadata.image) {
            arr.push({
              label: v,
              value: v,
              image: metadata.image
            });
          }
        }
      }
    }) as Array<Promise<void>>);
  } catch(err) {
    Log.error(err.message ?? "Get account nfts error");
  }

  return arr;
}
