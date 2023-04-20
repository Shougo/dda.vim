import {
  batch,
  Denops,
  ensureObject,
  vars,
} from "./deps.ts";
import { Dda } from "./dda.ts";

export async function main(denops: Denops) {
  denops.dispatcher = {
    async start(arg1: unknown): Promise<void> {
      const userOptions = ensureObject(arg1);

      const dda = new Dda();

      await dda.start(denops, userOptions);
    },
  };

  await batch(denops, async (denops: Denops) => {
    await vars.g.set(denops, "dda#_initialized", 1);
    await denops.cmd("doautocmd <nomodeline> User DDAReady");
    await denops.cmd("autocmd! User DDAReady");
  });
}
