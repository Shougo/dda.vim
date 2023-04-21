import { batch, Denops, ensureObject, ensureString, vars } from "./deps.ts";
import { Dda } from "./dda.ts";

export async function main(denops: Denops) {
  denops.dispatcher = {
    async completion(
      arg1: unknown,
      arg2: unknown,
      arg3: unknown,
    ): Promise<void> {
      const prompt = ensureString(arg1);
      const suffix = ensureString(arg2);
      const userOptions = ensureObject(arg3);

      const dda = new Dda();

      await dda.completion(denops, userOptions, prompt, suffix);
    },
    async edit(arg1: unknown, arg2: unknown, arg3: unknown): Promise<void> {
      const input = ensureString(arg1);
      const instruction = ensureString(arg2);
      const userOptions = ensureObject(arg3);

      const dda = new Dda();

      await dda.edit(denops, userOptions, input, instruction);
    },
  };

  await batch(denops, async (denops: Denops) => {
    await vars.g.set(denops, "dda#_initialized", 1);
    await denops.cmd("doautocmd <nomodeline> User DDAReady");
    await denops.cmd("autocmd! User DDAReady");
  });
}
