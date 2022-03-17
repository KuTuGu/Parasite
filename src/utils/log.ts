export function success(msg?: string) {
  if (msg) {
    window.$message.success(msg);
  }
}

export function info(msg?: string) {
  if (msg) {
    window.$message.info(msg);
  }
}

export function warning(msg?: string) {
  if (msg) {
    window.$message.warning(msg);
  }
}

export function error(msg?: string) {
  if (msg) {
    window.$message.error(msg);
  }
}
