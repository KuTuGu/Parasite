import type { MessageApi } from "naive-ui"
import MoralisType from 'moralis/types';

declare global {
  const Moralis: MoralisType;
  interface Window {
    $message: MessageApi;
  }
}
